import 'package:flutter/material.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) => Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الدعم والمساعدة'),
          backgroundColor: Colors.teal,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'هل تواجه مشكلة؟ اكتب لنا وسنقوم بمساعدتك:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: messageController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText: 'اكتب مشكلتك أو سؤالك هنا...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'يرجى كتابة الرسالة' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم إرسال الرسالة، سنرد عليك قريبًا.'),
                          backgroundColor: Colors.teal,
                        ),
                      );
                      messageController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  ),
                  child: const Text('إرسال'),
                )
              ],
            ),
          ),
        ),
      ),
    );
}
