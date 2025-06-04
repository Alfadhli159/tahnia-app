import 'package:flutter/material.dart';
import 'package:tahania_app/services/localization/app_localizations.dart';

class GreetingTypeSelector extends StatelessWidget {
  final List<Map<String, String>> messageTypes;
  final String? selectedType;
  final Function(String) onTypeSelected;

  const GreetingTypeSelector({
    super.key,
    required this.messageTypes,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.message, color: Theme.of(context).primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).translate('greetings.message_type'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: selectedType,
            hint: Text(AppLocalizations.of(context).translate('greetings.select_message_type')),
            items: messageTypes.map((type) => DropdownMenuItem(
              value: type['name'],
              child: Row(
                children: [
                  Text(type['emoji']!, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      type['name']!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            )).toList(),
            onChanged: (val) => onTypeSelected(val!),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            isExpanded: true,
          ),
        ],
      ),
    );
}
