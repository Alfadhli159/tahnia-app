import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/services/openai_service.dart';

class SendGreetingScreen extends StatefulWidget {
  const SendGreetingScreen({super.key});

  @override
  State<SendGreetingScreen> createState() => _SendGreetingScreenState();
}

class _SendGreetingScreenState extends State<SendGreetingScreen> {
  // Controllers
  final TextEditingController messageController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController senderNameController = TextEditingController();
  final TextEditingController recipientNameController = TextEditingController();
  
  // Data
  Map<String, List<String>> occasionsByCategory = {};
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  List<String> selectedContactIds = [];
  
  // State variables
  String? selectedCategory;
  String? selectedOccasion;
  String? selectedMessageType;
  bool isLoadingContacts = true;
  bool isGeneratingMessage = false;
  bool isSearching = false;
  
  // Message types
  final List<Map<String, String>> messageTypes = [
    {'name': 'نصية', 'emoji': '📝', 'description': 'رسالة نصية تقليدية'},
    {'name': 'بوستر', 'emoji': '🖼️', 'description': 'رسالة مصممة للعرض'},
    {'name': 'ملصق', 'emoji': '🏷️', 'description': 'رسالة قصيرة ومختصرة'},
    {'name': 'شعري', 'emoji': '📜', 'description': 'رسالة شعرية جميلة'},
    {'name': 'رسمي', 'emoji': '🎩', 'description': 'رسالة رسمية ومهذبة'},
    {'name': 'ودود', 'emoji': '😊', 'description': 'رسالة ودودة وحميمة'},
  ];

  @override
  void initState() {
    super.initState();
    loadOccasions();
    loadContacts();
  }

  Future<void> loadOccasions() async {
    try {
      final String data = await rootBundle.loadString('assets/data/occasions_by_category.json');
      final Map<String, dynamic> jsonMap = json.decode(data);
      setState(() {
        occasionsByCategory = jsonMap.map((k, v) => MapEntry(k, List<String>.from(v)));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ في تحميل المناسبات')),
      );
    }
  }

  Future<void> loadContacts() async {
    if (await Permission.contacts.request().isGranted) {
      setState(() => isLoadingContacts = true);
      
      try {
        final fetched = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: false,
        );
        
        setState(() {
          contacts = fetched;
          filteredContacts = fetched;
          isLoadingContacts = false;
        });
      } catch (e) {
        setState(() => isLoadingContacts = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ في تحميل جهات الاتصال')),
        );
      }
    } else {
      setState(() => isLoadingContacts = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب السماح بالوصول إلى جهات الاتصال')),
      );
    }
  }

  void filterContacts(String query) {
    setState(() {
      isSearching = true;
      if (query.isEmpty) {
        filteredContacts = contacts;
      } else {
        filteredContacts = contacts.where((contact) {
          final name = "${contact.name.first} ${contact.name.last}".toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void toggleContact(String id) {
    setState(() {
      if (selectedContactIds.contains(id)) {
        selectedContactIds.remove(id);
      } else {
        selectedContactIds.add(id);
      }
    });
  }

  void toggleSelectAll() {
    setState(() {
      if (selectedContactIds.length == contacts.length) {
        selectedContactIds.clear();
      } else {
        selectedContactIds = contacts.map((c) => c.id).toList();
      }
    });
  }

  Future<void> generateMessage() async {
    if (selectedCategory == null || selectedOccasion == null || selectedMessageType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار نوع المناسبة والمناسبة ونوع الرسالة')),
      );
      return;
    }

    setState(() => isGeneratingMessage = true);

    // جلب الأسماء من الحقول
    final senderName = senderNameController.text.trim();
    final recipientName = recipientNameController.text.trim();

    // توليد prompt ديناميكي حسب نوع الرسالة
    String prompt = '';
    switch (selectedMessageType) {
      case 'نصية':
        prompt =
            'أنشئ رسالة تهنئة نصية قصيرة بمناسبة $selectedOccasion، بأسلوب لبق وودي، مع دعاء أو عبارة محببة، وراعِ الطابع السعودي إن أمكن. اسم المرسل: $senderName. اسم المستلم: $recipientName.';
        break;
      case 'بوستر':
        prompt =
            'اقترح جملة جذابة توضع في بطاقة تهنئة رسمية بمناسبة $selectedOccasion، بأسلوب أنيق وملهم. اسم المرسل: $senderName. اسم المستلم: $recipientName.';
        break;
      case 'ملصق':
        prompt =
            'اكتب جملة مرحة أو مختصرة جدًا بلغة بصرية جذابة تصلح كملصق تهنئة بمناسبة $selectedOccasion. اسم المرسل: $senderName. اسم المستلم: $recipientName.';
        break;
      case 'شعري':
        prompt =
            'اكتب بيت شعر أو مقطع شعري قصير مناسب للتهنئة بمناسبة $selectedOccasion، بأسلوب جميل. اسم المرسل: $senderName. اسم المستلم: $recipientName.';
        break;
      case 'رسمي':
        prompt =
            'اكتب رسالة تهنئة رسمية ومهذبة بمناسبة $selectedOccasion، مع توقيع رسمي. اسم المرسل: $senderName. اسم المستلم: $recipientName.';
        break;
      case 'ودود':
        prompt =
            'اكتب رسالة تهنئة ودودة وحميمة بمناسبة $selectedOccasion، بأسلوب بسيط وصادق. اسم المرسل: $senderName. اسم المستلم: $recipientName.';
        break;
      default:
        prompt =
            'أنشئ رسالة تهنئة بمناسبة $selectedOccasion، بأسلوب لبق وودي. اسم المرسل: $senderName. اسم المستلم: $recipientName.';
    }

    try {
      final message = await OpenAIService.generateGreeting(
        prompt,
        senderName: senderName,
        recipientName: recipientName,
      );

      setState(() {
        messageController.text = message;
        isGeneratingMessage = false;
      });
    } catch (e) {
      setState(() => isGeneratingMessage = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ في توليد الرسالة')),
      );
    }
  }

  Future<void> shareMessage() async {
    if (messageController.text.trim().isEmpty) return;

    final message = messageController.text;
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.green),
              title: const Text('واتساب'),
              onTap: () {
                Navigator.pop(context);
                _showContactPickerForWhatsApp(message);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('مشاركة عامة'),
              onTap: () {
                Navigator.pop(context);
                Share.share(
                  message,
                  subject: 'رسالة تهنئة من تطبيق تهانينا',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showContactPickerForWhatsApp(String message) {
    if (filteredContacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا توجد جهات اتصال متاحة')),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemCount: filteredContacts.length,
        itemBuilder: (context, index) {
          final contact = filteredContacts[index];
          final name = "${contact.name.first} ${contact.name.last}".trim();
          final phone = contact.phones.isNotEmpty ? contact.phones.first.number : '';
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal,
              child: Text(name.isNotEmpty ? name[0] : '?', style: const TextStyle(color: Colors.white)),
            ),
            title: Text(name),
            subtitle: Text(phone.isNotEmpty ? phone : 'بدون رقم'),
            onTap: () {
              Navigator.pop(context);
              if (phone.isNotEmpty) {
                _launchWhatsApp(phone, message);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('لا يوجد رقم هاتف لهذا الشخص')),
                );
              }
            },
          );
        },
      ),
    );
  }

  Future<void> _launchWhatsApp(String phoneNumber, String message) async {
    // تنظيف الرقم ليكون دولي (بدون + أو 00)
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanNumber.startsWith('00')) {
      cleanNumber = cleanNumber.substring(2);
    } else if (cleanNumber.startsWith('0')) {
      // مثال للسعودية: 05xxxxxxx => 9665xxxxxxx
      cleanNumber = '966' + cleanNumber.substring(1);
    }
    final encodedMessage = Uri.encodeComponent(message);
    final url = 'https://wa.me/$cleanNumber?text=$encodedMessage';
    
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch WhatsApp';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح واتساب')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool allSelected = selectedContactIds.length == contacts.length && contacts.isNotEmpty;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إرسال تهنئة"),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: loadContacts,
              tooltip: 'تحديث جهات الاتصال',
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // نوع المناسبة
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "نوع المناسبة",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        hint: const Text("اختر نوع المناسبة"),
                        items: occasionsByCategory.keys.map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        )).toList(),
                        onChanged: (val) => setState(() {
                          selectedCategory = val;
                          selectedOccasion = null;
                        }),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // المناسبة (Dropdown)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "المناسبة",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedOccasion,
                        hint: const Text("اختر المناسبة"),
                        items: (selectedCategory != null
                                ? (occasionsByCategory[selectedCategory!] ?? [])
                                : [])
                            .map<DropdownMenuItem<String>>((e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (val) => setState(() => selectedOccasion = val),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // نوع الرسالة
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "نوع الرسالة",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedMessageType,
                        hint: const Text("اختر نوع الرسالة"),
                        items: messageTypes.map((type) => DropdownMenuItem(
                          value: type['name'],
                          child: Row(
                            children: [
                              Text(type['emoji']!),
                              const SizedBox(width: 8),
                              Text(type['name']!),
                            ],
                          ),
                        )).toList(),
                        onChanged: (val) => setState(() => selectedMessageType = val),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // جهات الاتصال
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "جهات الاتصال",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'ابحث عن جهة اتصال...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: filterContacts,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "عدد المحددين: ${selectedContactIds.length}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextButton.icon(
                            onPressed: toggleSelectAll,
                            icon: Icon(allSelected ? Icons.deselect : Icons.select_all),
                            label: Text(allSelected ? "إلغاء الكل" : "تحديد الكل"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (isLoadingContacts)
                        Column(
                          children: const [
                            CircularProgressIndicator(),
                            SizedBox(height: 12),
                            Text(
                              "قد تتأخر جلب البيانات بسبب كثرة جهات الاتصال .. انتظر",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        )
                      else if (filteredContacts.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text("لا توجد جهات اتصال متاحة"),
                          ),
                        )
                      else
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemCount: filteredContacts.length,
                            itemBuilder: (context, index) {
                              final contact = filteredContacts[index];
                              final name = "${contact.name.first} ${contact.name.last}".trim();
                              return CheckboxListTile(
                                title: Text(name),
                                subtitle: contact.phones.isNotEmpty
                                    ? Text(contact.phones.first.number)
                                    : null,
                                value: selectedContactIds.contains(contact.id),
                                onChanged: (_) => toggleContact(contact.id),
                                secondary: CircleAvatar(
                                  backgroundColor: Colors.teal,
                                  child: Text(
                                    name.isNotEmpty ? name[0] : '?',
                                    style: const TextStyle(color: Colors.white),
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

              const SizedBox(height: 16),

              // حقل اسم المستلم
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: recipientNameController,
                    decoration: InputDecoration(
                      labelText: 'اسم المستلم',
                      hintText: 'أدخل اسم الشخص المستلم',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // حقل اسم المرسل
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: senderNameController,
                    decoration: InputDecoration(
                      labelText: 'اسم المرسل',
                      hintText: 'أدخل اسمك',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // توليد الرسالة
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "الرسالة",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: messageController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'سيتم توليد الرسالة هنا...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: isGeneratingMessage
                              ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                )
                              : IconButton(
                                  onPressed: generateMessage,
                                  icon: const Icon(Icons.refresh),
                                  tooltip: 'توليد رسالة جديدة',
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // أزرار الإرسال والمشاركة
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: generateMessage,
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('توليد رسالة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: shareMessage,
                      icon: const Icon(Icons.share),
                      label: const Text('مشاركة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    searchController.dispose();
    senderNameController.dispose();
    recipientNameController.dispose();
    super.dispose();
  }
}
