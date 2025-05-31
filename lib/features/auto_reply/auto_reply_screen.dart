import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/localization/app_localizations.dart';
import '../../services/auto_reply_service.dart';

class AutoReplyScreen extends StatefulWidget {
  const AutoReplyScreen({super.key});

  @override
  State<AutoReplyScreen> createState() => _AutoReplyScreenState();
}

class _AutoReplyScreenState extends State<AutoReplyScreen> {
  bool _isWhatsAppEnabled = false;
  bool _isSMSEnabled = false;
  bool _isGroupsEnabled = false;
  bool _isBusinessEnabled = false;
  String _ownerName = '';
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _isWhatsAppEnabled = await AutoReplyService.isWhatsAppAutoReplyEnabled();
    _isSMSEnabled = await AutoReplyService.isSMSAutoReplyEnabled();
    _isGroupsEnabled = await AutoReplyService.isGroupsAutoReplyEnabled();
    _isBusinessEnabled = await AutoReplyService.isBusinessAutoReplyEnabled();
    _ownerName = await AutoReplyService.getOwnerName();
    _nameController.text = _ownerName;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الرد التلقائي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettings,
          ),
        ],
      ),
      body: Column(
        children: [
          // إعدادات الرد التلقائي
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'إعدادات الرد التلقائي',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('واتساب'),
                    subtitle: const Text('تفعيل الرد التلقائي على رسائل واتساب'),
                    value: _isWhatsAppEnabled,
                    onChanged: (value) async {
                      await AutoReplyService.setWhatsAppAutoReplyEnabled(value);
                      setState(() => _isWhatsAppEnabled = value);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('الرسائل النصية'),
                    subtitle: const Text('تفعيل الرد التلقائي على الرسائل النصية'),
                    value: _isSMSEnabled,
                    onChanged: (value) async {
                      await AutoReplyService.setSMSAutoReplyEnabled(value);
                      setState(() => _isSMSEnabled = value);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('المجموعات'),
                    subtitle: const Text('تفعيل الرد التلقائي في المجموعات'),
                    value: _isGroupsEnabled,
                    onChanged: (value) async {
                      await AutoReplyService.setGroupsAutoReplyEnabled(value);
                      setState(() => _isGroupsEnabled = value);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('الرسائل التجارية'),
                    subtitle: const Text('تفعيل الرد التلقائي على الرسائل التجارية'),
                    value: _isBusinessEnabled,
                    onChanged: (value) async {
                      await AutoReplyService.setBusinessAutoReplyEnabled(value);
                      setState(() => _isBusinessEnabled = value);
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // قائمة الرسائل المعلقة
          Expanded(
            child: ValueListenableBuilder<List<AutoReplyMessage>>(
              valueListenable: AutoReplyService.messagesNotifier,
              builder: (context, messages, child) {
                final pendingMessages = messages.where((m) => !m.isApproved).toList();
                
                if (pendingMessages.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, size: 64, color: Colors.green),
                        SizedBox(height: 16),
                        Text('لا توجد رسائل معلقة'),
                        Text('جميع الردود تم اعتمادها'),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  itemCount: pendingMessages.length,
                  itemBuilder: (context, index) {
                    final message = pendingMessages[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(message.senderName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('الرسالة: ${message.originalMessage}'),
                            const SizedBox(height: 4),
                            Text('الرد المقترح: ${message.suggestedReply}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editReply(message),
                            ),
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () => _approveReply(message),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _SettingsSheet(
        ownerName: _ownerName,
        onNameChanged: (name) async {
          await AutoReplyService.setOwnerName(name);
          setState(() => _ownerName = name);
        },
      ),
    );
  }

  Future<void> _editReply(AutoReplyMessage message) async {
    final controller = TextEditingController(text: message.suggestedReply);
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل الرد'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'اكتب الرد المعدل...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
    
    if (result != null && result.isNotEmpty) {
      await AutoReplyService.editReply(message.id, result);
    }
  }

  Future<void> _approveReply(AutoReplyMessage message) async {
    await AutoReplyService.approveReply(message.id);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}

class _SettingsSheet extends StatefulWidget {
  final String ownerName;
  final Function(String) onNameChanged;

  const _SettingsSheet({
    required this.ownerName,
    required this.onNameChanged,
  });

  @override
  State<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<_SettingsSheet> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.ownerName);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'إعدادات الرد التلقائي',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'اسم صاحب الجوال',
              hintText: 'أدخل اسمك هنا',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              widget.onNameChanged(_nameController.text);
              Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
