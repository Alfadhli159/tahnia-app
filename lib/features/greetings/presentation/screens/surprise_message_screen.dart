import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/ai_service.dart';

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

  final List<Map<String, String>> occasions = [
    {'name': 'تهنئة عامة', 'emoji': '🎉'},
    {'name': 'عيد ميلاد', 'emoji': '🎂'},
    {'name': 'نجاح', 'emoji': '🎓'},
    {'name': 'زواج', 'emoji': '💍'},
    {'name': 'تخرج', 'emoji': '🎓'},
    {'name': 'ترقية', 'emoji': '📈'},
    {'name': 'مولود جديد', 'emoji': '👶'},
    {'name': 'خطوبة', 'emoji': '💕'},
    {'name': 'عيد الفطر', 'emoji': '🌙'},
    {'name': 'عيد الأضحى', 'emoji': '🕌'},
  ];

  final List<Map<String, String>> messageTypes = [
    {'name': 'نص', 'emoji': '📝'},
    {'name': 'بوستر', 'emoji': '🖼️'},
    {'name': 'ملصق', 'emoji': '🏷️'},
    {'name': 'شعري', 'emoji': '📜'},
    {'name': 'رسمي', 'emoji': '🎩'},
    {'name': 'ودود', 'emoji': '😊'},
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

    final random = Random();
    final selectedOccasion = occasions[random.nextInt(occasions.length)];
    final selectedType = messageTypes[random.nextInt(messageTypes.length)];

    currentOccasion = selectedOccasion['name']!;
    currentType = selectedType['name']!;

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
      final greeting = await AIService.generateGreeting(
        prompt,
        senderName: senderNameController.text.trim(),
        recipientName: recipientNameController.text.trim(),
      );

      messageController.text = greeting.content;

      setState(() {
        isGenerating = false;
        isMessageGenerated = true;
      });

      _surpriseController.forward();
      HapticFeedback.lightImpact();
    } on AIServiceException catch (e) {
      setState(() {
        isGenerating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      setState(() {
        isGenerating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.'),
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
    if (messageController.text.trim().isNotEmpty) {
      final message = Uri.encodeComponent(messageController.text);
      final whatsappUrl = 'https://wa.me/?text=$message';

      try {
        if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
          await launchUrl(Uri.parse(whatsappUrl),
              mode: LaunchMode.externalApplication);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('لا يمكن فتح واتساب. تأكد من تثبيت التطبيق.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('حدث خطأ أثناء فتح واتساب.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) => Directionality(
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
                Colors.purple.withValues(alpha: 0.1),
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
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
                          const Icon(Icons.auto_awesome,
                              size: 48, color: Colors.white),
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
                              color: Colors.white.withValues(alpha: 0.9),
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'معلومات الرسالة (اختيارية)',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: recipientNameController,
                            decoration: InputDecoration(
                              labelText: 'اسم المستلم',
                              hintText: 'أدخل اسم الشخص المستلم',
                              prefixIcon: const Icon(Icons.person_outline),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: senderNameController,
                            decoration: InputDecoration(
                              labelText: 'اسم المرسل',
                              hintText: 'أدخل اسمك',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text('جاري التوليد...',
                                    style: TextStyle(fontSize: 18)),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.auto_awesome, size: 24),
                                const SizedBox(width: 8),
                                const Text('فاجئني برسالة!',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.info_outline,
                                      color: Colors.purple),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'تفاصيل الرسالة المولدة',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.purple.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'المناسبة: $currentOccasion',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.green.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'النوع: $currentType',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'الرسالة المولدة ✨',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
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
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                  textDirection: TextDirection.rtl,
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'خيارات الإرسال والمشاركة',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
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
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
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
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
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
                                  icon: const Icon(Icons.message,
                                      color: Colors.white),
                                  label: const Text('أرسل عبر واتساب',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF25D366),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    elevation: 4,
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
                          label: const Text('🎲 جرب مرة أخرى!'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.purple,
                            side: const BorderSide(
                                color: Colors.purple, width: 2),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Tips Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lightbulb_outline,
                                  color: Colors.amber),
                              const SizedBox(width: 8),
                              const Text(
                                'نصائح للحصول على أفضل النتائج',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '• أدخل اسم المستلم للحصول على رسالة شخصية\n'
                            '• أضف اسمك كمرسل لتوقيع الرسالة\n'
                            '• يمكنك تعديل الرسالة بعد توليدها\n'
                            '• جرب الضغط على "جرب مرة أخرى" للحصول على أنواع مختلفة',
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
