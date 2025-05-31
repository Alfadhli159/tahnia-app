import 'package:flutter/material.dart';
import 'package:tahania_app/services/auto_reply_service.dart';
import 'package:tahania_app/services/notification_service.dart';
import 'package:tahania_app/config/theme/app_theme.dart';

class AutoReplyScreen extends StatefulWidget {
  const AutoReplyScreen({Key? key}) : super(key: key);

  @override
  State<AutoReplyScreen> createState() => _AutoReplyScreenState();
}

class _AutoReplyScreenState extends State<AutoReplyScreen> {
  bool _isWhatsAppEnabled = false;
  bool _isSMSEnabled = false;
  bool _isGroupsEnabled = false;
  bool _isBusinessEnabled = false;
  String _ownerName = '';
  String _selectedStyle = 'professional';
  String _selectedLanguage = 'ar';

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _setupNotifications();
  }

  Future<void> _setupNotifications() async {
    // تحديث إشعار الرسائل المعلقة عند فتح الشاشة
    await NotificationService.schedulePendingMessagesNotification();
  }

  Future<void> _loadSettings() async {
    _isWhatsAppEnabled = await AutoReplyService.isWhatsAppAutoReplyEnabled();
    _isSMSEnabled = await AutoReplyService.isSMSAutoReplyEnabled();
    _isGroupsEnabled = await AutoReplyService.isGroupsAutoReplyEnabled();
    _isBusinessEnabled = await AutoReplyService.isBusinessAutoReplyEnabled();
    _ownerName = await AutoReplyService.getOwnerName();
    _selectedStyle = await AutoReplyService.getReplyStyle();
    _selectedLanguage = await AutoReplyService.getLanguage();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الردود التلقائية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettings,
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط الحالة
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.primaryColor.withOpacity(0.1),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      _isWhatsAppEnabled ? Icons.check_circle : Icons.cancel,
                      color: _isWhatsAppEnabled ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    const Text('الرد التلقائي للواتساب'),
                    const Spacer(),
                    Switch(
                      value: _isWhatsAppEnabled,
                      onChanged: (value) async {
                        await AutoReplyService.setWhatsAppAutoReplyEnabled(value);
                        setState(() {
                          _isWhatsAppEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      _isSMSEnabled ? Icons.check_circle : Icons.cancel,
                      color: _isSMSEnabled ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    const Text('الرد التلقائي للرسائل النصية'),
                    const Spacer(),
                    Switch(
                      value: _isSMSEnabled,
                      onChanged: (value) async {
                        await AutoReplyService.setSMSAutoReplyEnabled(value);
                        setState(() {
                          _isSMSEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // قائمة الرسائل
          Expanded(
            child: ValueListenableBuilder<List<AutoReplyMessage>>(
              valueListenable: AutoReplyService.messagesNotifier,
              builder: (context, messages, child) {
                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'لا توجد رسائل جديدة',
                      style: theme.textTheme.titleLarge,
                    ),
                  );
                }

                // تصنيف الرسائل
                final pendingMessages = messages.where((m) => m.status == AutoReplyStatus.pending).toList();
                final otherMessages = messages.where((m) => m.status != AutoReplyStatus.pending).toList();

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (pendingMessages.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'رسائل تحتاج إلى اعتماد (${pendingMessages.length})',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ...pendingMessages.map((message) => _buildMessageCard(message, theme)),
                      const Divider(height: 32),
                    ],
                    if (otherMessages.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'الرسائل السابقة',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      ...otherMessages.map((message) => _buildMessageCard(message, theme)),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(AutoReplyMessage message, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // معلومات المرسل
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
                      message.senderName,
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      message.senderNumber,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                const Spacer(),
                _buildMessageTypeChip(message.type),
                const SizedBox(width: 8),
                _buildSentimentChip(message.sentiment),
                const SizedBox(width: 8),
                Text(
                  _formatDate(message.receivedTime),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // الرسالة الأصلية
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.dividerColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الرسالة الأصلية:',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(message.originalMessage),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // الرد المقترح
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.primaryColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'الرد المقترح:',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.primaryColor,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'ثقة: ${(message.confidence * 100).toInt()}%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message.customReply ?? message.suggestedReply,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // الردود البديلة
            if (message.alternativeReplies.isNotEmpty) ...[
              Text(
                'ردود بديلة:',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              ...message.alternativeReplies.map((reply) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => _editReply(message, reply),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.dividerColor,
                      ),
                    ),
                    child: Text(reply),
                  ),
                ),
              )),
              const SizedBox(height: 16),
            ],

            // أزرار الإجراءات
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (message.status == AutoReplyStatus.pending) ...[
                  TextButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('تعديل'),
                    onPressed: () => _editReply(message),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('اعتماد'),
                    onPressed: () => _approveReply(message),
                  ),
                ] else if (message.status == AutoReplyStatus.sent) ...[
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'تم الإرسال',
                    style: TextStyle(color: Colors.green),
                  ),
                ] else if (message.status == AutoReplyStatus.failed) ...[
                  const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'فشل الإرسال',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageTypeChip(MessageType type) {
    Color color;
    String label;

    switch (type) {
      case MessageType.greeting:
        color = Colors.green;
        label = 'تهنئة';
        break;
      case MessageType.condolence:
        color = Colors.grey;
        label = 'تعزية';
        break;
      case MessageType.invitation:
        color = Colors.orange;
        label = 'دعوة';
        break;
      case MessageType.business:
        color = Colors.blue;
        label = 'تجاري';
        break;
      case MessageType.spam:
        color = Colors.red;
        label = 'مزعج';
        break;
      default:
        color = Colors.grey;
        label = 'عام';
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildSentimentChip(MessageSentiment sentiment) {
    Color color;
    String label;

    switch (sentiment) {
      case MessageSentiment.positive:
        color = Colors.green;
        label = 'إيجابي';
        break;
      case MessageSentiment.negative:
        color = Colors.red;
        label = 'سلبي';
        break;
      default:
        color = Colors.grey;
        label = 'محايد';
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _SettingsSheet(
        ownerName: _ownerName,
        selectedStyle: _selectedStyle,
        selectedLanguage: _selectedLanguage,
        isGroupsEnabled: _isGroupsEnabled,
        isBusinessEnabled: _isBusinessEnabled,
        onSave: (name, style, language, groups, business) async {
          await AutoReplyService.setOwnerName(name);
          await AutoReplyService.setReplyStyle(style);
          await AutoReplyService.setLanguage(language);
          await AutoReplyService.setGroupsAutoReplyEnabled(groups);
          await AutoReplyService.setBusinessAutoReplyEnabled(business);
          await _loadSettings();
        },
      ),
    );
  }

  Future<void> _editReply(AutoReplyMessage message, [String? initialText]) async {
    final controller = TextEditingController(
      text: initialText ?? message.customReply ?? message.suggestedReply,
    );

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل الرد'),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'اكتب الرد هنا...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );

    if (result != null) {
      await AutoReplyService.editReply(message.id, result);
    }
  }

  Future<void> _approveReply(AutoReplyMessage message) async {
    await AutoReplyService.approveReply(message.id);
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day} ${date.hour}:${date.minute}';
  }
}

class _SettingsSheet extends StatefulWidget {
  final String ownerName;
  final String selectedStyle;
  final String selectedLanguage;
  final bool isGroupsEnabled;
  final bool isBusinessEnabled;
  final Function(String, String, String, bool, bool) onSave;

  const _SettingsSheet({
    required this.ownerName,
    required this.selectedStyle,
    required this.selectedLanguage,
    required this.isGroupsEnabled,
    required this.isBusinessEnabled,
    required this.onSave,
  });

  @override
  State<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<_SettingsSheet> {
  late TextEditingController _nameController;
  late String _selectedStyle;
  late String _selectedLanguage;
  late bool _isGroupsEnabled;
  late bool _isBusinessEnabled;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.ownerName);
    _selectedStyle = widget.selectedStyle;
    _selectedLanguage = widget.selectedLanguage;
    _isGroupsEnabled = widget.isGroupsEnabled;
    _isBusinessEnabled = widget.isBusinessEnabled;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'إعدادات الرد التلقائي',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'اسم صاحب الجوال',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedStyle,
              decoration: const InputDecoration(
                labelText: 'أسلوب الرد',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'professional',
                  child: Text('احترافي'),
                ),
                DropdownMenuItem(
                  value: 'friendly',
                  child: Text('ودود'),
                ),
                DropdownMenuItem(
                  value: 'formal',
                  child: Text('رسمي'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedStyle = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              decoration: const InputDecoration(
                labelText: 'لغة الرد',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'ar',
                  child: Text('العربية'),
                ),
                DropdownMenuItem(
                  value: 'en',
                  child: Text('English'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('الرد التلقائي في المجموعات'),
              value: _isGroupsEnabled,
              onChanged: (value) {
                setState(() {
                  _isGroupsEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('الرد التلقائي للرسائل التجارية'),
              value: _isBusinessEnabled,
              onChanged: (value) {
                setState(() {
                  _isBusinessEnabled = value;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                widget.onSave(
                  _nameController.text,
                  _selectedStyle,
                  _selectedLanguage,
                  _isGroupsEnabled,
                  _isBusinessEnabled,
                );
                Navigator.pop(context);
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }
} 