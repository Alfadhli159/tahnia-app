import 'package:flutter/material.dart';
// تم تعليق هذا الاستيراد تلقائياً: import 'package:tahania_app/services/smart_greeting_service.dart';
// تم تعليق هذا الاستيراد تلقائياً: import 'package:tahania_app/services/condolence_service.dart';
// تم تعليق هذا الاستيراد تلقائياً: import 'package:tahania_app/widgets/animated_text_field.dart';
// تم تعليق هذا الاستيراد تلقائياً: import 'package:tahania_app/widgets/animated_button.dart';
// تم تعليق هذا الاستيراد تلقائياً: import 'package:tahania_app/widgets/animated_dropdown.dart';
import 'package:tahania_app/widgets/animated_card.dart';
// تم تعليق هذا الاستيراد تلقائياً: import 'package:tahania_app/widgets/sticker_picker.dart';
import 'package:tahania_app/config/theme/app_theme.dart';

class SendGreetingScreen extends StatefulWidget {
  const SendGreetingScreen({Key? key}) : super(key: key);

  @override
  State<SendGreetingScreen> createState() => _SendGreetingScreenState();
}

class _SendGreetingScreenState extends State<SendGreetingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final _recipientController = TextEditingController();
  final _senderController = TextEditingController();

  String _selectedOccasion = 'عيد ميلاد';
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//   RelationshipType? _selectedRelationship;
  bool _isLoading = false;
  bool _useAI = false;
  bool _useCache = true;
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//   SmartGreeting? _currentGreeting;
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//   Sticker? _selectedSticker;

  // قائمة المناسبات
  final List<String> _occasions = [
    'عيد ميلاد',
    'عيد',
    'رمضان',
    'زفاف',
    'تخرج',
    'مولود جديد',
    'وظيفة جديدة',
    'بيت جديد',
    'ذكرى سنوية',
    'شفاء',
    'نجاح',
    'ترقية',
    'تعزية',
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _recipientController.dispose();
    _senderController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    // هنا يمكن تحميل الإعدادات من SharedPreferences
    setState(() {
      _useAI = false;
      _useCache = true;
    });
  }

  Future<void> _generateGreeting() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (_selectedOccasion == 'تعزية') {
        if (_selectedRelationship == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('الرجاء اختيار درجة القرابة')),
          );
          return;
        }

// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//         _currentGreeting = await CondolenceService.suggestCondolence(
          recipient: _recipientController.text,
          sender: _senderController.text,
          relationship: _selectedRelationship!,
          useAI: _useAI,
        );
      } else {
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//         _currentGreeting = await SmartGreetingService.suggestGreetingWithMedia(
          occasion: _selectedOccasion,
          recipient: _recipientController.text,
          sender: _senderController.text,
          useAI: _useAI,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//   void _onStickerSelected(Sticker sticker) {
    setState(() {
      _selectedSticker = sticker;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إرسال تهنئة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//                   builder: (context) => const SmartGreetingSettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // حقل اسم المستلم
              TextFormField(
                controller: _recipientController,
                decoration: const InputDecoration(
                  labelText: 'اسم المستلم',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال اسم المستلم';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // حقل اسم المرسل
              TextFormField(
                controller: _senderController,
                decoration: const InputDecoration(
                  labelText: 'اسم المرسل',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال اسم المرسل';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // اختيار المناسبة
              DropdownButtonFormField<String>(
                value: _selectedOccasion,
                decoration: const InputDecoration(
                  labelText: 'المناسبة',
                  border: OutlineInputBorder(),
                ),
                items: _occasions.map((occasion) {
                  return DropdownMenuItem(
                    value: occasion,
                    child: Text(occasion),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedOccasion = value!;
                    _selectedRelationship = null;
                    _currentGreeting = null;
                  });
                },
              ),
              const SizedBox(height: 16),

              // اختيار درجة القرابة (للتعزية فقط)
              if (_selectedOccasion == 'تعزية') ...[
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//                 DropdownButtonFormField<RelationshipType>(
                  value: _selectedRelationship,
                  decoration: const InputDecoration(
                    labelText: 'درجة القرابة',
                    border: OutlineInputBorder(),
                  ),
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//                   items: CondolenceService.getRelationshipTypes().map((type) {
                    return DropdownMenuItem(
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//                       value: type['type'] as RelationshipType,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(type['name'] as String),
                          Text(
                            type['description'] as String,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRelationship = value;
                      _currentGreeting = null;
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],

              // خيار استخدام الذكاء الاصطناعي
              SwitchListTile(
                title: const Text('استخدام الذكاء الاصطناعي'),
                subtitle: const Text('تخصيص التهنئة بشكل أكثر تفاعلية'),
                value: _useAI,
                onChanged: (value) {
                  setState(() {
                    _useAI = value;
                    _currentGreeting = null;
                  });
                },
              ),
              const SizedBox(height: 16),

              // زر إنشاء التهنئة
              ElevatedButton(
                onPressed: _isLoading ? null : _generateGreeting,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('إنشاء تهنئة'),
              ),
              const SizedBox(height: 24),

              // عرض التهنئة المقترحة
              if (_currentGreeting != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'التهنئة المقترحة',
                          style: theme.textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _currentGreeting!.text,
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        if (_currentGreeting!.mediaUrl != null) ...[
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              _currentGreeting!.mediaUrl!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // اختيار الاستيكرات
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//                 StickerPicker(
                  occasion: _selectedOccasion,
                  onStickerSelected: _onStickerSelected,
                ),
                const SizedBox(height: 16),

                // زر إرسال التهنئة
                ElevatedButton(
                  onPressed: () {
                    // إرسال التهنئة
                  },
                  child: const Text('إرسال التهنئة'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 