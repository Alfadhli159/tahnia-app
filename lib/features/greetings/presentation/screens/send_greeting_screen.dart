import 'package:flutter/material.dart';

class SendGreetingScreen extends StatefulWidget {
  const SendGreetingScreen({super.key});

  @override
  State<SendGreetingScreen> createState() => _SendGreetingScreenState();
}

class _SendGreetingScreenState extends State<SendGreetingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final _recipientController = TextEditingController();
  final _senderController = TextEditingController();

  String _selectedOccasion = 'عيد ميلاد';
  bool _isLoading = false;
  bool _useAI = false;

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

  // سيتم عرض التهنئة الناتجة هنا مؤقتًا كنص فقط
  String? _generatedGreeting;

  @override
  void dispose() {
    _messageController.dispose();
    _recipientController.dispose();
    _senderController.dispose();
    super.dispose();
  }

  void _generateGreeting() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _generatedGreeting =
            'تهنئة $_selectedOccasion!\nإلى: ${_recipientController.text}\nمن: ${_senderController.text}\n${_useAI ? '(توليد بالذكاء الاصطناعي)' : ''}';
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إرسال تهنئة'),
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
                items: _occasions.map((occasion) => DropdownMenuItem(
                    value: occasion,
                    child: Text(occasion),
                  )).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedOccasion = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // خيار استخدام الذكاء الاصطناعي
              SwitchListTile(
                title: const Text('استخدام الذكاء الاصطناعي'),
                subtitle: const Text('تخصيص التهنئة بشكل أكثر تفاعلية'),
                value: _useAI,
                onChanged: (value) {
                  setState(() {
                    _useAI = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: _isLoading ? null : _generateGreeting,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('إنشاء تهنئة'),
              ),
              const SizedBox(height: 24),

              if (_generatedGreeting != null)
                Card(
                  color: theme.cardColor,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _generatedGreeting!,
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
