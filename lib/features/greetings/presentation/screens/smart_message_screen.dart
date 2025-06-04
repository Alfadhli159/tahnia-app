import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tahania_app/features/greetings/services/ai_service.dart';
import 'dart:math';

class SmartMessageScreen extends StatefulWidget {
  const SmartMessageScreen({super.key});

  @override
  State<SmartMessageScreen> createState() => _SmartMessageScreenState();
}

class _SmartMessageScreenState extends State<SmartMessageScreen>
    with TickerProviderStateMixin {
  final TextEditingController customPromptController = TextEditingController();
  final TextEditingController senderNameController = TextEditingController();
  final TextEditingController recipientNameController = TextEditingController();
  final TextEditingController generatedMessageController =
      TextEditingController();

  bool isGenerating = false;
  bool isMessageGenerated = false;
  String currentOccasion = '';
  String currentMessageType = '';
  late AnimationController _surpriseAnimation;

  final List<String> occasions = [
    'عيد ميلاد',
    'زواج',
    'نجاح',
    'تخرج',
    'ترقية',
    'عيد الفطر',
    'عيد الأضحى',
    'رمضان',
    'العام الجديد',
    'عيد الأم',
    'عيد الأب',
    'خطوبة',
    'مولود جديد',
    'شفاء',
    'سفر آمن',
  ];

  final List<String> messageTypes = [
    'نص بسيط',
    'بوستر',
    'ملصق',
    'شعري',
    'رسمي',
    'ودود',
    'مؤثر',
    'مختصر',
  ];

  @override
  void initState() {
    super.initState();
    _surpriseAnimation = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    customPromptController.dispose();
    senderNameController.dispose();
    recipientNameController.dispose();
    generatedMessageController.dispose();
    _surpriseAnimation.dispose();
    super.dispose();
  }

  Future<void> generateSmartMessage({bool surprise = false}) async {
    if (isGenerating) return;

    setState(() {
      isGenerating = true;
      isMessageGenerated = false;
    });

    try {
      String prompt;
      String occasion;
      String messageType;

      if (surprise) {
        // وضع المفاجأة - اختيار عشوائي
        final random = Random();
        occasion = occasions[random.nextInt(occasions.length)];
        messageType = messageTypes[random.nextInt(messageTypes.length)];
        prompt = 'اكتب رسالة $messageType لمناسبة $occasion';

        // تأثير الرسوم المتحركة للمفاجأة
        _surpriseAnimation.forward().then((_) {
          _surpriseAnimation.reverse();
        });
      } else {
        // استخدام النص المخصص
        prompt = customPromptController.text.trim();
        occasion = 'مخصص';
        messageType = 'حسب الطلب';
      }

      if (prompt.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('يرجى كتابة نص للذكاء الاصطناعي أو استخدام زر المفاجأة'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // إضافة أسماء المرسل والمستقبل إذا كانت متوفرة
      if (senderNameController.text.isNotEmpty) {
        prompt += '\nاسم المرسل: ${senderNameController.text}';
      }
      if (recipientNameController.text.isNotEmpty) {
        prompt += '\nاسم المستقبل: ${recipientNameController.text}';
      }

      final greeting = await AIService.generateGreeting(
        prompt,
        senderName: senderNameController.text.isNotEmpty
            ? senderNameController.text
            : null,
        recipientName: recipientNameController.text.isNotEmpty
            ? recipientNameController.text
            : null,
        messageType: messageType,
        occasion: occasion,
      );
      final generatedMessage = greeting.content;

      setState(() {
        generatedMessageController.text = generatedMessage;
        currentOccasion = occasion;
        currentMessageType = messageType;
        isMessageGenerated = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم توليد الرسالة بنجاح!'),
            backgroundColor: Color(0xFF2196F3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في توليد الرسالة: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        isGenerating = false;
      });
    }
  }

  void clearMessage() {
    setState(() {
      generatedMessageController.clear();
      isMessageGenerated = false;
      currentOccasion = '';
      currentMessageType = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // خلفية بيضاء
      appBar: AppBar(
        title: const Text(
          'الرسالة الذكية',
          style: TextStyle(
            color: Colors.white, // نص أبيض
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2196F3), // هيدر أزرق
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // معلومات الذكاء الاصطناعي
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF1976D2)], // تدرج أزرق
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.white, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مولد الرسائل الذكي',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'استخدم الذكاء الاصطناعي لتوليد رسائل مخصصة ومميزة',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // النص المخصص للذكاء الاصطناعي
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'اكتب طلبك للذكاء الاصطناعي',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'مثال: اكتب رسالة تهنئة بالزواج بأسلوب شعري',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: customPromptController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'اكتب طلبك هنا...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF2196F3)),
                      ),
                      filled: false,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // بيانات الرسالة
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'بيانات الرسالة',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: senderNameController,
                    decoration: InputDecoration(
                      labelText: 'اسم المرسل (اختياري)',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF2196F3)),
                      ),
                      filled: false,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: recipientNameController,
                    decoration: InputDecoration(
                      labelText: 'اسم المستقبل (اختياري)',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF2196F3)),
                      ),
                      filled: false,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // خيارات التوليد
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'طريقة التوليد',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // زر المفاجأة
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isGenerating
                          ? null
                          : () => generateSmartMessage(surprise: true),
                      icon: isGenerating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.auto_awesome),
                      label: Text(
                        isGenerating ? 'جاري التوليد...' : '🎲 فاجئني برسالة',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3), // أزرق
                        foregroundColor: Colors.white, // نص أبيض
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // زر التوليد المخصص
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isGenerating
                          ? null
                          : () => generateSmartMessage(surprise: false),
                      icon: isGenerating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.create),
                      label: Text(
                        isGenerating ? 'جاري التوليد...' : 'توليد رسالة مخصصة',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3), // أزرق
                        foregroundColor: Colors.white, // نص أبيض
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // عرض معلومات الرسالة المولدة
            if (isMessageGenerated && currentOccasion.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: const Color(0xFF2196F3).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFF2196F3)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'المناسبة: $currentOccasion • النوع: $currentMessageType',
                        style: const TextStyle(
                          color: Color(0xFF2196F3),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // الرسالة المولدة
            if (isMessageGenerated) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.message, color: Color(0xFF2196F3)),
                        const SizedBox(width: 8),
                        const Text(
                          'الرسالة المولدة',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2196F3),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: clearMessage,
                          icon: const Icon(Icons.clear, color: Colors.red),
                          tooltip: 'مسح الرسالة',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: generatedMessageController,
                      maxLines: 8,
                      decoration: InputDecoration(
                        hintText: 'ستظهر الرسالة المولدة هنا...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFF2196F3)),
                        ),
                        filled: false,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // أزرار الإجراءات
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await Clipboard.setData(ClipboardData(
                                  text: generatedMessageController.text));
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('تم نسخ الرسالة'),
                                    backgroundColor: Color(0xFF2196F3),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.copy),
                            label: const Text('نسخ'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2196F3),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Share.share(generatedMessageController.text);
                            },
                            icon: const Icon(Icons.share),
                            label: const Text('مشاركة'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2196F3),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
