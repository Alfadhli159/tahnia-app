import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('شروط الاستخدام'),
          backgroundColor: Colors.teal,
        ),
        body: const Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Text(
              'باستخدامك لتطبيق "تهنئة" فإنك توافق على الشروط التالية:\n\n'
              '- يُستخدم التطبيق فقط لأغراض شخصية ومشروعة.\n'
              '- لا يجوز إساءة استخدام خدمة التهاني أو إرسال محتوى غير لائق.\n'
              '- قد يتم تحديث هذه الشروط دون إشعار مسبق، وعلى المستخدم مراجعتها دوريًا.\n'
              '- نحن نحترم خصوصيتك ولن نشارك بياناتك مع طرف ثالث دون إذنك.\n\n'
              'نشكر لك ثقتك ونلتزم بتوفير تجربة تهنئة آمنة وممتعة.',
              style: TextStyle(fontSize: 16, height: 1.7),
            ),
          ),
        ),
      ),
    );
  }
}
