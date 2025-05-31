import 'package:flutter/material.dart';
// تم تعليق هذا الاستيراد تلقائياً: import 'package:tahania_app/services/official_message_service.dart';
import 'package:tahania_app/config/theme/app_theme.dart';

class OfficialMessagesScreen extends StatefulWidget {
  const OfficialMessagesScreen({Key? key}) : super(key: key);

  @override
  State<OfficialMessagesScreen> createState() => _OfficialMessagesScreenState();
}

class _OfficialMessagesScreenState extends State<OfficialMessagesScreen> {
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//   MessageCategory? _selectedCategory;
  String _searchQuery = '';
  bool _showUrgentOnly = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final messages = _getFilteredMessages();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الرسائل التوعوية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MessageSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط الفئات
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//               itemCount: OfficialMessageService.getCategories().length,
              itemBuilder: (context, index) {
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//                 final category = OfficialMessageService.getCategories()[index];
                final isSelected = _selectedCategory == category['type'];
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: InkWell(
                    onTap: () {
                      setState(() {
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//                         _selectedCategory = isSelected ? null : category['type'] as MessageCategory;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? theme.primaryColor : theme.cardColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            category['icon'] as IconData,
                            color: isSelected ? Colors.white : theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          category['name'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isSelected ? theme.primaryColor : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // فلتر الرسائل العاجلة
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text('عرض الرسائل العاجلة فقط'),
                Switch(
                  value: _showUrgentOnly,
                  onChanged: (value) {
                    setState(() {
                      _showUrgentOnly = value;
                    });
                  },
                ),
              ],
            ),
          ),

          // قائمة الرسائل
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Text(
                      'لا توجد رسائل',
                      style: theme.textTheme.titleLarge,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (message.imageUrl != null)
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                                child: Image.asset(
                                  message.imageUrl!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      if (message.isUrgent)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'عاجل',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          message.title,
                                          style: theme.textTheme.titleLarge,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    message.content,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        message.source,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                      Text(
                                        _formatDate(message.publishDate),
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  if (message.tags.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      children: message.tags.map((tag) {
                                        return Chip(
                                          label: Text(tag),
                                          backgroundColor: theme.primaryColor.withOpacity(0.1),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//   List<OfficialMessage> _getFilteredMessages() {
    var messages = _selectedCategory != null
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//         ? OfficialMessageService.getMessagesByCategory(_selectedCategory!)
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//         : OfficialMessageService.getAllMessages();

    if (_showUrgentOnly) {
      messages = messages.where((message) => message.isUrgent).toList();
    }

    if (_searchQuery.isNotEmpty) {
      messages = messages.where((message) {
        return message.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            message.content.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            message.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
      }).toList();
    }

    return messages;
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }
}

class MessageSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//     final messages = OfficialMessageService.searchMessages(query);
    final theme = Theme.of(context);

    if (messages.isEmpty) {
      return Center(
        child: Text(
          'لا توجد نتائج',
          style: theme.textTheme.titleLarge,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            title: Text(message.title),
            subtitle: Text(
              message.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: message.isUrgent
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'عاجل',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  )
                : null,
            onTap: () {
              // عرض تفاصيل الرسالة
            },
          ),
        );
      },
    );
  }
} 