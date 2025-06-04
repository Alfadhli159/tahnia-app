import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tahania_app/features/greetings/services/scheduled_message_service.dart';
import 'package:tahania_app/services/template_service.dart';
import 'package:tahania_app/features/greetings/domain/models/scheduled_message.dart';
import 'package:tahania_app/features/greetings/domain/models/message_template.dart';
import 'package:tahania_app/features/greetings/domain/enums/repeat_type.dart';
import 'package:tahania_app/features/greetings/domain/enums/message_source.dart';

class ScheduleGreetingScreen extends StatefulWidget {
  const ScheduleGreetingScreen({super.key});

  @override
  State<ScheduleGreetingScreen> createState() => _ScheduleGreetingScreenState();
}

class _ScheduleGreetingScreenState extends State<ScheduleGreetingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    ScheduledMessageService.initialize();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('الرسائل المجدولة'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'الرسائل المجدولة'),
            Tab(text: 'قوالب الرسائل'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildScheduledMessagesTab(),
          _buildTemplatesTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMessageDialog(context),
        child: const Icon(Icons.add),
      ),
    );

  Widget _buildScheduledMessagesTab() => ValueListenableBuilder<List<ScheduledMessage>>(
      valueListenable: ScheduledMessageService.messagesNotifier,
      builder: (context, messages, child) {
        final filteredMessages = _filterMessages(messages);

        if (filteredMessages.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.schedule, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'لا توجد رسائل مجدولة',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'اضغط على + لإضافة رسالة جديدة',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: filteredMessages.length,
          itemBuilder: (context, index) {
            final message = filteredMessages[index];
            return _buildMessageCard(message);
          },
        );
      },
    );

  Widget _buildTemplatesTab() => ValueListenableBuilder<List<MessageTemplate>>(
      valueListenable: TemplateService.templatesNotifier,
      builder: (context, templates, child) {
        if (templates.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.view_module, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'لا توجد قوالب',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: templates.length,
          itemBuilder: (context, index) {
            final template = templates[index];
            return _buildTemplateCard(template);
          },
        );
      },
    );

  List<ScheduledMessage> _filterMessages(List<ScheduledMessage> messages) {
    if (_searchQuery.isEmpty) return messages;

    return messages.where((message) => message.content
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          message.recipientName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase())).toList();
  }

  Widget _buildMessageCard(ScheduledMessage message) {
    final isOverdue = message.scheduledTime.isBefore(DateTime.now());
    final formattedDate =
        DateFormat('yyyy/MM/dd HH:mm').format(message.scheduledTime);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: message.isEnabled
              ? (isOverdue ? Colors.red : Colors.green)
              : Colors.grey,
          child: Icon(
            message.isEnabled
                ? (isOverdue ? Icons.warning : Icons.schedule)
                : Icons.pause,
            color: Colors.white,
          ),
        ),
        title: Text(
          message.recipientName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              formattedDate,
              style: TextStyle(
                fontSize: 12,
                color: isOverdue ? Colors.red : Colors.blue,
              ),
            ),
            if (message.repeatType != RepeatType.none)
              Text(
                'يتكرر: ${_getRepeatTypeText(message.repeatType)}',
                style: const TextStyle(fontSize: 12, color: Colors.orange),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleMessageAction(value, message),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'toggle',
              child: ListTile(
                leading:
                    Icon(message.isEnabled ? Icons.pause : Icons.play_arrow),
                title: Text(message.isEnabled ? 'تعطيل' : 'تفعيل'),
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('تعديل'),
              ),
            ),
            const PopupMenuItem(
              value: 'duplicate',
              child: ListTile(
                leading: Icon(Icons.copy),
                title: Text('نسخ'),
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('حذف', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
        onTap: () => _showEditMessageDialog(context, message),
      ),
    );
  }

  Widget _buildTemplateCard(MessageTemplate template) => Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.view_module, color: Colors.white),
        ),
        title: Text(
          template.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          template.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleTemplateAction(value, template),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'use',
              child: ListTile(
                leading: Icon(Icons.send),
                title: Text('استخدام'),
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('تعديل'),
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('حذف', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );

  String _getRepeatTypeText(RepeatType type) {
    switch (type) {
      case RepeatType.daily:
        return 'يومياً';
      case RepeatType.weekly:
        return 'أسبوعياً';
      case RepeatType.monthly:
        return 'شهرياً';
      case RepeatType.yearly:
        return 'سنوياً';
      case RepeatType.none:
        return 'لا يتكرر';
    }
  }

  void _handleMessageAction(String action, ScheduledMessage message) {
    switch (action) {
      case 'toggle':
        ScheduledMessageService.toggleMessage(message.id, !message.isEnabled);
        break;
      case 'edit':
        _showEditMessageDialog(context, message);
        break;
      case 'duplicate':
        _duplicateMessage(message);
        break;
      case 'delete':
        _showDeleteConfirmation(context, message);
        break;
    }
  }

  void _handleTemplateAction(String action, MessageTemplate template) {
    switch (action) {
      case 'use':
        _useTemplate(template);
        break;
      case 'edit':
        // Implement template editing
        break;
      case 'delete':
        TemplateService.deleteTemplate(template.id);
        break;
    }
  }

  void _duplicateMessage(ScheduledMessage message) {
    final newMessage = ScheduledMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: message.content,
      recipientName: message.recipientName,
      recipientNumber: message.recipientNumber,
      recipientPhone: message.recipientPhone,
      scheduledTime: DateTime.now().add(const Duration(hours: 1)),
      repeatType: message.repeatType,
      createdAt: DateTime.now(),
      source: message.source,
    );
    ScheduledMessageService.addMessage(newMessage);
  }

  void _useTemplate(MessageTemplate template) {
    _showAddMessageDialog(context, template: template);
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('البحث'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'ابحث في الرسائل...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() => _searchQuery = value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _searchQuery = '');
              Navigator.pop(context);
            },
            child: const Text('مسح'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showAddMessageDialog(BuildContext context,
      {MessageTemplate? template}) {
    showDialog(
      context: context,
      builder: (context) => _MessageDialog(template: template),
    );
  }

  void _showEditMessageDialog(BuildContext context, ScheduledMessage message) {
    showDialog(
      context: context,
      builder: (context) => _MessageDialog(message: message),
    );
  }

  void _showDeleteConfirmation(BuildContext context, ScheduledMessage message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذه الرسالة المجدولة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScheduledMessageService.deleteMessage(message.id);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _MessageDialog extends StatefulWidget {
  final ScheduledMessage? message;
  final MessageTemplate? template;

  const _MessageDialog({this.message, this.template});

  @override
  State<_MessageDialog> createState() => _MessageDialogState();
}

class _MessageDialogState extends State<_MessageDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _contentController;
  late TextEditingController _recipientNameController;
  late TextEditingController _recipientPhoneController;
  DateTime _selectedDate = DateTime.now().add(const Duration(hours: 1));
  TimeOfDay _selectedTime = TimeOfDay.now();
  RepeatType _repeatType = RepeatType.none;
  bool _isEnabled = true;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
      text: widget.message?.content ?? widget.template?.content ?? '',
    );
    _recipientNameController = TextEditingController(
      text: widget.message?.recipientName ?? '',
    );
    _recipientPhoneController = TextEditingController(
      text: widget.message?.recipientPhone ??
          widget.message?.recipientNumber ??
          '',
    );

    if (widget.message != null) {
      _selectedDate = widget.message!.scheduledTime;
      _selectedTime = TimeOfDay.fromDateTime(widget.message!.scheduledTime);
      _repeatType = widget.message!.repeatType;
      _isEnabled = widget.message!.isEnabled;
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
      title:
          Text(widget.message == null ? 'إضافة رسالة مجدولة' : 'تعديل الرسالة'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _recipientNameController,
                decoration: const InputDecoration(
                  labelText: 'اسم المستلم',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'يرجى إدخال اسم المستلم';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _recipientPhoneController,
                decoration: const InputDecoration(
                  labelText: 'رقم الهاتف',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'يرجى إدخال رقم الهاتف';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'محتوى الرسالة',
                  prefixIcon: Icon(Icons.message),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'يرجى إدخال محتوى الرسالة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('التاريخ'),
                subtitle: Text(DateFormat('yyyy/MM/dd').format(_selectedDate)),
                onTap: _selectDate,
              ),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('الوقت'),
                subtitle: Text(_selectedTime.format(context)),
                onTap: _selectTime,
              ),
              DropdownButtonFormField<RepeatType>(
                value: _repeatType,
                decoration: const InputDecoration(
                  labelText: 'التكرار',
                  prefixIcon: Icon(Icons.repeat),
                ),
                items: RepeatType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_getRepeatTypeText(type)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _repeatType = value!);
                },
              ),
              SwitchListTile(
                title: const Text('مفعل'),
                value: _isEnabled,
                onChanged: (value) {
                  setState(() => _isEnabled = value);
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
        TextButton(
          onPressed: _saveMessage,
          child: const Text('حفظ'),
        ),
      ],
    );

  String _getRepeatTypeText(RepeatType type) {
    switch (type) {
      case RepeatType.daily:
        return 'يومياً';
      case RepeatType.weekly:
        return 'أسبوعياً';
      case RepeatType.monthly:
        return 'شهرياً';
      case RepeatType.yearly:
        return 'سنوياً';
      case RepeatType.none:
        return 'لا يتكرر';
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  void _saveMessage() {
    if (!_formKey.currentState!.validate()) return;

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
      content: _contentController.text.trim(),
      recipientName: _recipientNameController.text.trim(),
      recipientNumber: _recipientPhoneController.text.trim(),
      recipientPhone: _recipientPhoneController.text.trim(),
      scheduledTime: scheduledTime,
      repeatType: _repeatType,
      isEnabled: _isEnabled,
      createdAt: widget.message?.createdAt ?? DateTime.now(),
      source: widget.message?.source ?? MessageSource.whatsapp,
    );

    if (widget.message == null) {
      ScheduledMessageService.addMessage(message);
    } else {
      ScheduledMessageService.updateMessage(message);
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _contentController.dispose();
    _recipientNameController.dispose();
    _recipientPhoneController.dispose();
    super.dispose();
  }
}
