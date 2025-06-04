import 'package:flutter/material.dart';

class OfficialMessagesScreen extends StatefulWidget {
  const OfficialMessagesScreen({super.key});

  @override
  State<OfficialMessagesScreen> createState() => _OfficialMessagesScreenState();
}

class _OfficialMessagesScreenState extends State<OfficialMessagesScreen> {
  // التصنيفات (للتجربة فقط)
  final List<String> _categories = [
    'عام',
    'طارئ',
    'تهنئة',
    'تنبيه',
  ];

  String? _selectedCategory;
  bool _showUrgentOnly = false;
  String _searchQuery = '';

  // رسائل تجريبية (يمكن ربطها لاحقًا بقاعدة بيانات)
  final List<Map<String, dynamic>> _allMessages = [
    {
      'category': 'عام',
      'title': 'ترحيب',
      'body': 'أهلاً بك في تطبيق تهنئة!',
      'urgent': false,
    },
    {
      'category': 'تهنئة',
      'title': 'عيد مبارك',
      'body': 'نتمنى لك عيداً سعيداً.',
      'urgent': false,
    },
    {
      'category': 'طارئ',
      'title': 'تنبيه أمني',
      'body': 'يرجى مراجعة إعدادات الأمان.',
      'urgent': true,
    },
    {
      'category': 'تنبيه',
      'title': 'ملاحظة مهمة',
      'body': 'يرجى تحديث التطبيق.',
      'urgent': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredMessages {
    List<Map<String, dynamic>> messages = _allMessages;
    if (_selectedCategory != null) {
      messages = messages
          .where((msg) => msg['category'] == _selectedCategory)
          .toList();
    }
    if (_showUrgentOnly) {
      messages = messages.where((msg) => msg['urgent'] == true).toList();
    }
    if (_searchQuery.isNotEmpty) {
      messages = messages
          .where((msg) =>
              msg['title'].toString().contains(_searchQuery) ||
              msg['body'].toString().contains(_searchQuery))
          .toList();
    }
    return messages;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الرسائل الرسمية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch<String>(
                context: context,
                delegate: MessageSearchDelegate(_allMessages),
              );
              if (result != null && result.isNotEmpty) {
                setState(() {
                  _searchQuery = result;
                });
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // تصفية التصنيف
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'التصنيف',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String>(
                  child: Text('الكل'),
                ),
                ..._categories.map((category) => DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    ))
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // خيار "عاجل فقط"
            SwitchListTile(
              title: const Text('عرض الرسائل العاجلة فقط'),
              value: _showUrgentOnly,
              onChanged: (val) {
                setState(() {
                  _showUrgentOnly = val;
                });
              },
            ),
            const SizedBox(height: 16),

            // قائمة الرسائل
            Expanded(
              child: _filteredMessages.isEmpty
                  ? const Center(child: Text('لا توجد رسائل متاحة'))
                  : ListView.builder(
                      itemCount: _filteredMessages.length,
                      itemBuilder: (context, index) {
                        final msg = _filteredMessages[index];
                        return Card(
                          elevation: msg['urgent'] == true ? 4 : 2,
                          color: msg['urgent'] == true
                              ? Colors.red[50]
                              : theme.cardColor,
                          child: ListTile(
                            title: Text(
                              msg['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: msg['urgent'] == true
                                    ? Colors.red
                                    : theme.textTheme.bodyLarge?.color,
                              ),
                            ),
                            subtitle: Text(msg['body']),
                            trailing: msg['urgent'] == true
                                ? const Icon(Icons.warning, color: Colors.red)
                                : null,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// دعم البحث (يمكنك تطويره لاحقًا)
class MessageSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> messages;

  MessageSearchDelegate(this.messages);

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        )
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          close(context, '');
        },
      );

  @override
  Widget buildResults(BuildContext context) {
    final results = messages
        .where((msg) =>
            msg['title'].toString().contains(query) ||
            msg['body'].toString().contains(query))
        .toList();

    if (results.isEmpty) {
      return const Center(child: Text('لا توجد نتائج'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final msg = results[index];
        return ListTile(
          title: Text(msg['title']),
          subtitle: Text(msg['body']),
          trailing: msg['urgent'] == true
              ? const Icon(Icons.warning, color: Colors.red)
              : null,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}
