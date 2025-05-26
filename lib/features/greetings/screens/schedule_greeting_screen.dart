import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/services/openai_service.dart';

class ScheduledGreeting {
  final String id;
  final String message;
  final DateTime scheduledTime;
  final String recipient;
  final String recipientType; // 'individual', 'group', 'all'
  final bool isCompleted;
  final DateTime createdAt;

  ScheduledGreeting({
    required this.id,
    required this.message,
    required this.scheduledTime,
    required this.recipient,
    required this.recipientType,
    this.isCompleted = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'scheduledTime': scheduledTime.millisecondsSinceEpoch,
      'recipient': recipient,
      'recipientType': recipientType,
      'isCompleted': isCompleted,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ScheduledGreeting.fromMap(Map<String, dynamic> map) {
    return ScheduledGreeting(
      id: map['id'] ?? '',
      message: map['message'] ?? '',
      scheduledTime: DateTime.fromMillisecondsSinceEpoch(map['scheduledTime'] ?? 0),
      recipient: map['recipient'] ?? '',
      recipientType: map['recipientType'] ?? 'individual',
      isCompleted: map['isCompleted'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
    );
  }

  ScheduledGreeting copyWith({
    String? id,
    String? message,
    DateTime? scheduledTime,
    String? recipient,
    String? recipientType,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return ScheduledGreeting(
      id: id ?? this.id,
      message: message ?? this.message,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      recipient: recipient ?? this.recipient,
      recipientType: recipientType ?? this.recipientType,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ScheduleGreetingScreen extends StatefulWidget {
  const ScheduleGreetingScreen({super.key});

  @override
  State<ScheduleGreetingScreen> createState() => _ScheduleGreetingScreenState();
}

class _ScheduleGreetingScreenState extends State<ScheduleGreetingScreen> {
  final TextEditingController messageController = TextEditingController();
  final TextEditingController recipientController = TextEditingController();
  
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedRecipientType = 'individual';
  bool isLoading = false;
  bool isBoxLoading = true;
  String? boxError;

  List<ScheduledGreeting> scheduledGreetings = [];
  late Box scheduledBox;

  @override
  void initState() {
    super.initState();
    _initializeHive();
    _generateInitialMessage();
  }

  Future<void> _initializeHive() async {
    try {
      scheduledBox = await Hive.openBox('scheduledGreetings');
      _loadScheduledGreetings();
      setState(() {
        isBoxLoading = false;
      });
    } catch (e) {
      setState(() {
        boxError = 'حدث خطأ أثناء تحميل البيانات';
        isBoxLoading = false;
      });
    }
  }

  void _loadScheduledGreetings() {
    final greetingsData = scheduledBox.values.toList();
    setState(() {
      scheduledGreetings = greetingsData
          .map((data) => ScheduledGreeting.fromMap(Map<String, dynamic>.from(data)))
          .toList();
      
      // Sort by scheduled time
      scheduledGreetings.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
    });
  }

  Future<void> _generateInitialMessage() async {
    setState(() => isLoading = true);
    final msg = await OpenAIService.generateGreeting('نص');
    messageController.text = msg;
    setState(() => isLoading = false);
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('ar'),
    );
    
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _scheduleGreeting() {
    if (messageController.text.trim().isEmpty) {
      _showSnackBar('يرجى إدخال نص التهنئة');
      return;
    }

    if (selectedRecipientType != 'all' && recipientController.text.trim().isEmpty) {
      _showSnackBar('يرجى إدخال المستلم');
      return;
    }

    final scheduledDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    if (scheduledDateTime.isBefore(DateTime.now())) {
      _showSnackBar('لا يمكن جدولة تهنئة في الماضي');
      return;
    }

    final greeting = ScheduledGreeting(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: messageController.text.trim(),
      scheduledTime: scheduledDateTime,
      recipient: selectedRecipientType == 'all' ? 'الجميع' : recipientController.text.trim(),
      recipientType: selectedRecipientType,
      createdAt: DateTime.now(),
    );

    _saveScheduledGreeting(greeting);
    _showSnackBar('تم جدولة التهنئة بنجاح');
    _clearForm();
  }

  Future<void> _saveScheduledGreeting(ScheduledGreeting greeting) async {
    await scheduledBox.put(greeting.id, greeting.toMap());
    _loadScheduledGreetings();
  }

  Future<void> _deleteScheduledGreeting(String id) async {
    await scheduledBox.delete(id);
    _loadScheduledGreetings();
  }

  void _clearForm() {
    messageController.clear();
    recipientController.clear();
    setState(() {
      selectedDate = DateTime.now().add(const Duration(days: 1));
      selectedTime = TimeOfDay.now();
      selectedRecipientType = 'individual';
    });
    _generateInitialMessage();
  }

  void _sendNow(ScheduledGreeting greeting) async {
    final message = Uri.encodeComponent(greeting.message);
    final url = 'https://wa.me/?text=$message';

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        
        // Mark as completed
        final updatedGreeting = greeting.copyWith(isCompleted: true);
        await _saveScheduledGreeting(updatedGreeting);
      } else {
        _showSnackBar('تعذر فتح واتساب');
      }
    } catch (e) {
      _showSnackBar('حدث خطأ في الإرسال');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    
    if (difference.inDays == 0) {
      return 'اليوم ${_formatTime(TimeOfDay.fromDateTime(dateTime))}';
    } else if (difference.inDays == 1) {
      return 'غداً ${_formatTime(TimeOfDay.fromDateTime(dateTime))}';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${_formatTime(TimeOfDay.fromDateTime(dateTime))}';
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('جدولة تهنئة ⏰'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        body: isBoxLoading
            ? const Center(child: CircularProgressIndicator())
            : boxError != null
                ? Center(child: Text(boxError!, style: const TextStyle(color: Colors.red)))
                : Column(
                    children: [
                      // Form section
                      Expanded(
                        flex: 3,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('نص التهنئة:'),
                              TextField(
                                controller: messageController,
                                maxLines: 4,
                                decoration: InputDecoration(
                                  hintText: 'اكتب نص التهنئة...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  suffixIcon: isLoading
                                      ? const Padding(
                                          padding: EdgeInsets.all(12),
                                          child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          ),
                                        )
                                      : IconButton(
                                          onPressed: _generateInitialMessage,
                                          icon: const Icon(Icons.refresh),
                                          tooltip: 'توليد رسالة جديدة',
                                        ),
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              _buildLabel('نوع المستلم:'),
                              Wrap(
                                spacing: 12,
                                children: [
                                  ChoiceChip(
                                    label: const Text('فرد'),
                                    selected: selectedRecipientType == 'individual',
                                    onSelected: (_) => setState(() => selectedRecipientType = 'individual'),
                                  ),
                                  ChoiceChip(
                                    label: const Text('مجموعة'),
                                    selected: selectedRecipientType == 'group',
                                    onSelected: (_) => setState(() => selectedRecipientType = 'group'),
                                  ),
                                  ChoiceChip(
                                    label: const Text('الجميع'),
                                    selected: selectedRecipientType == 'all',
                                    onSelected: (_) => setState(() => selectedRecipientType = 'all'),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 16),
                              
                              if (selectedRecipientType != 'all') ...[
                                _buildLabel('المستلم:'),
                                TextField(
                                  controller: recipientController,
                                  decoration: InputDecoration(
                                    hintText: selectedRecipientType == 'individual' 
                                        ? 'اسم الشخص أو رقم الهاتف'
                                        : 'اسم المجموعة',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                              
                              _buildLabel('التاريخ والوقت:'),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: _selectDate,
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.calendar_today),
                                            const SizedBox(width: 8),
                                            Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: InkWell(
                                      onTap: _selectTime,
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.access_time),
                                            const SizedBox(width: 8),
                                            Text(_formatTime(selectedTime)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 24),
                              
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _scheduleGreeting,
                                  icon: const Icon(Icons.schedule, color: Colors.white),
                                  label: const Text(
                                    'جدولة التهنئة',
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Scheduled greetings list
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            border: Border(top: BorderSide(color: Colors.grey.shade300)),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    const Icon(Icons.schedule, color: Colors.teal),
                                    const SizedBox(width: 8),
                                    Text(
                                      'التهاني المجدولة (${scheduledGreetings.length})',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: scheduledGreetings.isEmpty
                                    ? const Center(
                                        child: Text(
                                          'لا توجد تهاني مجدولة',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      )
                                    : ListView.builder(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        itemCount: scheduledGreetings.length,
                                        itemBuilder: (context, index) {
                                          final greeting = scheduledGreetings[index];
                                          final isPast = greeting.scheduledTime.isBefore(DateTime.now());
                                          
                                          return Card(
                                            margin: const EdgeInsets.only(bottom: 8),
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor: greeting.isCompleted 
                                                    ? Colors.green 
                                                    : isPast 
                                                        ? Colors.orange 
                                                        : Colors.teal,
                                                child: Icon(
                                                  greeting.isCompleted 
                                                      ? Icons.check 
                                                      : isPast 
                                                          ? Icons.warning 
                                                          : Icons.schedule,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              title: Text(
                                                greeting.recipient,
                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    greeting.message.length > 50
                                                        ? '${greeting.message.substring(0, 50)}...'
                                                        : greeting.message,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    _formatDateTime(greeting.scheduledTime),
                                                    style: TextStyle(
                                                      color: isPast ? Colors.orange : Colors.teal,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  if (!greeting.isCompleted)
                                                    IconButton(
                                                      onPressed: () => _sendNow(greeting),
                                                      icon: const Icon(Icons.send, color: Colors.teal),
                                                      tooltip: 'إرسال الآن',
                                                    ),
                                                  IconButton(
                                                    onPressed: () => _deleteScheduledGreeting(greeting.id),
                                                    icon: const Icon(Icons.delete, color: Colors.red),
                                                    tooltip: 'حذف',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    recipientController.dispose();
    super.dispose();
  }
}
