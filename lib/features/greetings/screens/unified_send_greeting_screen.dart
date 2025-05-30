import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tahania_app/core/services/ai_service.dart';
import 'package:tahania_app/core/models/greeting.dart';
import 'package:tahania_app/core/models/message_category.dart';
import 'package:tahania_app/features/greetings/widgets/hierarchical_message_selector.dart';
import 'package:tahania_app/services/contact_utils.dart';
import 'package:tahania_app/services/settings_service.dart';

/// صفحة إرسال الرسائل الموحدة - كل شيء في صفحة واحدة
class UnifiedSendGreetingScreen extends StatefulWidget {
  const UnifiedSendGreetingScreen({super.key});

  @override
  State<UnifiedSendGreetingScreen> createState() => _UnifiedSendGreetingScreenState();
}

class _UnifiedSendGreetingScreenState extends State<UnifiedSendGreetingScreen> {
  // Controllers
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  
  // State variables
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  List<Contact> selectedContacts = [];
  
  String? selectedMessageType;
  String? selectedOccasion;
  String? selectedPurpose;
  String? senderName;
  String? defaultSignature;
  
  bool isLoading = false;
  bool isGenerating = false;
  bool isLoadingContacts = false;
  bool selectAll = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => isLoading = true);
    
    try {
      await Future.wait([
        _loadContacts(),
        _loadSettings(),
      ]);
    } catch (e) {
      _showError('حدث خطأ في تحميل البيانات: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadSettings() async {
    try {
      final name = await SettingsService.getSenderName();
      final signature = await SettingsService.getDefaultSignature();
      setState(() {
        senderName = name;
        defaultSignature = signature;
      });
    } catch (e) {
      print('خطأ في تحميل الإعدادات: $e');
    }
  }

  // متغيرات إضافية لتحميل جهات الاتصال تدريجيًا
  bool _isLoadingMoreContacts = false;
  bool _hasMoreContacts = true;
  int _contactsOffset = 0;
  final int _contactsLimit = 50;

  Future<void> _loadContacts() async {
    setState(() => isLoadingContacts = true);
    
    try {
      // التحقق من الإذن
      PermissionStatus permissionStatus = await Permission.contacts.status;
      
      if (permissionStatus.isDenied) {
        permissionStatus = await Permission.contacts.request();
      }
      
      if (permissionStatus.isPermanentlyDenied) {
        _showError('يرجى الذهاب إلى إعدادات التطبيق وتفعيل إذن جهات الاتصال');
        await openAppSettings();
        return;
      }
      
      if (!permissionStatus.isGranted) {
        _showError('يرجى السماح بالوصول إلى جهات الاتصال لاستخدام هذه الميزة');
        return;
      }

      // إعادة تعيين متغيرات التحميل التدريجي
      _contactsOffset = 0;
      _hasMoreContacts = true;
      contacts = [];
      
      // تحميل الدفعة الأولى من جهات الاتصال
      await _loadContactsBatch();
      
    } catch (e) {
      _showError('حدث خطأ في تحميل جهات الاتصال: $e');
    } finally {
      setState(() => isLoadingContacts = false);
    }
  }
  
  /// تحميل دفعة من جهات الاتصال
  Future<void> _loadContactsBatch() async {
    if (!_hasMoreContacts || _isLoadingMoreContacts) return;
    
    setState(() => _isLoadingMoreContacts = true);
    
    try {
      // جلب جهات الاتصال - تحميل الاسم والرقم فقط
      final contactsList = await FlutterContacts.getContacts(
        withProperties: true,  // ضروري للحصول على أرقام الهواتف
        withPhoto: false,
        withThumbnail: false,
        withAccounts: false,
        withGroups: false,
        limit: _contactsLimit,
        offset: _contactsOffset,
      );
      
      // تحديث المؤشر للدفعة التالية
      _contactsOffset += contactsList.length;
      
      // التحقق مما إذا كانت هناك المزيد من جهات الاتصال
      if (contactsList.length < _contactsLimit) {
        _hasMoreContacts = false;
      }

      // فلترة جهات الاتصال الصالحة
      final validContacts = contactsList.where((contact) {
        bool hasValidPhone = contact.phones.isNotEmpty && 
                           contact.phones.any((phone) => phone.number.trim().isNotEmpty);
        bool hasValidName = contact.displayName.isNotEmpty;
        return hasValidPhone && hasValidName;
      }).toList();

      // إضافة جهات الاتصال الجديدة إلى القائمة الحالية
      setState(() {
        contacts.addAll(validContacts);
        // ترتيب أبجدي
        contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
        filteredContacts = List.from(contacts);
      });

      if (contacts.isEmpty && !_hasMoreContacts) {
        _showError('لا توجد جهات اتصال صالحة');
      }
    } catch (e) {
      print('خطأ في تحميل دفعة جهات الاتصال: $e');
    } finally {
      setState(() => _isLoadingMoreContacts = false);
    }
  }

  void _filterContacts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredContacts = contacts;
      } else {
        filteredContacts = contacts.where((contact) =>
          contact.displayName.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    });
  }

  void _toggleSelectAll() {
    setState(() {
      selectAll = !selectAll;
      if (selectAll) {
        selectedContacts = List.from(filteredContacts);
      } else {
        selectedContacts.clear();
      }
    });
  }

  void _toggleContactSelection(Contact contact) {
    setState(() {
      if (selectedContacts.contains(contact)) {
        selectedContacts.remove(contact);
      } else {
        selectedContacts.add(contact);
      }
      selectAll = selectedContacts.length == filteredContacts.length;
    });
  }

  // التحقق من إمكانية توليد الرسالة
  bool _canGenerate() {
    return selectedMessageType != null &&
           selectedOccasion != null &&
           selectedPurpose != null &&
           selectedContacts.isNotEmpty &&
           !isGenerating;
  }

  Future<void> _generateMessage() async {
    if (selectedMessageType == null || selectedOccasion == null || selectedPurpose == null) {
      _showError('يرجى اختيار جميع التصنيفات المطلوبة');
      return;
    }

    if (selectedContacts.isEmpty) {
      _showError('يرجى اختيار جهة اتصال واحدة على الأقل');
      return;
    }

    setState(() => isGenerating = true);

    try {
      // بناء prompt محسن للذكاء الاصطناعي
      final prompt = _buildEnhancedAIPrompt();
      
      // استدعاء خدمة الذكاء الاصطناعي مع تمرير جميع المعاملات
      final greeting = await AIService.generateGreeting(
        prompt,
        senderName: senderName,
        recipientName: selectedContacts.first.displayName,
        messageType: selectedMessageType,
        occasion: selectedOccasion,
        purpose: selectedPurpose,
      );
      
      setState(() {
        _messageController.text = greeting.content;
      });
      
      _showSuccess('تم توليد الرسالة بنجاح');
      
    } catch (e) {
      print('❌ خطأ في توليد الرسالة: $e');
      _showError('حدث خطأ في توليد الرسالة. يرجى المحاولة مرة أخرى.');
    } finally {
      setState(() => isGenerating = false);
    }
  }

  String _buildEnhancedAIPrompt() {
    final recipientName = selectedContacts.first.displayName;
    final recipientTitle = _getAppropriateTitle(recipientName);
    
    return '''
اكتب رسالة تهنئة احترافية باللغة العربية الفصحى بالمواصفات التالية:

📋 معلومات الرسالة:
- نوع الرسالة: $selectedMessageType
- المناسبة: $selectedOccasion  
- غرض الرسالة: $selectedPurpose
- اسم المستلم: $recipientName
- لقب المستلم: $recipientTitle
- اسم المرسل: ${senderName ?? 'المرسل'}

📝 متطلبات الرسالة:
1. ابدأ بتحية افتتاحية مناسبة مثل "مع خالص التحية والتقدير" أو "السلام عليكم ورحمة الله وبركاته"
2. اذكر اسم المستلم مع اللقب المناسب: "$recipientTitle $recipientName"
3. اكتب محتوى مناسب للمناسبة والغرض المحدد
4. استخدم أسلوب ${_getStyleDescription()} 
5. اختتم بتوقيع أنيق: "مع أطيب التحيات\\n${senderName ?? 'المرسل'}"
6. طول الرسالة: 80-150 كلمة
7. استخدم تعبيرات مناسبة للثقافة العربية والإسلامية

🎯 التركيز على:
- ${_getPurposeDescription()}
- جعل الرسالة شخصية ومؤثرة
- استخدام لغة راقية ومهذبة
- تجنب التكرار والعبارات المبتذلة

اكتب الرسالة كاملة فقط بدون أي إضافات أو تعليقات.
''';
  }

  String _getAppropriateTitle(String name) {
    // تحديد اللقب المناسب بناءً على الاسم أو السياق
    if (selectedMessageType == 'مهنية') {
      return 'الأستاذ/الأستاذة';
    } else if (selectedMessageType == 'مدرسية وأكاديمية') {
      return 'الدكتور/الدكتورة';
    } else if (selectedMessageType == 'رسمية') {
      return 'المحترم/المحترمة';
    } else {
      return 'الكريم/الكريمة';
    }
  }

  String _getStyleDescription() {
    switch (selectedMessageType) {
      case 'مهنية':
        return 'مهني ومحترم مع الحفاظ على الطابع الرسمي';
      case 'عائلية واجتماعية':
        return 'دافئ وعائلي مع لمسة شخصية';
      case 'دينية':
        return 'ديني مبارك مع آيات أو أدعية مناسبة';
      case 'تعزية':
        return 'مواساة صادقة مع دعاء للمتوفى وأهله';
      case 'عاطفية وشخصية':
        return 'شخصي ومؤثر مع مشاعر صادقة';
      case 'وطنية':
        return 'وطني فخور يعبر عن الانتماء والولاء';
      case 'مدرسية وأكاديمية':
        return 'تعليمي محفز مع تشجيع للاستمرار';
      case 'مناسبات عالمية':
        return 'عالمي مناسب للمناسبة مع احترام التنوع';
      case 'رسمية':
        return 'رسمي بروتوكولي مع الحفاظ على الأدب';
      default:
        return 'مناسب للمناسبة مع الحفاظ على الأدب';
    }
  }

  String _getPurposeDescription() {
    switch (selectedPurpose) {
      case 'تهنئة':
        return 'التعبير عن الفرح والسعادة بالمناسبة';
      case 'فخر':
        return 'إظهار الفخر والاعتزاز بالإنجاز';
      case 'إشادة':
        return 'الثناء والإشادة بالجهود المبذولة';
      case 'تشجيع':
        return 'التحفيز والتشجيع للاستمرار';
      case 'دعاء':
        return 'الدعاء بالخير والبركة';
      case 'امتنان':
        return 'التعبير عن الشكر والامتنان';
      case 'دعم':
        return 'تقديم الدعم المعنوي والتضامن';
      case 'تعزية':
        return 'المواساة والدعاء للمتوفى وأهله';
      default:
        return 'التعبير المناسب للمناسبة';
    }
  }

  Future<void> _sendToWhatsApp() async {
    if (selectedContacts.isEmpty) {
      _showError('يرجى اختيار جهات اتصال أولاً');
      return;
    }

    if (_messageController.text.trim().isEmpty) {
      _showError('يرجى كتابة رسالة أولاً');
      return;
    }

    try {
      for (final contact in selectedContacts) {
        final phoneNumber = ContactUtils.getCleanPhoneNumber(contact);
        if (phoneNumber.isNotEmpty) {
          // توليد رسالة شخصية لكل جهة اتصال
          String personalizedMessage = await _generatePersonalizedMessage(contact);
          
          final whatsappUrl = 'whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(personalizedMessage)}';
          
          if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
            await launchUrl(
              Uri.parse(whatsappUrl),
              mode: LaunchMode.externalApplication,
            );
            await Future.delayed(const Duration(milliseconds: 800));
          } else {
            // محاولة بديلة باستخدام رابط الويب
            final webWhatsappUrl = 'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(personalizedMessage)}';
            await launchUrl(
              Uri.parse(webWhatsappUrl),
              mode: LaunchMode.externalApplication,
            );
            await Future.delayed(const Duration(milliseconds: 800));
          }
        }
      }
      _showSuccess('تم فتح الواتساب لإرسال الرسائل');
    } catch (e) {
      _showError('حدث خطأ في إرسال الرسائل: $e');
    }
  }

  Future<String> _generatePersonalizedMessage(Contact contact) async {
    // إذا كان هناك رسالة واحدة فقط، استخدم الرسالة الموجودة مع تخصيص الاسم
    String baseMessage = _messageController.text.trim();
    
    // استبدال اسم المستلم في الرسالة
    if (selectedContacts.length > 1) {
      // إذا كان هناك أكثر من جهة اتصال، قم بتوليد رسالة مخصصة لكل شخص
      try {
        final prompt = _buildPersonalizedPrompt(contact);
        final greeting = await AIService.generateGreeting(
          prompt,
          senderName: senderName,
          recipientName: contact.displayName,
          messageType: selectedMessageType,
          occasion: selectedOccasion,
          purpose: selectedPurpose,
        );
        return greeting.content;
      } catch (e) {
        // في حالة فشل التوليد، استخدم الرسالة الأساسية مع تخصيص الاسم
        return _personalizeExistingMessage(baseMessage, contact);
      }
    } else {
      return baseMessage;
    }
  }

  String _buildPersonalizedPrompt(Contact contact) {
    final recipientTitle = _getAppropriateTitle(contact.displayName);
    
    return '''
اكتب رسالة تهنئة احترافية باللغة العربية الفصحى بالمواصفات التالية:

📋 معلومات الرسالة:
- نوع الرسالة: $selectedMessageType
- المناسبة: $selectedOccasion  
- غرض الرسالة: $selectedPurpose
- اسم المستلم: ${contact.displayName}
- لقب المستلم: $recipientTitle
- اسم المرسل: ${senderName ?? 'المرسل'}

📝 متطلبات الرسالة:
1. ابدأ بتحية افتتاحية مناسبة
2. اذكر اسم المستلم مع اللقب: "$recipientTitle ${contact.displayName}"
3. اكتب محتوى مناسب للمناسبة والغرض
4. استخدم أسلوب ${_getStyleDescription()}
5. اختتم بتوقيع: "مع أطيب التحيات\\n${senderName ?? 'المرسل'}"
6. طول الرسالة: 80-150 كلمة

اكتب الرسالة كاملة فقط بدون أي إضافات أو تعليقات.
''';
  }

  String _personalizeExistingMessage(String message, Contact contact) {
    // استبدال أي اسم موجود في الرسالة باسم جهة الاتصال الحالية
    String personalizedMessage = message;
    
    // البحث عن أنماط الأسماء واستبدالها
    if (selectedContacts.isNotEmpty) {
      final firstContactName = selectedContacts.first.displayName;
      personalizedMessage = personalizedMessage.replaceAll(firstContactName, contact.displayName);
    }
    
    return personalizedMessage;
  }

  Future<void> _shareMessage() async {
    if (_messageController.text.trim().isEmpty) {
      _showError('يرجى كتابة رسالة أولاً');
      return;
    }

    try {
      await Share.share(
        _messageController.text.trim(),
        subject: 'رسالة تهنئة',
      );
    } catch (e) {
      _showError('حدث خطأ في المشاركة: $e');
    }
  }

  Future<void> _copyMessage() async {
    if (_messageController.text.trim().isEmpty) {
      _showError('لا توجد رسالة للنسخ');
      return;
    }

    try {
      await Clipboard.setData(ClipboardData(text: _messageController.text.trim()));
      _showSuccess('تم نسخ الرسالة');
    } catch (e) {
      _showError('حدث خطأ في النسخ: $e');
    }
  }

  void _clearMessage() {
    setState(() {
      _messageController.clear();
    });
    _showSuccess('تم مسح الرسالة');
  }

  void _openSettings() {
    Navigator.pushNamed(context, '/settings');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'إرسال رسالة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _openSettings,
            icon: const Icon(Icons.settings),
            tooltip: 'الإعدادات',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // قسم اختيار التصنيفات
                  _buildSelectionSection(),
                  
                  const SizedBox(height: 20),
                  
                  // قسم اختيار جهات الاتصال
                  _buildContactsSection(),
                  
                  const SizedBox(height: 20),
                  
                  // قسم تحرير الرسالة
                  _buildMessageSection(),
                  
                  const SizedBox(height: 20),
                  
                  // أزرار الإجراءات
                  _buildActionButtons(),
                ],
              ),
            ),
    );
  }

  Widget _buildSelectionSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.category, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'اختيار نوع الرسالة',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            HierarchicalMessageSelector(
              selectedMessageType: selectedMessageType,
              selectedOccasion: selectedOccasion,
              selectedPurpose: selectedPurpose,
              onMessageTypeChanged: (value) => setState(() => selectedMessageType = value),
              onOccasionChanged: (value) => setState(() => selectedOccasion = value),
              onPurposeChanged: (value) => setState(() => selectedPurpose = value),
              onGeneratePressed: _generateMessage,
              isGenerating: isGenerating,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.contacts, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'اختيار جهات الاتصال',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${selectedContacts.length} محدد',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // شريط البحث
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'البحث في جهات الاتصال...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: _filterContacts,
            ),
            
            const SizedBox(height: 12),
            
            // أزرار التحكم
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: _toggleSelectAll,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              selectAll ? Icons.deselect : Icons.select_all,
                              color: Theme.of(context).primaryColor,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              selectAll ? 'إلغاء تحديد الكل' : 'تحديد الكل',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: _loadContacts,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.refresh,
                              color: Colors.grey[600],
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'تحديث',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight
