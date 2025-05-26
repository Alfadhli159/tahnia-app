import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('حول التطبيق'),
          backgroundColor: Colors.teal,
        ),
        body: const Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Text(
              'تطبيق "تهنئة" يتيح لك إرسال التهاني بشكل ذكي ومخصص إلى أحبّتك، في كل مناسبة دينية، اجتماعية، أو مهنية.\n\n'
              'صُمم التطبيق ليكون سهل الاستخدام وسريع التفاعل، مع دعم التخصيص التام للرسائل، وإمكانية الجدولة، والردود التلقائية.\n\n'
              'نؤمن بأن التهاني الصادقة تبني جسور المحبة، ولهذا أنشأنا "تهنئة" ليكون رفيقك الموثوق لمشاركة الفرح.',
              style: TextStyle(fontSize: 16, height: 1.7),
            ),
          ),
        ),
      ),
    );
  }
}
