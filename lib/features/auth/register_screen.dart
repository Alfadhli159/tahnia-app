import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _signatureController = TextEditingController();

  bool agreed = false;
  bool subscribe = false;
  bool loading = false;

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!agreed) return;

    setState(() => loading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await FirebaseAuth.instance.currentUser?.sendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ تم إرسال رابط التحقق إلى بريدك.'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'فتح البريد',
            textColor: Colors.white,
            onPressed: () async {
              final Uri emailApp = Uri.parse('https://mail.google.com/');
              if (await canLaunchUrl(emailApp)) {
                await launchUrl(emailApp, mode: LaunchMode.externalApplication);
              }
            },
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'حدث خطأ أثناء التسجيل.';
      if (e.code == 'email-already-in-use') {
        message = 'هذا البريد مسجّل مسبقًا.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
        return;
      } else if (e.code == 'invalid-email') {
        message = 'صيغة البريد غير صحيحة.';
      } else if (e.code == 'weak-password') {
        message = 'كلمة المرور ضعيفة. يجب أن تكون 6 خانات على الأقل.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل تسجيل الدخول باستخدام Google'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text('شاشة التسجيل (قيد التطوير، سيتم تفعيل الفورم هنا)')),
    );
  }
}
