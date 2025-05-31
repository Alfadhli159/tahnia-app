import 'package:flutter/material.dart';
import 'package:tahania_app/services/scheduled_message_service.dart';
import 'package:tahania_app/config/theme/app_theme.dart';
import 'package:intl/intl.dart';

class ScheduledMessagesScreen extends StatefulWidget {
  const ScheduledMessagesScreen({Key? key}) : super(key: key);

  @override
  State<ScheduledMessagesScreen> createState() => _ScheduledMessagesScreenState();
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
    messages = ScheduledMessageService.filterMessages(
      isEnabled: _showEnabledOnly ? true : null,
      source: _showWhatsAppOnly ? MessageSource.whatsapp : null,
      isRepeating: _showRepeatingOnly ? true : null,
    );

    // تطبيق الترتيب
    messages = ScheduledMessageService.sortMessages(
      sortBy: _sortBy,
      ascending: _sortAscending,
    );

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

  Widget _buildMessageCard(ScheduledMessage message, ThemeData theme) {
    return Card(
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
                      ? Icons.whatsapp
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
              child: Text(message.message),
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
  }

  String _getRepeatPatternText(ScheduledMessage message) {
    if (message.repeatPattern == 'custom' && message.repeatDays != null) {
      final days = message.repeatDays!.map((day) {
        switch (day) {
          case 0:
            return 'الأحد';
          case 1:
            return 'الإثنين';
          case 2:
            return 'الثلاثاء';
          case 3:
            return 'الأربعاء';
          case 4:
            return 'الخميس';
          case 5:
            return 'الجمعة';
          case 6:
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
  late List<int>? _repeatDays;
  late DateTime? _repeatEndDate;
  late bool _notifyBeforeSending;
  late int _notifyBeforeMinutes;
  late String? _selectedTemplateId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.message?.recipientName);
    _numberController = TextEditingController(text: widget.message?.recipientNumber);
    _messageController = TextEditingController(text: widget.message?.message);
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(widget.message == null ? 'إضافة رسالة مجدولة' : 'تعديل الرسالة المجدولة'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // اختيار قالب
              ValueListenableBuilder<List<MessageTemplate>>(
                valueListenable: ScheduledMessageService.templatesNotifier,
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
                          lastDate: DateTime.now().add(const Duration(days: 365)),
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
                items: const [
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
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('تكرار الرسالة'),
                value: _isRepeating,
                onChanged: (value) {
                  setState(() {
                    _isRepeating = value;
                    if (!value) {
                      _repeatPattern = null;
                      _repeatDays = null;
                      _repeatEndDate = null;
                    } else if (_repeatPattern == null) {
                      _repeatPattern = 'daily';
                    }
                  });
                },
              ),
              if (_isRepeating) ...[
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _repeatPattern,
                  decoration: const InputDecoration(
                    labelText: 'نمط التكرار',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'daily',
                      child: Text('يومي'),
                    ),
                    DropdownMenuItem(
                      value: 'weekly',
                      child: Text('أسبوعي'),
                    ),
                    DropdownMenuItem(
                      value: 'monthly',
                      child: Text('شهري'),
                    ),
                    DropdownMenuItem(
                      value: 'custom',
                      child: Text('أيام محددة'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _repeatPattern = value;
                        if (value == 'custom') {
                          _repeatDays = [1, 3, 5]; // الاثنين، الأربعاء، الجمعة
                        } else {
                          _repeatDays = null;
                        }
                      });
                    }
                  },
                ),
                if (_repeatPattern == 'custom') ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: List.generate(7, (index) {
                      final day = index;
                      final isSelected = _repeatDays?.contains(day) ?? false;
                      return FilterChip(
                        label: Text(_getDayName(day)),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _repeatDays ??= [];
                            if (selected) {
                              _repeatDays!.add(day);
                            } else {
                              _repeatDays!.remove(day);
                            }
                          });
                        },
                      );
                    }),
                  ),
                ],
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    _repeatEndDate == null
                        ? 'بدون تاريخ انتهاء'
                        : DateFormat('yyyy/MM/dd').format(_repeatEndDate!),
                  ),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _repeatEndDate ?? DateTime.now().add(const Duration(days: 30)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        _repeatEndDate = date;
                      });
                    }
                  },
                ),
              ],
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('إشعار قبل الإرسال'),
                value: _notifyBeforeSending,
                onChanged: (value) {
                  setState(() {
                    _notifyBeforeSending = value;
                  });
                },
              ),
              if (_notifyBeforeSending) ...[
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: _notifyBeforeMinutes,
                  decoration: const InputDecoration(
                    labelText: 'قبل كم دقيقة',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 5,
                      child: Text('5 دقائق'),
                    ),
                    DropdownMenuItem(
                      value: 10,
                      child: Text('10 دقائق'),
                    ),
                    DropdownMenuItem(
                      value: 15,
                      child: Text('15 دقيقة'),
                    ),
                    DropdownMenuItem(
                      value: 30,
                      child: Text('30 دقيقة'),
                    ),
                    DropdownMenuItem(
                      value: 60,
                      child: Text('ساعة'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _notifyBeforeMinutes = value;
                      });
                    }
                  },
                ),
              ],
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
                id: widget.message?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                recipientName: _nameController.text,
                recipientNumber: _numberController.text,
                message: _messageController.text,
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

  String _getDayName(int day) {
    switch (day) {
      case 0:
        return 'الأحد';
      case 1:
        return 'الإثنين';
      case 2:
        return 'الثلاثاء';
      case 3:
        return 'الأربعاء';
      case 4:
        return 'الخميس';
      case 5:
        return 'الجمعة';
      case 6:
        return 'السبت';
      default:
        return '';
    }
  }
} 