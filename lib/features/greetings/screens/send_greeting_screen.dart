import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../../../core/services/openai_service.dart';

class SendGreetingScreen extends StatefulWidget {
  const SendGreetingScreen({super.key});

  @override
  State<SendGreetingScreen> createState() => _SendGreetingScreenState();
}

class _SendGreetingScreenState extends State<SendGreetingScreen> {
  // Step tracking
  int currentStep = 0;
  
  // Contact selection
  List<Contact> allContacts = [];
  List<Contact> filteredContacts = [];
  List<Contact> selectedContacts = [];
  List<Group> allGroups = [];
  String? selectedGroupId;
  String searchKeyword = '';
  
  // Greeting configuration
  String selectedType = 'نص'; // نص, بوستر, ملصق
  String selectedOccasion = 'تهنئة عامة';
  
  // Message
  final TextEditingController messageController = TextEditingController();
  final TextEditingController senderNameController = TextEditingController();
  bool isLoading = false;

  final List<String> greetingTypes = ['نص', 'بوستر', 'ملصق'];
  final List<String> occasions = [
    'تهنئة عامة',
    'عيد ميلاد',
    'نجاح',
    'زواج',
    'مناسبة دينية',
    'تخرج',
    'ترقية',
    'مولود جديد'
  ];

  @override
  void initState() {
    super.initState();
    loadContactsAndGroups();
  }

  Future<void> loadContactsAndGroups() async {
    setState(() => isLoading = true);
    await FlutterContacts.requestPermission();
    final contacts = await FlutterContacts.getContacts(withProperties: true);
    final groups = await FlutterContacts.getGroups();
    setState(() {
      allContacts = contacts;
      filteredContacts = contacts;
      allGroups = groups;
      isLoading = false;
    });
  }

  void filterContacts(String keyword) {
    setState(() {
      searchKeyword = keyword;
      filteredContacts = allContacts.where((c) =>
        c.displayName.toLowerCase().contains(keyword.toLowerCase()) ||
        (c.phones.isNotEmpty && c.phones.first.number.contains(keyword))
      ).toList();
    });
  }

  void nextStep() {
    if (currentStep < 3) {
      setState(() => currentStep++);
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    }
  }

  bool canProceedFromStep(int step) {
    switch (step) {
      case 0: // Contacts step
        return selectedContacts.isNotEmpty || selectedGroupId != null;
      case 1: // Type step
        return selectedType.isNotEmpty;
      case 2: // Occasion step
        return selectedOccasion.isNotEmpty;
      case 3: // Message step
        return messageController.text.trim().isNotEmpty;
      default:
        return false;
    }
  }

  Future<void> generateGreetingMessage() async {
    if (selectedContacts.isEmpty && selectedGroupId == null) return;
    
    setState(() => isLoading = true);
    
    String recipientName = '';
    if (selectedContacts.isNotEmpty) {
      recipientName = selectedContacts.first.displayName.split(' ').first;
    } else if (selectedGroupId != null) {
      final group = allGroups.firstWhere((g) => g.id == selectedGroupId);
      recipientName = group.name;
    }
    
    // Build prompt based on type and occasion
    String prompt = 'اكتب تهنئة $selectedOccasion ';
    switch (selectedType) {
      case 'بوستر':
        prompt += 'مناسبة للعرض على بوستر مميز وأنيقة';
        break;
      case 'ملصق':
        prompt += 'قصيرة ومختصرة تصلح كملصق Sticker';
        break;
      default:
        prompt += 'نصية مميزة ومؤثرة';
    }
    prompt += ' باللغة العربية';
    
    try {
      final generatedMessage = await OpenAIService.generateGreeting(prompt);
      
      // Format message with recipient name and sender signature
      String formattedMessage = '';
      if (selectedContacts.isNotEmpty) {
        formattedMessage = '$recipientName العزيز/ة،\n\n';
      } else {
        formattedMessage = 'أعضاء $recipientName الأعزاء،\n\n';
      }
      
      formattedMessage += generatedMessage;
      
      // Add sender signature if provided
      final senderName = senderNameController.text.trim();
      if (senderName.isNotEmpty) {
        formattedMessage += '\n\n— $senderName';
      }
      
      messageController.text = formattedMessage;
    } catch (e) {
      messageController.text = 'حدث خطأ في توليد الرسالة. يرجى المحاولة مرة أخرى.';
    }
    
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إرسال تهنئة 🎁'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Step indicator
                  _buildStepIndicator(),
                  // Content
                  Expanded(
                    child: _buildStepContent(),
                  ),
                  // Navigation buttons
                  _buildNavigationButtons(),
                ],
              ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          for (int i = 0; i < 4; i++)
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: i <= currentStep ? Colors.teal : Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    if (i < 3)
                      Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: i < currentStep ? Colors.teal : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          size: 12,
                          color: i < currentStep ? Colors.white : Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return _buildContactsStep();
      case 1:
        return _buildTypeStep();
      case 2:
        return _buildOccasionStep();
      case 3:
        return _buildMessageStep();
      default:
        return Container();
    }
  }

  Widget _buildContactsStep() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الخطوة 1: اختر المستلمين',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              hintText: 'بحث في جهات الاتصال...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: filterContacts,
          ),
          const SizedBox(height: 16),
          if (allGroups.isNotEmpty) ...[
            const Text('المجموعات:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: allGroups.length,
                itemBuilder: (context, index) {
                  final group = allGroups[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ChoiceChip(
                      label: Text(group.name),
                      selected: selectedGroupId == group.id,
                      onSelected: (selected) {
                        setState(() {
                          selectedGroupId = selected ? group.id : null;
                          selectedContacts.clear();
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
          const Text('جهات الاتصال:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = filteredContacts[index];
                final isSelected = selectedContacts.contains(contact);
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      contact.displayName.isNotEmpty ? contact.displayName[0] : '?',
                    ),
                  ),
                  title: Text(contact.displayName),
                  subtitle: Text(
                    contact.phones.isNotEmpty ? contact.phones.first.number : 'بدون رقم',
                  ),
                  trailing: Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          selectedContacts.add(contact);
                          selectedGroupId = null;
                        } else {
                          selectedContacts.remove(contact);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeStep() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الخطوة 2: اختر نوع التهنئة',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          ...greetingTypes.map((type) {
            IconData icon;
            String description;
            switch (type) {
              case 'بوستر':
                icon = Icons.image;
                description = 'تهنئة مصممة للعرض كبوستر أنيق';
                break;
              case 'ملصق':
                icon = Icons.emoji_emotions;
                description = 'تهنئة قصيرة ومختصرة كملصق';
                break;
              default:
                icon = Icons.text_fields;
                description = 'تهنئة نصية تقليدية';
            }
            
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: RadioListTile<String>(
                value: type,
                groupValue: selectedType,
                onChanged: (value) {
                  setState(() => selectedType = value!);
                },
                title: Row(
                  children: [
                    Icon(icon, color: Colors.teal),
                    const SizedBox(width: 12),
                    Text(type, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                subtitle: Text(description),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildOccasionStep() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الخطوة 3: اختر المناسبة',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: occasions.length,
              itemBuilder: (context, index) {
                final occasion = occasions[index];
                final isSelected = selectedOccasion == occasion;
                
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedOccasion = occasion);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.teal : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.teal : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        occasion,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageStep() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الخطوة 4: إنشاء وإرسال الرسالة',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'اسم المرسل:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: senderNameController,
            decoration: const InputDecoration(
              hintText: 'أدخل اسمك (اختياري)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: generateGreetingMessage,
            icon: const Icon(Icons.auto_fix_high),
            label: const Text('توليد نص التهنئة بالذكاء الاصطناعي'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'نص التهنئة:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TextField(
              controller: messageController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                hintText: 'سيظهر نص التهنئة هنا... يمكنك التعديل عليه',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: canProceedFromStep(3) ? _sendGreetingViaWhatsApp : null,
              icon: const Icon(Icons.send),
              label: const Text('إرسال التهنئة عبر واتساب'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: ElevatedButton(
                onPressed: previousStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black87,
                ),
                child: const Text('السابق'),
              ),
            ),
          if (currentStep > 0) const SizedBox(width: 16),
          if (currentStep < 3)
            Expanded(
              child: ElevatedButton(
                onPressed: canProceedFromStep(currentStep) ? nextStep : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                child: const Text('التالي'),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _sendGreetingViaWhatsApp() async {
    final message = messageController.text.trim();
    if (message.isEmpty) return;

    // Send to selected contacts
    for (final contact in selectedContacts) {
      if (contact.phones.isNotEmpty) {
        final phoneNumber = contact.phones.first.number;
        await _launchWhatsApp(phoneNumber, message);
      }
    }

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إرسال التهنئة إلى ${selectedContacts.length} جهة اتصال'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Reset the form
      setState(() {
        currentStep = 0;
        selectedContacts.clear();
        selectedGroupId = null;
        selectedType = 'نص';
        selectedOccasion = 'تهنئة عامة';
        messageController.clear();
        senderNameController.clear();
      });
    }
  }

  Future<void> _launchWhatsApp(String phoneNumber, String message) async {
    // Accept phone numbers as they are stored in contacts
    // Remove only spaces, dashes, parentheses, but keep + and digits
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // If number starts with 00, replace with +
    if (cleanNumber.startsWith('00')) {
      cleanNumber = '+${cleanNumber.substring(2)}';
    }
    
    // If number starts with 05 (Saudi local format), add country code
    if (cleanNumber.startsWith('05')) {
      cleanNumber = '+966${cleanNumber.substring(1)}';
    }
    
    final uri = Uri.parse('whatsapp://send?phone=$cleanNumber&text=${Uri.encodeComponent(message)}');
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        // Fallback to web WhatsApp
        final webUri = Uri.parse('https://wa.me/$cleanNumber?text=${Uri.encodeComponent(message)}');
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل في فتح واتساب')),
        );
      }
    }
  }
}
