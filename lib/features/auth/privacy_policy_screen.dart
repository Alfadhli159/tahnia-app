import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('سياسة الخصوصية'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: const Padding(
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Text(
              '''
نص سياسة الخصوصية:
- نحن نحترم خصوصيتك ونلتزم بحماية بياناتك.
- جميع البيانات المقدمة لن يتم مشاركتها مع أي طرف ثالث.
- يتم استخدام رقم الجوال فقط لأغراض التحقق والتواصل والتسويق للخدمات والتحديثات المستقبلية.
- باستخدامك التطبيق، فإنك توافق على سياسة الخصوصية هذه.
              ''',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
