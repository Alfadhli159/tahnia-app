import 'package:flutter/foundation.dart';
import '../features/greetings/domain/models/scheduled_message.dart';

class ScheduledMessageService {
  static final ValueNotifier<List<ScheduledMessage>> messagesNotifier =
      ValueNotifier([]);

  static void initialize() {
    messagesNotifier.value = [];
  }

  static void addMessage(ScheduledMessage message) {
    messagesNotifier.value = [...messagesNotifier.value, message];
  }

  static void updateMessage(ScheduledMessage message) {
    messagesNotifier.value = messagesNotifier.value
        .map((m) => m.id == message.id ? message : m)
        .toList();
  }

  static void deleteMessage(String id) {
    messagesNotifier.value =
        messagesNotifier.value.where((m) => m.id != id).toList();
  }

  static List<ScheduledMessage> searchMessages(String query) => messagesNotifier.value
        .where(
            (m) => m.content.contains(query) || m.recipientName.contains(query))
        .toList();

  static List<ScheduledMessage> filterMessages() => messagesNotifier.value;

  static List<ScheduledMessage> sortMessages() => messagesNotifier.value;

  static void toggleMessage(String id, bool enabled) {
    // إذا لديك خاصية isEnabled في ScheduledMessage
    messagesNotifier.value = messagesNotifier.value.map((m) {
      if (m.id == id) {
        return m.copyWith(isEnabled: enabled);
      }
      return m;
    }).toList();
  }
}
