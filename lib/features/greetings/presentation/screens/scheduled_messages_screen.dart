import 'package:flutter/material.dart';
import 'package:tahania_app/features/greetings/domain/models/scheduled_message.dart';
import 'package:tahania_app/features/greetings/domain/models/message_template.dart';
import 'package:tahania_app/features/greetings/domain/enums/message_source.dart';
import 'package:tahania_app/features/greetings/services/scheduled_message_service.dart';
import 'package:tahania_app/services/template_service.dart';
import 'package:intl/intl.dart';

class ScheduledMessagesScreen extends StatefulWidget {
  const ScheduledMessagesScreen({super.key});

  @override
  State<ScheduledMessagesScreen> createState() =>
      _ScheduledMessagesScreenState();
}

class _ScheduledMessagesScreenState extends State<ScheduledMessagesScreen> {
  String _searchQuery = '';
  bool _showEnabledOnly = false;
  bool _showWhatsAppOnly = false;
  bool _showRepeatingOnly = false;
  String _sortBy = 'date';
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    ScheduledMessageService.initialize();
  }

  List<ScheduledMessage> _getFilteredMessages() {
    var messages = ScheduledMessageService.messagesNotifier.value;

    // تطبيق البحث
    if (_searchQuery.isNotEmpty) {
      messages = ScheduledMessageService.searchMessages(_searchQuery);
    }

    // تطبيق التصفية
    if (_showEnabledOnly) {
      messages = messages.where((m) => m.isEnabled).toList();
    }

    if (_showWhatsAppOnly) {
      messages =
          messages.where((m) => m.source == MessageSource.whatsapp).toList();
    }

    if (_showRepeatingOnly) {
      messages = messages.where((m) => m.isRepeating).toList();
    }

    // تطبيق الترتيب
    messages.sort((a, b) {
      int comparison;
      switch (_sortBy) {
        case 'name':
          comparison = a.recipientName.compareTo(b.recipientName);
          break;
        case 'number':
          comparison = a.recipientNumber.compareTo(b.recipientNumber);
          break;
        case 'date':
        default:
          comparison = a.scheduledTime.compareTo(b.scheduledTime);
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    return messages;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الرسائل المجدولة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddMessageDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'بحث في الرسائل...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // عرض الرسائل
          Expanded(
            child: ValueListenableBuilder<List<ScheduledMessage>>(
              valueListenable: ScheduledMessageService.messagesNotifier,
              builder: (context, messages, child) {
                final filteredMessages = _getFilteredMessages();

                if (filteredMessages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 64,
                          color: theme.primaryColor.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد رسائل مجدولة',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'اضغط على زر + لإضافة رسالة مجدولة',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredMessages.length,
                  itemBuilder: (context, index) {
                    final message = filteredMessages[index];
                    return _buildMessageCard(message, theme);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(ScheduledMessage message, ThemeData theme) => Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // معلومات المستلم
            Row(
              children: [
                Icon(
                  message.source == MessageSource.whatsapp
                      ? Icons.message
                      : Icons.sms,
                  color: message.source == MessageSource.whatsapp
                      ? Colors.green
                      : Colors.blue,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.recipientName,
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      message.recipientNumber,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                const Spacer(),
                Switch(
                  value: message.isEnabled,
                  onChanged: (value) {
                    ScheduledMessageService.toggleMessage(message.id, value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // الرسالة
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.dividerColor,
                ),
              ),
              child: Text(message.content),
            ),
            const SizedBox(height: 16),

            // معلومات التوقيت
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: theme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('yyyy/MM/dd HH:mm').format(message.scheduledTime),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.primaryColor,
                  ),
                ),
                if (message.isRepeating) ...[
                  const SizedBox(width: 16),
                  Icon(
                    Icons.repeat,
                    size: 16,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getRepeatPatternText(message),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ],
            ),
            if (message.notifyBeforeSending) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.notifications,
                    size: 16,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'إشعار قبل ${message.notifyBeforeMinutes} دقائق',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),

            // أزرار الإجراءات
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('تعديل'),
                  onPressed: () => _showEditMessageDialog(context, message),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text('حذف'),
                  onPressed: () => _showDeleteConfirmation(context, message),
                ),
              ],
            ),
          ],
        ),
      ),
    );

  String _getRepeatPatternText(ScheduledMessage message) {
    if (message.repeatPattern == 'custom' && message.repeatDays != null) {
      final days = message.repeatDays!.map((day) {
        switch (day) {
          case '0':
            return 'الأحد';
          case '1':
            return 'الإثنين';
          case '2':
            return 'الثلاثاء';
          case '3':
            return 'الأربعاء';
          case '4':
            return 'الخميس';
          case '5':
            return 'الجمعة';
          case '6':
            return 'السبت';
          default:
            return '';
        }
      }).join('، ');
      return 'كل $days';
    }

    switch (message.repeatPattern) {
      case 'daily':
        return 'يومي';
      case 'weekly':
        return 'أسبوعي';
      case 'monthly':
        return 'شهري';
      default:
        return message.repeatPattern ?? '';
    }
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تصفية وترتيب الرسائل'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // خيارات التصفية
            SwitchListTile(
              title: const Text('المفعلة فقط'),
              value: _showEnabledOnly,
              onChanged: (value) {
                setState(() {
                  _showEnabledOnly = value;
                });
                Navigator.pop(context);
              },
            ),
            SwitchListTile(
              title: const Text('واتساب فقط'),
              value: _showWhatsAppOnly,
              onChanged: (value) {
                setState(() {
                  _showWhatsAppOnly = value;
                });
                Navigator.pop(context);
              },
            ),
            SwitchListTile(
              title: const Text('المتكررة فقط'),
              value: _showRepeatingOnly,
              onChanged: (value) {
                setState(() {
                  _showRepeatingOnly = value;
                });
                Navigator.pop(context);
              },
            ),
            const Divider(),
            // خيارات الترتيب
            ListTile(
              title: const Text('ترتيب حسب'),
              trailing: DropdownButton<String>(
                value: _sortBy,
                items: const [
                  DropdownMenuItem(
                    value: 'date',
                    child: Text('التاريخ'),
                  ),
                  DropdownMenuItem(
                    value: 'name',
                    child: Text('الاسم'),
                  ),
                  DropdownMenuItem(
                    value: 'number',
                    child: Text('الرقم'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _sortBy = value;
                    });
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('الاتجاه'),
              trailing: DropdownButton<bool>(
                value: _sortAscending,
                items: const [
                  DropdownMenuItem(
                    value: true,
                    child: Text('تصاعدي'),
                  ),
                  DropdownMenuItem(
                    value: false,
                    child: Text('تنازلي'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _sortAscending = value;
                    });
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _showEnabledOnly = false;
                _showWhatsAppOnly = false;
                _showRepeatingOnly = false;
                _sortBy = 'date';
                _sortAscending = true;
              });
              Navigator.pop(context);
            },
            child: const Text('إعادة تعيين'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showAddMessageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _MessageDialog(
        onSave: (message) {
          ScheduledMessageService.addMessage(message);
        },
      ),
    );
  }

  void _showEditMessageDialog(BuildContext context, ScheduledMessage message) {
    showDialog(
      context: context,
      builder: (context) => _MessageDialog(
        message: message,
        onSave: (updatedMessage) {
          ScheduledMessageService.updateMessage(updatedMessage);
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, ScheduledMessage message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الرسالة المجدولة'),
        content: const Text('هل أنت متأكد من حذف هذه الرسالة المجدولة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              ScheduledMessageService.deleteMessage(message.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}

class _MessageDialog extends StatefulWidget {
  final ScheduledMessage? message;
  final Function(ScheduledMessage) onSave;

  const _MessageDialog({
    this.message,
    required this.onSave,
  });

  @override
  State<_MessageDialog> createState() => _MessageDialogState();
}

class _MessageDialogState extends State<_MessageDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _numberController;
  late TextEditingController _messageController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late MessageSource _selectedSource;
  late bool _isRepeating;
  late String? _repeatPattern;
  late List<String>? _repeatDays;
  late DateTime? _repeatEndDate;
  late bool _notifyBeforeSending;
  late int _notifyBeforeMinutes;
  late String? _selectedTemplateId;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.message?.recipientName);
    _numberController =
        TextEditingController(text: widget.message?.recipientNumber);
    _messageController = TextEditingController(text: widget.message?.content);
    _selectedDate = widget.message?.scheduledTime ?? DateTime.now();
    _selectedTime = TimeOfDay.fromDateTime(
      widget.message?.scheduledTime ?? DateTime.now(),
    );
    _selectedSource = widget.message?.source ?? MessageSource.whatsapp;
    _isRepeating = widget.message?.isRepeating ?? false;
    _repeatPattern = widget.message?.repeatPattern;
    _repeatDays = widget.message?.repeatDays;
    _repeatEndDate = widget.message?.repeatEndDate;
    _notifyBeforeSending = widget.message?.notifyBeforeSending ?? false;
    _notifyBeforeMinutes = widget.message?.notifyBeforeMinutes ?? 5;
    _selectedTemplateId = widget.message?.templateId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
      title: Text(widget.message == null
          ? 'إضافة رسالة مجدولة'
          : 'تعديل الرسالة المجدولة'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // اختيار قالب
              ValueListenableBuilder<List<MessageTemplate>>(
                valueListenable: TemplateService.templatesNotifier,
                builder: (context, templates, child) {
                  if (templates.isEmpty) return const SizedBox.shrink();

                  return Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedTemplateId,
                        decoration: const InputDecoration(
                          labelText: 'اختر قالب',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('بدون قالب'),
                          ),
                          ...templates.map((template) {
                            return DropdownMenuItem(
                              value: template.id,
                              child: Text(template.name),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedTemplateId = value;
                            if (value != null) {
                              final template = templates.firstWhere(
                                (t) => t.id == value,
                              );
                              _messageController.text = template.content;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم المستلم',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال اسم المستلم';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _numberController,
                decoration: const InputDecoration(
                  labelText: 'رقم المستلم',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال رقم المستلم';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'الرسالة',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الرسالة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        DateFormat('yyyy/MM/dd').format(_selectedDate),
                      ),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() {
                            _selectedDate = date;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.access_time),
                      label: Text(_selectedTime.format(context)),
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (time != null) {
                          setState(() {
                            _selectedTime = time;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<MessageSource>(
                value: _selectedSource,
                decoration: const InputDecoration(
                  labelText: 'نوع الرسالة',
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(
                    value: MessageSource.whatsapp,
                    child: Text('واتساب'),
                  ),
                  DropdownMenuItem(
                    value: MessageSource.sms,
                    child: Text('رسالة نصية'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedSource = value;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final scheduledTime = DateTime(
                _selectedDate.year,
                _selectedDate.month,
                _selectedDate.day,
                _selectedTime.hour,
                _selectedTime.minute,
              );

              final message = ScheduledMessage(
                id: widget.message?.id ??
                    DateTime.now().millisecondsSinceEpoch.toString(),
                content: _messageController.text,
                recipientName: _nameController.text,
                recipientNumber: _numberController.text,
                scheduledTime: scheduledTime,
                isRepeating: _isRepeating,
                repeatPattern: _repeatPattern,
                repeatDays: _repeatDays,
                repeatEndDate: _repeatEndDate,
                source: _selectedSource,
                isEnabled: widget.message?.isEnabled ?? true,
                notifyBeforeSending: _notifyBeforeSending,
                notifyBeforeMinutes: _notifyBeforeMinutes,
                templateId: _selectedTemplateId,
                createdAt: widget.message?.createdAt ?? DateTime.now(),
              );

              widget.onSave(message);
              Navigator.pop(context);
            }
          },
          child: const Text('حفظ'),
        ),
      ],
    );
}
