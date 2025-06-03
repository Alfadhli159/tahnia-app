// lib/features/greetings/domain/models/scheduled_message.dart

import 'package:tahania_app/features/greetings/domain/enums/message_source.dart';
import 'package:tahania_app/features/greetings/domain/enums/repeat_type.dart';

class ScheduledMessage {
  final String id;
  final String content;
  final String recipientName;
  final String recipientNumber;
  final String? recipientPhone;
  final bool isEnabled;
  final DateTime scheduledTime;
  final bool isRepeating;
  final String? repeatPattern;
  final List<String>? repeatDays;
  final DateTime? repeatEndDate;
  final RepeatType repeatType;
  final bool notifyBeforeSending;
  final int notifyBeforeMinutes;
  final String? templateId;
  final MessageSource source;
  final String? message;
  final DateTime createdAt;

  ScheduledMessage({
    required this.id,
    required this.content,
    required this.recipientName,
    required this.recipientNumber,
    this.recipientPhone,
    this.isEnabled = true,
    required this.scheduledTime,
    this.isRepeating = false,
    this.repeatPattern,
    this.repeatDays,
    this.repeatEndDate,
    this.repeatType = RepeatType.none,
    this.notifyBeforeSending = false,
    this.notifyBeforeMinutes = 5,
    this.templateId,
    this.source = MessageSource.whatsapp,
    this.message,
    required this.createdAt,
  });

  ScheduledMessage copyWith({
    String? id,
    String? content,
    String? recipientName,
    String? recipientNumber,
    String? recipientPhone,
    bool? isEnabled,
    DateTime? scheduledTime,
    bool? isRepeating,
    String? repeatPattern,
    List<String>? repeatDays,
    DateTime? repeatEndDate,
    RepeatType? repeatType,
    bool? notifyBeforeSending,
    int? notifyBeforeMinutes,
    String? templateId,
    MessageSource? source,
    String? message,
    DateTime? createdAt,
  }) {
    return ScheduledMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      recipientName: recipientName ?? this.recipientName,
      recipientNumber: recipientNumber ?? this.recipientNumber,
      recipientPhone: recipientPhone ?? this.recipientPhone,
      isEnabled: isEnabled ?? this.isEnabled,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      isRepeating: isRepeating ?? this.isRepeating,
      repeatPattern: repeatPattern ?? this.repeatPattern,
      repeatDays: repeatDays ?? this.repeatDays,
      repeatEndDate: repeatEndDate ?? this.repeatEndDate,
      repeatType: repeatType ?? this.repeatType,
      notifyBeforeSending: notifyBeforeSending ?? this.notifyBeforeSending,
      notifyBeforeMinutes: notifyBeforeMinutes ?? this.notifyBeforeMinutes,
      templateId: templateId ?? this.templateId,
      source: source ?? this.source,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
