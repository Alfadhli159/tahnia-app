import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../../../core/services/openai_service.dart';
import '../../../core/services/poster_generator.dart';
import 'dart:math';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SurpriseMessageScreen extends StatefulWidget {
  const SurpriseMessageScreen({super.key});

  @override
  State<SurpriseMessageScreen> createState() => _SurpriseMessageScreenState();
}

class _SurpriseMessageScreenState extends State<SurpriseMessageScreen>
    with TickerProviderStateMixin {
  final TextEditingController messageController = TextEditingController();
  final TextEditingController senderNameController = TextEditingController();
  final TextEditingController recipientNameController = TextEditingController();
  
  bool isGenerating = false;
  bool isMessageGenerated = false;
  String currentOccasion = '';
  String currentType = '';
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _surpriseController;
  late Animation<double> _surpriseAnimation;

  // Enhanced occasions with emojis and descriptions
  final List<Map<String, String>> occasions = [
    {'name': 'تهنئة عامة', 'emoji': '🎉', 'description': 'تهنئة عامة لأي مناسبة سعيدة'},
    {'name': 'عيد ميلاد', 'emoji': '🎂', 'description': 'تهنئة بعيد الميلاد'},
    {'name': 'نجاح', 'emoji': '🎓', 'description': 'تهنئة بالنجاح والتفوق'},
    {'name': 'زواج', 'emoji': '💍', 'description': 'تهنئة بالزواج'},
    {'name': 'مناسبة دينية', 'emoji': '🌙', 'description': 'تهنئة بالمناسبات الدينية'},
    {'name': 'تخرج', 'emoji': '🎓', 'description': 'تهنئة بالتخرج'},
    {'name': 'ترقية', 'emoji': '📈', 'description': 'تهنئة بالترقية'},
    {'name': 'مولود جديد', 'emoji': '👶', 'description': 'تهنئة بالمولود الجديد'},
    {'name': 'خطوبة', 'emoji': '💕', 'description': 'تهنئة بالخطوبة'},
    {'name': 'عيد الفطر', 'emoji': '🌙', 'description': 'تهنئة بعيد الفطر المبارك'},
    {'name': 'عيد الأضحى', 'emoji': '🕌', 'description': 'تهنئة بعيد الأضحى المبارك'},
    {'name': 'رمضان', 'emoji': '🌙', 'description': 'تهنئة بشهر رمضان المبارك'},
  ];

  final List<Map<String, String>> messageTypes = [
    {'name': 'نص', 'emoji': '📝', 'description': 'رسالة نصية تقليدية'},
    {'name': 'بوستر', 'emoji': '🖼️', 'description': 'رسالة مصممة للعرض'},
    {'name': 'ملصق', 'emoji': '🏷️', 'description': 'رسالة قصيرة ومختصرة'},
    {'name': 'شعري', 'emoji': '📜', 'description': 'رسالة شعرية جميلة'},
    {'name': 'رسمي', 'emoji': '🎩', 'description': 'رسالة رسمية ومهذبة'},
    {'name': 'ودود', 'emoji': '😊', 'description': 'رسالة ودودة وحميمة'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _surpriseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _surpriseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _surpriseController, curve: Curves.elasticOut),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _surpriseController.dispose();
    messageController.dispose();
    senderNameController.dispose();
    recipientNameController.dispose();
    super.dispose();
  }

  Future<void> generateSurpriseMessage() async {
    setState(() {
      isGenerating = true;
      isMessageGenerated = false;
    });

    // Random selection for surprise
    final random = Random();
    final selectedOccasion = occasions[random.nextInt(occasions.length)];
    final selectedType = messageTypes[random.nextInt(messageTypes.length)];
    
    currentOccasion = selectedOccasion['name']!;
    currentType = selectedType['name']!;

    // Build enhanced prompt
    String prompt = 'اكتب تهنئة ${selectedOccasion['name']} ';
    switch (selectedType['name']) {
      case 'بوستر':
        prompt += 'مناسبة للعرض على بوستر مميز وأنيقة';
        break;
      case 'ملصق':
        prompt += 'قصيرة ومختصرة تصلح كملصق';
        break;
      case 'شعري':
        prompt += 'بأسلوب شعري جميل ومؤثر';
        break;
      case 'رسمي':
        prompt += 'بأسلوب رسمي ومهذب';
        break;
      case 'ودود':
        prompt += 'بأسلوب ودود وحميم';
        break;
      default:
        prompt += 'نصية مميزة ومؤثرة';
    }
    prompt += ' باللغة العربية بأسلوب إبداعي';

    try {
      final generatedMessage = await OpenAIService.generateGreeting(prompt);
      
      // Format message with recipient and sender
      String formattedMessage = '';
      final recipientName = recipientNameController.text.trim();
      final senderName = senderNameController.text.trim();
      
      if (recipientName.isNotEmpty) {
        formattedMessage = '$recipientName العزيز/ة،\n\n';
      }
      
      formattedMessage += generatedMessage;
      
      if (senderName.isNotEmpty) {
        formattedMessage += '\n\n— $senderName';
      }
      
      messageController.text = formattedMessage;
      
      setState(() {
        isGenerating = false;
        isMessageGenerated = true;
      });
      
      _surpriseController.forward();
      
      // Show success feedback
      HapticFeedback.lightImpact();
      
    } catch (e) {
      setState(() {
        isGenerating = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ في توليد الرسالة. يرجى المحاولة مرة أخرى.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> copyMessage() async {
    if (messageController.text.trim().isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: messageController.text));
      HapticFeedback.selectionClick();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم نسخ الرسالة إلى الحافظة! 📋'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> shareMessage() async {
    if (messageController.text.trim().isNotEmpty) {
      await Share.share(
        messageController.text,
        subject: 'رسالة تهنئة من تطبيق تهانينا',
      );
    }
  }

  Future<void> sendViaWhatsApp() async {
    if (messageController.text.trim().isEmpty) return;
    
    // Show contact picker
    final contacts = await _getContacts();
    if (contacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا توجد جهات اتصال متاحة')),
      );
      return;
    }
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildContactPicker(contacts),
    );
  }

  Future<List<Contact>> _getContacts() async {
    await FlutterContacts.requestPermission();
    return await FlutterContacts.getContacts(withProperties: true);
  }

  Widget _buildContactPicker(List<Contact> contacts) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'اختر جهة الاتصال',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Text(
                          contact.displayName.isNotEmpty ? contact.displayName[0] : '?',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(contact.displayName),
                      subtitle: Text(
                        contact.phones.isNotEmpty ? contact.phones.first.number : 'بدون رقم',
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        if (contact.phones.isNotEmpty) {
                          _launchWhatsApp(contact.phones.first.number, messageController.text);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _launchWhatsApp(String phoneNumber, String message) async {
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    if (cleanNumber.startsWith('00')) {
      cleanNumber = '+${cleanNumber.substring(2)}';
    }
    
    if (cleanNumber.startsWith('05')) {
      cleanNumber = '+966${cleanNumber.substring(1)}';
    }
    
    final uri = Uri.parse('whatsapp://send?phone=$cleanNumber&text=${Uri.encodeComponent(message)}');
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        final webUri = Uri.parse('https://wa.me/$cleanNumber?text=${Uri.encodeComponent(message)}');
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل في فتح واتساب')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('فاجئني برسالة! ✨'),
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.purple.withOpacity(0.1),
                Colors.white,
              ],
            ),
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [Colors.purple, Colors.purple.shade300],
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.auto_awesome, size: 48, color: Colors.white),
                          const SizedBox(height: 12),
                          const Text(
                            'فاجئني برسالة تهنئة!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'دع الذكاء الاصطناعي يختار لك مناسبة ونوع رسالة مفاجئة',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Input Fields
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'معلومات الرسالة (اختيارية)',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: recipientNameController,
                            decoration: InputDecoration(
                              labelText: 'اسم المستلم',
                              hintText: 'أدخل اسم الشخص المستلم',
                              prefixIcon: const Icon(Icons.person_outline),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: senderNameController,
                            decoration: InputDecoration(
                              labelText: 'اسم المرسل',
                              hintText: 'أدخل اسمك',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Generate Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: isGenerating ? null : generateSurpriseMessage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 8,
                      ),
                      child: isGenerating
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text('جاري التوليد...', style: TextStyle(fontSize: 18)),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.auto_awesome, size: 24),
                                const SizedBox(width: 8),
                                const Text('فاجئني برسالة!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ],
                            ),
                    ),
                  ),
                  
                  if (isMessageGenerated) ...[
                    const SizedBox(height: 24),
                    
                    // Generated Message Info
                    ScaleTransition(
                      scale: _surpriseAnimation,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.info_outline, color: Colors.purple),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'تفاصيل الرسالة المولدة',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.purple.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'المناسبة: $currentOccasion',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'النوع: $currentType',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Message Display
                    ScaleTransition(
                      scale: _surpriseAnimation,
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'الرسالة المولدة ✨',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: TextField(
                                  controller: messageController,
                                  maxLines: null,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'الرسالة ستظهر هنا...',
                                  ),
                                  style: const TextStyle(fontSize: 16, height: 1.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Action Buttons
                    ScaleTransition(
                      scale: _surpriseAnimation,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'خيارات الإرسال والمشاركة',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: copyMessage,
                                      icon: const Icon(Icons.copy),
                                      label: const Text('نسخ'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: shareMessage,
                                      icon: const Icon(Icons.share),
                                      label: const Text('مشاركة'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: sendViaWhatsApp,
                                  icon: const Icon(Icons.send),
                                  label: const Text('إرسال عبر واتساب'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Generate Another Button
                    ScaleTransition(
                      scale: _surpriseAnimation,
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _surpriseController.reset();
                            generateSurpriseMessage();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('فاجئني برسالة أخرى!'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.purple,
                            side: const BorderSide(color: Colors.purple, width: 2),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Tips Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lightbulb_outline, color: Colors.amber),
                              const SizedBox(width: 8),
                              const Text(
                                'نصائح للحصول على أفضل النتائج',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '• أدخل اسم المستلم للحصول على رسالة شخصية\n'
                            '• أضف اسمك كمرسل لتوقيع الرسالة\n'
                            '• يمكنك تعديل الرسالة بعد توليدها\n'
                            '• جرب الضغط على "فاجئني برسالة أخرى" للحصول على أنواع مختلفة',
                            style: TextStyle(fontSize: 14, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
