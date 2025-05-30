import 'package:flutter/material.dart';
import 'package:tahania_app/services/localization/app_localizations.dart';

class OccasionSelector extends StatelessWidget {
  final Map<String, List<String>> occasionsByCategory;
  final String? selectedCategory;
  final String? selectedOccasion;
  final Function(String) onCategorySelected;
  final Function(String) onOccasionSelected;

  const OccasionSelector({
    super.key,
    required this.occasionsByCategory,
    required this.selectedCategory,
    required this.selectedOccasion,
    required this.onCategorySelected,
    required this.onOccasionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // نوع المناسبة
        Container(
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
                  Icon(Icons.category, color: Theme.of(context).primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context).translate('greetings.occasion_type'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                hint: Text(AppLocalizations.of(context).translate('greetings.select_occasion_type')),
                items: occasionsByCategory.keys.map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e,
                    overflow: TextOverflow.ellipsis,
                  ),
                )).toList(),
                onChanged: (val) => onCategorySelected(val!),
                isExpanded: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        
        // غرض المناسبة
        Container(
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
                  Icon(Icons.event, color: Theme.of(context).primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context).translate('greetings.occasion'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedOccasion,
                hint: Text(AppLocalizations.of(context).translate('greetings.select_occasion')),
                items: (selectedCategory != null
                        ? (occasionsByCategory[selectedCategory!] ?? [])
                        : [])
                    .map<DropdownMenuItem<String>>((e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(
                            e,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                onChanged: selectedCategory != null ? (val) => onOccasionSelected(val!) : null,
                isExpanded: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
