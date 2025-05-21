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
  String name = '';
  String phone = '';
  String signature = '';
  bool agreed = false;
  bool subscribe = false;
  bool loading = false;

  // دالة لإرسال رمز التحقق عبر Firebase
  Future<void> sendOTP(BuildContext context) async {
    String phoneNumber = phone.trim();
    if (phoneNumber.startsWith('05')) {
      phoneNumber = '+966' + phoneNumber.substring(1);
    } else if (!phoneNumber.startsWith('+')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخل رقم الجوال بصيغة صحيحة')),
      );
      return;
    }

    setState(() => loading = true);
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          setState(() => loading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('حدث خطأ: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() => loading = false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OtpVerificationScreen(
                phone: phoneNumber,
                verificationId: verificationId,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() => loading = false);
        },
      );
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر إرسال رمز التحقق. تحقق من البيانات وحاول مجددًا')),
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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 32),
                // شعار صغير ونص ترحيبي متقابلان في صف واحد
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // شعار صغير (يسار)
                    Padding(
                      padding: const EdgeInsets.only(left: 6, right: 6),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // نص ترحيبي (يمين)
                    Expanded(
                      child: Text(
                        'حياك في تطبيق تهنئة',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 34),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // الاسم
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'الاسم',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        onSaved: (val) => name = val ?? '',
                        validator: (val) =>
                            (val == null || val.trim().length < 3)
                                ? 'الاسم لا يقل عن 3 أحرف'
                                : null,
                      ),
                      const SizedBox(height: 16),
                      // الجوال
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'رقم الجوال',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone_android),
                          hintText: '05xxxxxxxx أو +9665xxxxxxxx',
                        ),
                        onSaved: (val) => phone = val ?? '',
                        validator: (val) {
                          if (val == null || val.isEmpty)
                            return 'يجب إدخال رقم الجوال';
                          if (!RegExp(r'^(05\d{8}|\+9665\d{8})$').hasMatch(val.trim()))
                            return 'رقم غير صحيح';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // التوقيع
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'التوقيع (اسم يظهر أسفل رسائلك)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.edit_note_rounded),
                          helperText: 'سيظهر هذا الاسم في نهاية كل تهنئة ترسلها',
                        ),
                        onSaved: (val) => signature = val ?? '',
                        validator: (val) => (val == null || val.trim().isEmpty)
                            ? 'يرجى إدخال التوقيع'
                            : null,
                      ),
                      const SizedBox(height: 24),
                      // الموافقة على سياسة الخصوصية
                      Row(
                        children: [
                          Checkbox(
                            value: agreed,
                            onChanged: (val) {
                              setState(() => agreed = val ?? false);
                            },
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const PrivacyPolicyScreen(),
                                  ),
                                );
                              },
                              child: RichText(
                                text: const TextSpan(
                                  text: 'أوافق على ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                  children: [
                                    TextSpan(
                                      text: 'سياسة الخصوصية',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Color(0xFF12947f),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // الموافقة على الاشتراك بالبريد
                      Row(
                        children: [
                          Checkbox(
                            value: subscribe,
                            onChanged: (val) {
                              setState(() => subscribe = val ?? false);
                            },
                          ),
                          const Flexible(
                            child: Text(
                              'أوافق على الاشتراك في البريد والتحديثات (اختياري)',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // زر التسجيل
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF12947f),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            disabledBackgroundColor:
                                const Color(0xFF12947f).withOpacity(0.4),
                          ),
                          onPressed: agreed && !loading
                              ? () async {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    _formKey.currentState!.save();
                                    await sendOTP(context);
                                  }
                                }
                              : null,
                          child: loading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text(
                                  'تسجيل',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
