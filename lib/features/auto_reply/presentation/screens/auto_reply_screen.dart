import 'package:flutter/material.dart';

class AutoReplyScreen extends StatefulWidget {
  const AutoReplyScreen({super.key});

  @override
  State<AutoReplyScreen> createState() => _AutoReplyScreenState();
}

class _AutoReplyScreenState extends State<AutoReplyScreen> {
  bool _autoReplyEnabled = false;
  final _replyTextController =
      TextEditingController(text: "شكرًا على تهنئتك! 🎉");

  @override
  void dispose() {
    _replyTextController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ إعدادات الرد التلقائي.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('الرد التلقائي على التهاني'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SwitchListTile(
              title: const Text('تفعيل الرد التلقائي'),
              subtitle: const Text(
                  'عند تفعيل هذه الخاصية، سيقوم التطبيق بالرد تلقائيًا على التهاني.'),
              value: _autoReplyEnabled,
              onChanged: (val) {
                setState(() {
                  _autoReplyEnabled = val;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _replyTextController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'نص الرد التلقائي',
                border: OutlineInputBorder(),
                hintText: 'مثال: شكرًا على تهنئتك! 🎉',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('حفظ الإعدادات'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: _saveSettings,
            ),
            const SizedBox(height: 32),
            Card(
              color: theme.colorScheme.secondary.withOpacity(0.08),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'ستدعم هذه الميزة الربط التلقائي بواتساب في التحديثات القادمة.\nيمكنك الآن تخصيص نص الرد ليظهر تلقائيًا لمن يرسل لك التهنئة.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
