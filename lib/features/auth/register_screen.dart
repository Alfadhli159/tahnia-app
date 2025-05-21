import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'otp_verification_screen.dart';
import 'privacy_policy_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _signatureController = TextEditingController();

  bool agreed = false;
  bool subscribe = false;

  String? _validatePhone(String? value) {
    String phone = value?.replaceAll(' ', '') ?? '';
    if (phone.isEmpty) return 'يرجى إدخال رقم الجوال';
    return null;
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب الموافقة على سياسة الخصوصية')),
      );
      return;
    }

    String rawPhone = _phoneController.text.trim();

    // تصحيح الرقم تلقائيًا
    if (rawPhone.startsWith('05') && rawPhone.length == 10) {
      rawPhone = '+966${rawPhone.substring(1)}';
    } else if (rawPhone.startsWith('966') && rawPhone.length == 12) {
      rawPhone = '+$rawPhone';
    }

    // التحقق من صحة الصيغة النهائية
    final isValid = RegExp(r'^\+\d{10,15}$').hasMatch(rawPhone);
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ صيغة رقم الجوال غير صحيحة. يرجى كتابة الرقم بصيغة مثل: +9665xxxxxxx أو 05xxxxxxx فقط.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String phone = rawPhone;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {
          Navigator.of(context).pop();
        },
        verificationFailed: (FirebaseAuthException e) {
          Navigator.of(context).pop();
          String message = 'فشل الإرسال: ${e.message}';
          if (e.code == 'too-long') {
            message = '❌ رقم الجوال طويل جدًا. تحقق من الرقم.';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(
                phone: phone,
                verificationId: verificationId,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء الإرسال: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تسجيل مستخدم جديد'),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 38,
                        height: 38,
                        errorBuilder: (_, __, ___) => const SizedBox(width: 38, height: 38),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'حياك في تطبيق تهنئة',
                        style: TextStyle(
                          color: Color(0xFF12947f),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'الاسم',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'يرجى إدخال الاسم' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'رقم الجوال',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone_android),
                      helperText: '📌 أدخل الرقم بصيغة: 05xxxxxxxx أو +9665xxxxxxxx',
                    ),
                    validator: _validatePhone,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _signatureController,
                    decoration: const InputDecoration(
                      labelText: 'التوقيع (الاسم يظهر أسفل رسائلك)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.edit),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'يرجى إدخال التوقيع' : null,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'سيظهر هذا الاسم في نهاية كل تهنئة ترسلها.',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: agreed,
                        onChanged: (value) => setState(() => agreed = value ?? false),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
                          );
                        },
                        child: Text(
                          'أوافق على سياسة الخصوصية',
                          style: TextStyle(
                            color: Colors.teal[700],
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: subscribe,
                        onChanged: (value) => setState(() => subscribe = value ?? false),
                      ),
                      const Flexible(
                        child: Text('أوافق على الاشتراك في البريد والتحديثات (اختياري)'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF12947f),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('تسجيل', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
