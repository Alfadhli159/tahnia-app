import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tahania_app/core/services/ai_service.dart';
import 'package:tahania_app/core/models/greeting.dart';
import 'package:tahania_app/core/models/message_category.dart';
import 'package:tahania_app/features/greetings/widgets/hierarchical_message_selector.dart';
import 'package:tahania_app/features/greetings/widgets/enhanced_message_editor.dart';
import 'package:tahania_app/features/greetings/widgets/enhanced_contact_selector.dart';
import 'package:tahania_app/services/contact_utils.dart';
import 'package:tahania_app/services/settings_service.dart';

/// صفحة إرسال الرسائل المحسنة مع النظام المتدرج
class EnhancedSendGreetingScreen extends StatefulWidget {
  const EnhancedSendGreetingScreen({super.key});

  @override
  State<EnhancedSendGreetingScreen> createState() => _EnhancedSendGreetingScreenState();
}

class _EnhancedSendGreetingScreenState extends State<EnhancedSendGreetingScreen>
    with TickerProviderStateMixin {
  // Controllers
  final TextEditingController _messageController = TextEditingController();
  final PageController _pageController = PageController();
  
  // State variables
  List<Contact> contacts = [];
  List<Contact> selectedContacts = [];
  
  String? selectedMessageType;
  String? selectedOccasion;
  String? selectedPurpose;
  String? senderName;
  
  bool isLoading = false;
  bool isGenerating = false;
  bool isLoadingContacts = false;
  int currentStep = 0;
  
  // Animation controllers
  late AnimationController _stepAnimationController;
  late Animation<double> _stepAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadInitialData();
    _testPhoneNumberFormatting(); // Test phone number formatting
  }

  void _initializeAnimations() {
    _stepAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _stepAnimation = CurvedAnimation(
      parent: _stepAnimationController,
      curve: Curves.easeInOut,
    );
    
    _stepAnimationController.forward();
  }

  Future<void> _loadInitialData() async {
    setState(() => isLoading = true);
    
    try {
      await Future.wait([
        _loadContacts(),
        _loadSenderName(),
      ]);
    } catch (e) {
      _showError('حدث خطأ في تحميل البيانات: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadSenderName() async {
    try {
      final name = await SettingsService.getSenderName();
      setState(() {
        senderName = name;
      });
    } catch (e) {
      print('خطأ في تحميل اسم المرسل: $e');
    }
  }

  Future<void> _loadContacts() async {
    setState(() => isLoadingContacts = true);
    
    try {
      print('🔄 بدء تحميل جهات الاتصال...');
      
      // التحقق من الإذن
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

      // جلب جهات الاتصال
      final contactsList = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: false,
        withThumbnail: false,
        withAccounts: false,
        withGroups: false,
      );

      print('📞 تم جلب ${contactsList.length} جهة اتصال من الهاتف');

      // فلترة جهات الاتصال الصالحة
      final validContacts = contactsList.where((contact) {
        bool hasValidPhone = contact.phones.isNotEmpty && 
                           contact.phones.any((phone) => phone.number.trim().isNotEmpty);
        bool hasValidName = contact.displayName.isNotEmpty;
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
    } finally {
      setState(() => isLoadingContacts = false);
    }
  }

  void _nextStep() {
    if (currentStep < 2) {
      setState(() => currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
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

  Widget _buildNavigationButtons() {
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
      child: currentStep == 2 
        ? _buildActionButtons() 
        : currentStep == 1
          ? _buildContactNavigationButtons()
          : _buildCategoryNavigationButton(),
    );
  }

  Widget _buildContactNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Previous button
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.35,
          child: ElevatedButton.icon(
            onPressed: _previousStep,
            icon: const Icon(Icons.arrow_back, size: 20),
            label: const Text(
              'السابق',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        
        // Next button
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.35,
          child: ElevatedButton.icon(
            onPressed: selectedContacts.isNotEmpty ? _nextStep : null,
            icon: const Icon(Icons.arrow_forward, size: 20),
            label: const Text(
              'التالي',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryNavigationButton() {
    final bool canProceed = selectedMessageType != null && 
                          selectedOccasion != null && 
                          selectedPurpose != null;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: canProceed ? _nextStep : null,
        icon: const Icon(Icons.arrow_forward),
        label: const Text(
          'التالي',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
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
          : Column(
              children: [
                // مؤشر التقدم
                _buildProgressIndicator(),
                
                // محتوى الصفحات
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) => setState(() => currentStep = index),
                    children: [
                      // الخطوة 1: اختيار التصنيفات
                      _buildSelectionStep(),
                      
                      // الخطوة 2: اختيار جهات الاتصال
                      _buildContactsStep(),
                      
                      // الخطوة 3: تحرير وإرسال الرسالة
                      _buildMessageStep(),
                    ],
                  ),
                ),
                
                // أزرار التنقل
                _buildNavigationButtons(),
              ],
            ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // الأيقونات والخطوط الواصلة على نفس المستوى
          Row(
            children: [
              _buildStepIcon(0, Icons.category),
              _buildStepConnector(0),
              _buildStepIcon(1, Icons.contacts),
              _buildStepConnector(1),
              _buildStepIcon(2, Icons.message),
            ],
          ),
          const SizedBox(height: 12),
          // النصوص أسفل الأيقونات
          Row(
            children: [
              _buildStepLabel(0, 'اختيار التصنيف'),
              const Spacer(),
              _buildStepLabel(1, 'جهات الاتصال'),
              const Spacer(),
              _buildStepLabel(2, 'الرسالة'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepIcon(int step, IconData icon) {
    final isActive = currentStep == step;
    final isCompleted = currentStep > step;
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isCompleted 
            ? Colors.green
            : isActive 
                ? Theme.of(context).primaryColor
                : Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: Icon(
        isCompleted ? Icons.check : icon,
        color: isCompleted || isActive ? Colors.white : Colors.grey[600],
        size: 20,
      ),
    );
  }

  Widget _buildStepConnector(int step) {
    final isCompleted = currentStep > step;
    
    return Expanded(
      child: Container(
        height: 2,
        color: isCompleted ? Colors.green : Colors.grey[300],
      ),
    );
  }

  Widget _buildStepLabel(int step, String title) {
    final isActive = currentStep == step;
    
    return Expanded(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? Theme.of(context).primaryColor : Colors.grey[600],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSelectionStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: HierarchicalMessageSelector(
        selectedMessageType: selectedMessageType,
        selectedOccasion: selectedOccasion,
        selectedPurpose: selectedPurpose,
        onMessageTypeChanged: (value) => setState(() => selectedMessageType = value),
        onOccasionChanged: (value) => setState(() => selectedOccasion = value),
        onPurposeChanged: (value) => setState(() => selectedPurpose = value),
        onGeneratePressed: _generateMessage,
        isGenerating: isGenerating,
      ),
    );
  }

  Widget _buildContactsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: EnhancedContactSelector(
        contacts: contacts,
        selectedContacts: selectedContacts,
        onContactsChanged: (contacts) => setState(() => selectedContacts = contacts),
        onRefreshContacts: _loadContacts,
      ),
    );
  }

  Widget _buildMessageStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // زر توليد الرسالة
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton.icon(
              onPressed: isGenerating ? null : _generateMessage,
              icon: isGenerating 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(
                isGenerating ? 'جاري توليد الرسالة...' : 'توليد رسالة تلقائياً',
                style: const TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          // محرر الرسالة
          EnhancedMessageEditor(
            controller: _messageController,
            senderName: senderName,
            recipientName: selectedContacts.isNotEmpty ? selectedContacts.first.displayName : null,
            onSignatureTap: _openSettings,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _pageController.dispose();
    _stepAnimationController.dispose();
    super.dispose();
  }

  void _openSettings() async {
    final result = await Navigator.pushNamed(context, '/settings');
    if (result == true) {
      _loadSenderName();
    }
  }

  Future<void> _generateMessage() async {
    if (isGenerating) return;

    setState(() => isGenerating = true);

    try {
      // Build the prompt from selected options
      final prompt = 'توليد رسالة ${selectedMessageType ?? ''} '
          'بمناسبة ${selectedOccasion ?? ''} '
          'بغرض ${selectedPurpose ?? ''}';

      final greeting = await AIService.generateGreeting(
        prompt,
        messageType: selectedMessageType,
        occasion: selectedOccasion,
        purpose: selectedPurpose,
        recipientName: selectedContacts.first.displayName,
        senderName: senderName,
      );

      setState(() {
        _messageController.text = greeting.content;
      });

      _showSuccess('تم توليد الرسالة بنجاح');
    } catch (e) {
      _showError('حدث خطأ في توليد الرسالة: $e');
    } finally {
      setState(() => isGenerating = false);
    }
  }

  Widget _buildActionButtons() {
    final message = _messageController.text.trim();
    final hasMessage = message.isNotEmpty;
    
    return Row(
      children: [
        // Previous button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _previousStep,
            icon: const Icon(Icons.arrow_back),
            label: const Text('السابق'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Share button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: hasMessage ? () => Share.share(message) : null,
            icon: const Icon(Icons.share),
            label: const Text('مشاركة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Send button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: hasMessage ? _sendMessage : null,
            icon: const Icon(Icons.send),
            label: const Text('إرسال'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Removed _formatPhoneNumber method to use ContactUtils instead

  // Test phone number formatting
  void _testPhoneNumberFormatting() {
    final testCases = {
      '+966501234567': '966501234567',    // International format with +
      '00966501234567': '966501234567',   // International format with 00
      '0501234567': '966501234567',       // Local Saudi format with 0
      '501234567': '966501234567',        // Local Saudi format without 0
      '+966 50-123-4567': '966501234567', // With spaces and special chars
      '966501234567': '966501234567',     // Already in correct format
    };
    
    print('\n🧪 Testing phone number formatting:');
    testCases.forEach((input, expected) {
      final testContact = Contact(
        displayName: 'Test User',
        phones: [Phone(input)],
      );
      final result = ContactUtils.getCleanPhoneNumber(testContact);
      final passed = result == expected;
      print('${passed ? '✅' : '❌'} Input: $input');
      print('   Expected: $expected');
      print('   Got: $result\n');
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    try {
      for (final contact in selectedContacts) {
        final phone = ContactUtils.getCleanPhoneNumber(contact);
        print('📱 Formatted phone number: $phone');

        // Encode message with proper handling of special characters
        final encodedMessage = Uri.encodeComponent(message)
            .replaceAll('+', '%20')
            .replaceAll('%0A', '%0D%0A')
            .replaceAll('%E2%80%8E', '');

        try {
          // Try web.whatsapp.com first
          final webUrl = Uri.parse('https://web.whatsapp.com/send?phone=$phone&text=$encodedMessage');
          print('🌐 Trying web URL: $webUrl');

          if (await canLaunchUrl(webUrl)) {
            await launchUrl(webUrl);
            continue;
          }
        } catch (e) {
          print('❌ Failed to launch web URL: $e');
        }

        // Fallback to WhatsApp app
        try {
          final appUrl = Uri.parse('whatsapp://send?phone=$phone&text=$encodedMessage');
          if (await canLaunchUrl(appUrl)) {
            await launchUrl(appUrl);
          } else {
            _showError('يرجى تثبيت تطبيق واتساب لإرسال الرسائل');
          }
        } catch (e) {
          _showError('حدث خطأ في إرسال الرسالة: $e');
        }
      }
    } catch (e) {
      _showError('حدث خطأ أثناء إرسال الرسالة: $e');
    }
  }
}
