import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:tahania_app/services/localization/app_localizations.dart';
import 'package:tahania_app/features/greetings/widgets/greeting_type_selector.dart';
import 'package:tahania_app/features/greetings/widgets/occasion_selector.dart';
import 'package:tahania_app/features/greetings/widgets/contact_selector.dart';
import 'package:tahania_app/services/contact_utils.dart';

class SendGreetingScreen extends StatefulWidget {
  const SendGreetingScreen({super.key});

  @override
  State<SendGreetingScreen> createState() => _SendGreetingScreenState();
}

class _SendGreetingScreenState extends State<SendGreetingScreen> {
  // Controllers
  final TextEditingController _messageController = TextEditingController();
  
  // State variables
  Map<String, List<String>> occasionsByCategory = {};
  List<Map<String, String>> messageTypes = [];
  List<Contact> contacts = [];
  List<Contact> selectedContacts = [];
  
  String? selectedCategory;
  String? selectedOccasion;
  String? selectedType;
  String generatedMessage = '';
  bool isLoading = false;
  bool isGenerating = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    
    try {
      await Future.wait([
        _loadOccasions(),
        _loadMessageTypes(),
        _loadContacts(),
      ]);
    } catch (e) {
      _showError('حدث خطأ في تحميل البيانات: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadOccasions() async {
    try {
      final String response = await rootBundle.loadString('assets/data/occasions_by_category.json');
      final data = json.decode(response) as Map<String, dynamic>;
      setState(() {
        occasionsByCategory = data.map((key, value) => 
          MapEntry(key, List<String>.from(value))
        );
      });
    } catch (e) {
      _showError(AppLocalizations.of(context).translate('greetings.error.load_occasions'));
    }
  }

  Future<void> _loadMessageTypes() async {
    setState(() {
      messageTypes = [
        {'name': 'رسمية', 'emoji': '🏛️'},
        {'name': 'ودية', 'emoji': '😊'},
        {'name': 'عائلية', 'emoji': '👨‍👩‍👧‍👦'},
        {'name': 'دينية', 'emoji': '🕌'},
        {'name': 'مهنية', 'emoji': '💼'},
        {'name': 'شخصية', 'emoji': '💝'},
      ];
    });
  }

  Future<void> _loadContacts() async {
    try {
      print('🔄 بدء تحميل جهات الاتصال...');
      
      // التحقق من الإذن باستخدام permission_handler
      PermissionStatus permissionStatus = await Permission.contacts.status;
      print('📱 حالة الإذن الحالية: $permissionStatus');
      
      if (permissionStatus.isDenied) {
        print('🔄 طلب الإذن...');
        permissionStatus = await Permission.contacts.request();
        print('📱 حالة الإذن بعد الطلب: $permissionStatus');
      }
      
      if (permissionStatus.isPermanentlyDenied) {
        print('❌ تم رفض الإذن نهائياً');
        _showError('يرجى الذهاب إلى إعدادات التطبيق وتفعيل إذن جهات الاتصال');
        await openAppSettings();
        return;
      }
      
      if (!permissionStatus.isGranted) {
        print('❌ لم يتم منح الإذن');
        _showError('يرجى السماح بالوصول إلى جهات الاتصال لاستخدام هذه الميزة');
        return;
      }

      print('✅ تم منح الإذن، جاري جلب جهات الاتصال...');

      // جلب جهات الاتصال مع جميع التفاصيل
      final contactsList = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: false,
        withThumbnail: false,
        withAccounts: false,
        withGroups: false,
      );

      print('📞 تم جلب ${contactsList.length} جهة اتصال من الهاتف');

      // فلترة جهات الاتصال التي تحتوي على أرقام هواتف صالحة
      final validContacts = contactsList.where((contact) {
        bool hasValidPhone = contact.phones.isNotEmpty && 
                           contact.phones.any((phone) => phone.number.trim().isNotEmpty);
        bool hasValidName = contact.displayName.isNotEmpty;
        
        if (hasValidPhone && hasValidName) {
          print('✅ جهة اتصال صالحة: ${contact.displayName} - ${contact.phones.first.number}');
        }
        
        return hasValidPhone && hasValidName;
      }).toList();

      print('🎯 تم فلترة ${validContacts.length} جهة اتصال صالحة');

      setState(() {
        contacts = validContacts;
      });

      if (contacts.isEmpty) {
        _showError('لا توجد جهات اتصال صالحة (تحتوي على أسماء وأرقام هواتف)');
      } else {
        print('🎉 تم تحميل ${contacts.length} جهة اتصال بنجاح');
      }
    } catch (e) {
      print('❌ خطأ في تحميل جهات الاتصال: $e');
      _showError('حدث خطأ في تحميل جهات الاتصال. يرجى المحاولة مرة أخرى.');
    }
  }

  Future<void> _generateMessage() async {
    if (selectedType == null || selectedCategory == null || selectedOccasion == null) {
      _showError(AppLocalizations.of(context).translate('greetings.error.select_required'));
      return;
    }

    setState(() => isGenerating = true);

    try {
      // إنشاء prompt للذكاء الاصطناعي
      final prompt = _buildAIPrompt();
      
      // محاولة استخدام API الذكاء الاصطناعي
      final aiMessage = await _callAIAPI(prompt);
      
      if (aiMessage.isNotEmpty) {
        setState(() {
          generatedMessage = aiMessage;
          _messageController.text = aiMessage;
        });
      } else {
        // إظهار رسالة خطأ في حالة عدم توفر API
        _showError('يرجى إضافة مفتاح OpenAI API لتوليد الرسائل');
      }
    } catch (e) {
      _showError('حدث خطأ في توليد الرسالة: $e');
    } finally {
      setState(() => isGenerating = false);
    }
  }

  String _buildAIPrompt() {
    return '''
اكتب رسالة تهنئة باللغة العربية بالمواصفات التالية:
- نوع الرسالة: $selectedType
- نوع المناسبة: $selectedCategory  
- المناسبة: $selectedOccasion

المطلوب:
1. رسالة مناسبة للمناسبة المحددة
2. أسلوب ${selectedType == 'رسمية' ? 'رسمي ومهذب' : selectedType == 'ودية' ? 'ودود ومرح' : selectedType == 'عائلية' ? 'دافئ وعائلي' : selectedType == 'دينية' ? 'ديني ومبارك' : selectedType == 'مهنية' ? 'مهني ومحترم' : 'شخصي ومميز'}
3. طول مناسب (50-100 كلمة)
4. بدون توقيع في النهاية
5. استخدام تعبيرات مناسبة للثقافة العربية

اكتب الرسالة فقط بدون أي إضافات أخرى.
''';
  }

  Future<String> _callAIAPI(String prompt) async {
    try {
      // استخدام OpenAI ChatGPT API
      const String apiKey = 'YOUR_OPENAI_API_KEY_HERE'; // يجب وضع مفتاح API الحقيقي هنا
      
      if (apiKey == 'YOUR_OPENAI_API_KEY_HERE') {
        print('⚠️ يرجى إضافة مفتاح OpenAI API في الكود');
        return '';
      }

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': 'أنت مساعد ذكي متخصص في كتابة رسائل التهنئة باللغة العربية. اكتب رسائل مناسبة ومهذبة وفقاً للمناسبة ونوع الرسالة المطلوب.'
            },
            {
              'role': 'user',
              'content': prompt
            }
          ],
          'max_tokens': 300,
          'temperature': 0.7,
          'top_p': 1,
          'frequency_penalty': 0,
          'presence_penalty': 0,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final message = data['choices'][0]['message']['content'].trim();
        print('✅ تم توليد الرسالة بنجاح من ChatGPT');
        return message;
      } else {
        print('❌ خطأ في API: ${response.statusCode} - ${response.body}');
        return '';
      }
    } catch (e) {
      print('❌ خطأ في استدعاء ChatGPT API: $e');
      return '';
    }
  }


  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _sendToWhatsApp() async {
    if (selectedContacts.isEmpty) {
      _showError(AppLocalizations.of(context).translate('greetings.error.no_contacts'));
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
          final message = _messageController.text.trim();
          final whatsappUrl = 'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';
          
          if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
            await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
            await Future.delayed(const Duration(seconds: 1)); // تأخير بسيط بين الرسائل
          }
        }
      }
      _showSuccess('تم فتح الواتساب لإرسال الرسائل');
    } catch (e) {
      _showError('حدث خطأ في إرسال الرسائل: $e');
    }
  }

  Future<void> _shareMessage() async {
    if (_messageController.text.trim().isEmpty) {
      _showError('يرجى كتابة رسالة أولاً');
      return;
    }

    try {
      await Share.share(
        _messageController.text.trim(),
        subject: AppLocalizations.of(context).translate('greetings.share.subject'),
      );
    } catch (e) {
      _showError('حدث خطأ في المشاركة: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('greetings.send_greeting'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // نوع الرسالة
                  GreetingTypeSelector(
                    messageTypes: messageTypes,
                    selectedType: selectedType,
                    onTypeSelected: (type) => setState(() => selectedType = type),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // نوع المناسبة والمناسبة
                  OccasionSelector(
                    occasionsByCategory: occasionsByCategory,
                    selectedCategory: selectedCategory,
                    selectedOccasion: selectedOccasion,
                    onCategorySelected: (category) {
                      setState(() {
                        selectedCategory = category;
                        selectedOccasion = null;
                      });
                    },
                    onOccasionSelected: (occasion) => setState(() => selectedOccasion = occasion),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // جهات الاتصال
                  ContactSelector(
                    contacts: contacts,
                    selectedContacts: selectedContacts,
                    onContactsChanged: (contacts) => setState(() => selectedContacts = contacts),
                  ),
                  
                  // زر إعادة تحميل جهات الاتصال إذا كانت فارغة
                  if (contacts.isEmpty) ...[
                    const SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.contacts,
                              size: 48,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'لا توجد جهات اتصال',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'تأكد من منح الإذن للتطبيق للوصول إلى جهات الاتصال',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _loadContacts,
                              icon: const Icon(Icons.refresh),
                              label: const Text('إعادة تحميل جهات الاتصال'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // زر توليد الرسالة
                  _buildGenerateButton(),
                  
                  const SizedBox(height: 16),
                  
                  // معاينة الرسالة
                  if (generatedMessage.isNotEmpty) ...[
                    _buildSectionCard(
                      icon: Icons.preview,
                      title: AppLocalizations.of(context).translate('greetings.message_preview'),
                      child: _buildMessagePreview(),
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
      // أزرار الإجراءات في الأسفل
      bottomNavigationBar: generatedMessage.isNotEmpty
          ? _buildActionButtons()
          : null,
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
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
                Icon(icon, color: Theme.of(context).primaryColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return ElevatedButton.icon(
      onPressed: isGenerating ? null : _generateMessage,
      icon: isGenerating
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.auto_awesome),
      label: Text(
        isGenerating
            ? AppLocalizations.of(context).translate('greetings.generating')
            : AppLocalizations.of(context).translate('greetings.generate'),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
      ),
    );
  }

  Widget _buildMessagePreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _messageController,
          maxLines: 6,
          decoration: InputDecoration(
            hintText: 'اكتب رسالتك هنا...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 12),
        Text(
          'عدد الأحرف: ${_messageController.text.length}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
          textAlign: TextAlign.end,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // زر الواتساب
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _sendToWhatsApp,
              icon: const Icon(Icons.message, color: Colors.white),
              label: const Text(
                'إرسال عبر الواتساب',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366), // لون الواتساب الأخضر
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // زر المشاركة
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _shareMessage,
              icon: const Icon(Icons.share, color: Colors.white),
              label: const Text(
                'مشاركة عامة',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3), // لون أزرق
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
