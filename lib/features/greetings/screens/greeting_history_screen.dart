import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../services/localization/app_localizations.dart';
import '../../../services/storage/storage_service.dart';

class GreetingHistoryScreen extends StatefulWidget {
  const GreetingHistoryScreen({super.key});

  @override
  State<GreetingHistoryScreen> createState() => _GreetingHistoryScreenState();
}

class _GreetingHistoryScreenState extends State<GreetingHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _sentGreetings = [];
  List<Map<String, dynamic>> _scheduledGreetings = [];
  List<Map<String, dynamic>> _drafts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    
    try {
      final allGreetings = await StorageService.getAllGreetings();
      
      setState(() {
        _sentGreetings = allGreetings.where((g) => g['status'] == 'sent').toList();
        _scheduledGreetings = allGreetings.where((g) => g['status'] == 'scheduled').toList();
        _drafts = allGreetings.where((g) => g['status'] == 'draft').toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('حدث خطأ في تحميل السجل');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('history.title')),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: AppLocalizations.of(context).translate('history.sent')),
            Tab(text: AppLocalizations.of(context).translate('history.scheduled')),
            Tab(text: AppLocalizations.of(context).translate('history.drafts')),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadHistory,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildGreetingsList(_sentGreetings, 'sent'),
                _buildGreetingsList(_scheduledGreetings, 'scheduled'),
                _buildGreetingsList(_drafts, 'draft'),
              ],
            ),
    );
  }

  Widget _buildGreetingsList(List<Map<String, dynamic>> greetings, String type) {
    if (greetings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              type == 'sent' ? Icons.send : 
              type == 'scheduled' ? Icons.schedule : Icons.drafts,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              type == 'sent' ? 'لا توجد رسائل مرسلة' :
              type == 'scheduled' ? 'لا توجد رسائل مجدولة' : 'لا توجد مسودات',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: greetings.length,
      itemBuilder: (context, index) {
        final greeting = greetings[index];
        return _buildGreetingCard(greeting, type);
      },
    );
  }

  Widget _buildGreetingCard(Map<String, dynamic> greeting, String type) {
    final date = DateTime.tryParse(greeting['date'] ?? '') ?? DateTime.now();
    final formattedDate = DateFormat('yyyy/MM/dd HH:mm').format(date);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          greeting['occasion'] ?? 'مناسبة غير محددة',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting['message'] ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              formattedDate,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (greeting['recipients'] != null)
              Text(
                'المستلمون: ${(greeting['recipients'] as List).length}',
                style: const TextStyle(fontSize: 12, color: Colors.blue),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(value, greeting, type),
          itemBuilder: (context) => [
            if (type == 'draft')
              const PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('تعديل'),
                ),
              ),
            if (type != 'sent')
              const PopupMenuItem(
                value: 'send',
                child: ListTile(
                  leading: Icon(Icons.send),
                  title: Text('إرسال'),
                ),
              ),
            if (type == 'sent')
              const PopupMenuItem(
                value: 'resend',
                child: ListTile(
                  leading: Icon(Icons.refresh),
                  title: Text('إعادة إرسال'),
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
        onTap: () => _showGreetingDetails(greeting),
      ),
    );
  }

  void _handleMenuAction(String action, Map<String, dynamic> greeting, String type) {
    switch (action) {
      case 'edit':
        _editGreeting(greeting);
        break;
      case 'send':
        _sendGreeting(greeting);
        break;
      case 'resend':
        _resendGreeting(greeting);
        break;
      case 'delete':
        _deleteGreeting(greeting);
        break;
    }
  }

  void _editGreeting(Map<String, dynamic> greeting) {
    // Navigate to edit screen
    Navigator.pushNamed(context, '/sendGreeting', arguments: greeting);
  }

  void _sendGreeting(Map<String, dynamic> greeting) {
    // Implement send logic
    _showError('سيتم تنفيذ إرسال الرسالة قريباً');
  }

  void _resendGreeting(Map<String, dynamic> greeting) {
    // Implement resend logic
    _showError('سيتم تنفيذ إعادة الإرسال قريباً');
  }

  void _deleteGreeting(Map<String, dynamic> greeting) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذه الرسالة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Delete from storage
              await StorageService.saveGreeting(greeting['id'], {
                ...greeting,
                'deleted': true,
              });
              _loadHistory();
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showGreetingDetails(Map<String, dynamic> greeting) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(greeting['occasion'] ?? 'تفاصيل الرسالة'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'الرسالة:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(greeting['message'] ?? ''),
              const SizedBox(height: 16),
              if (greeting['senderName'] != null) ...[
                Text(
                  'المرسل:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(greeting['senderName']),
                const SizedBox(height: 16),
              ],
              if (greeting['recipients'] != null) ...[
                Text(
                  'المستلمون:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('${(greeting['recipients'] as List).length} شخص'),
                const SizedBox(height: 16),
              ],
              Text(
                'التاريخ:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('yyyy/MM/dd HH:mm').format(
                  DateTime.tryParse(greeting['date'] ?? '') ?? DateTime.now(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
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
