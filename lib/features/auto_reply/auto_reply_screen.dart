import 'package:flutter/material.dart';

class AutoReplyScreen extends StatelessWidget {
  const AutoReplyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الرد التلقائي')),
      body: const Center(child: Text('هنا سيتم عرض الردود التلقائية')),
    );
  }
}
