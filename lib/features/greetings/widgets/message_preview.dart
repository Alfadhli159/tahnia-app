import 'package:flutter/material.dart';
import 'package:tahania_app/services/localization/app_localizations.dart';

class MessagePreview extends StatelessWidget {
  final String message;
  final Function(String) onMessageChanged;

  const MessagePreview({
    super.key,
    required this.message,
    required this.onMessageChanged,
  });

  @override
  Widget build(BuildContext context) => Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).translate('greetings.message'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: TextEditingController(text: message),
              maxLines: 5,
              onChanged: onMessageChanged,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).translate('greetings.message_hint'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
} 