import 'package:flutter/foundation.dart';
import 'package:tahania_app/features/greetings/domain/models/message_template.dart';

class TemplateService {
  static final ValueNotifier<List<MessageTemplate>> templatesNotifier =
      ValueNotifier([]);

  static void initialize() {
    templatesNotifier.value = [];
  }

  static void addTemplate(MessageTemplate template) {
    templatesNotifier.value = [...templatesNotifier.value, template];
  }

  static void updateTemplate(MessageTemplate template) {
    templatesNotifier.value = templatesNotifier.value
        .map((t) => t.id == template.id ? template : t)
        .toList();
  }

  static void deleteTemplate(String id) {
    templatesNotifier.value =
        templatesNotifier.value.where((t) => t.id != id).toList();
  }

  static List<MessageTemplate> searchTemplates(String query) => templatesNotifier.value
        .where((t) =>
            t.name.toLowerCase().contains(query.toLowerCase()) ||
            t.content.toLowerCase().contains(query.toLowerCase()) ||
            t.category.toLowerCase().contains(query.toLowerCase()) ||
            t.tags
                .any((tag) => tag.toLowerCase().contains(query.toLowerCase())))
        .toList();

  static void reorderTemplates(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final List<MessageTemplate> templates = List.from(templatesNotifier.value);
    final MessageTemplate template = templates.removeAt(oldIndex);
    templates.insert(newIndex, template);
    templatesNotifier.value = templates;
  }
}
