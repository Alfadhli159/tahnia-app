import 'package:flutter/material.dart';
import 'package:tahania_app/services/template_service.dart';
import 'package:uuid/uuid.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({Key? key}) : super(key: key);

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'الكل';
  bool _showFavoritesOnly = false;
  List<String> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    TemplateService.initialize();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MessageTemplate> _getFilteredTemplates() {
    var templates = TemplateService.templatesNotifier.value;

    // تطبيق البحث
    if (_searchQuery.isNotEmpty) {
      templates = TemplateService.searchTemplates(_searchQuery);
    }

    // تطبيق التصفية حسب الفئة
    if (_selectedCategory != 'الكل') {
      templates = templates.where((t) => t.category == _selectedCategory).toList();
    }

    // تطبيق التصفية حسب المفضلة
    if (_showFavoritesOnly) {
      templates = templates.where((t) => t.isFavorite).toList();
    }

    // تطبيق التصفية حسب الوسوم
    if (_selectedTags.isNotEmpty) {
      templates = templates.where((t) => 
        _selectedTags.every((tag) => t.tags.contains(tag))
      ).toList();
    }

    return templates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قوالب الرسائل'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // عرض صفحة المساعدة
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'بحث في القوالب',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // شريط الفئات
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildCategoryChip('الكل'),
                _buildCategoryChip('ترحيب'),
                _buildCategoryChip('شكر'),
                _buildCategoryChip('اعتذار'),
                _buildCategoryChip('تأكيد'),
                _buildCategoryChip('متابعة'),
                _buildCategoryChip('أخرى'),
              ],
            ),
          ),

          // قائمة القوالب
          Expanded(
            child: ValueListenableBuilder<List<MessageTemplate>>(
              valueListenable: TemplateService.templatesNotifier,
              builder: (context, templates, child) {
                final filteredTemplates = _getFilteredTemplates();

                if (filteredTemplates.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.message_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد قوالب',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ReorderableListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredTemplates.length,
                  onReorder: (oldIndex, newIndex) {
                    TemplateService.reorderTemplates(oldIndex, newIndex);
                  },
                  itemBuilder: (context, index) {
                    final template = filteredTemplates[index];
                    return _buildTemplateCard(template);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEditTemplateDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = selected ? category : 'الكل';
          });
        },
      ),
    );
  }

  Widget _buildTemplateCard(MessageTemplate template) {
    return Card(
      key: ValueKey(template.id),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          _showAddEditTemplateDialog(template: template);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      template.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      template.isFavorite ? Icons.star : Icons.star_border,
                      color: template.isFavorite ? Colors.amber : null,
                    ),
                    onPressed: () {
                      TemplateService.updateTemplate(
                        template.copyWith(isFavorite: !template.isFavorite),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      _showDeleteConfirmationDialog(template);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                template.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  Chip(
                    label: Text(template.category),
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  ),
                  ...template.tags.map((tag) => Chip(
                    label: Text(tag),
                    backgroundColor: Colors.grey[200],
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تصفية القوالب'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('المفضلة فقط'),
              value: _showFavoritesOnly,
              onChanged: (value) {
                setState(() {
                  _showFavoritesOnly = value;
                });
                Navigator.pop(context);
              },
            ),
            const Divider(),
            const Text('الوسوم'),
            Wrap(
              spacing: 8,
              children: [
                'مهم',
                'عاجل',
                'متابعة',
                'تأكيد',
                'شكر',
              ].map((tag) => FilterChip(
                label: Text(tag),
                selected: _selectedTags.contains(tag),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTags.add(tag);
                    } else {
                      _selectedTags.remove(tag);
                    }
                  });
                  Navigator.pop(context);
                },
              )).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _showFavoritesOnly = false;
                _selectedTags = [];
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

  void _showAddEditTemplateDialog({MessageTemplate? template}) {
    final nameController = TextEditingController(text: template?.name);
    final contentController = TextEditingController(text: template?.content);
    String selectedCategory = template?.category ?? 'أخرى';
    List<String> selectedTags = template?.tags ?? [];
    bool isFavorite = template?.isFavorite ?? false;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(template == null ? 'إضافة قالب جديد' : 'تعديل القالب'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم القالب',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'محتوى القالب',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'الفئة',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'ترحيب', child: Text('ترحيب')),
                  DropdownMenuItem(value: 'شكر', child: Text('شكر')),
                  DropdownMenuItem(value: 'اعتذار', child: Text('اعتذار')),
                  DropdownMenuItem(value: 'تأكيد', child: Text('تأكيد')),
                  DropdownMenuItem(value: 'متابعة', child: Text('متابعة')),
                  DropdownMenuItem(value: 'أخرى', child: Text('أخرى')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    selectedCategory = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              const Text('الوسوم'),
              Wrap(
                spacing: 8,
                children: [
                  'مهم',
                  'عاجل',
                  'متابعة',
                  'تأكيد',
                  'شكر',
                ].map((tag) => FilterChip(
                  label: Text(tag),
                  selected: selectedTags.contains(tag),
                  onSelected: (selected) {
                    if (selected) {
                      selectedTags.add(tag);
                    } else {
                      selectedTags.remove(tag);
                    }
                  },
                )).toList(),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('إضافة إلى المفضلة'),
                value: isFavorite,
                onChanged: (value) {
                  isFavorite = value;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final newTemplate = MessageTemplate(
                id: template?.id ?? const Uuid().v4(),
                name: nameController.text,
                content: contentController.text,
                category: selectedCategory,
                tags: selectedTags,
                isFavorite: isFavorite,
                createdAt: template?.createdAt ?? DateTime.now(),
                updatedAt: DateTime.now(),
              );

              if (template == null) {
                TemplateService.addTemplate(newTemplate);
              } else {
                TemplateService.updateTemplate(newTemplate);
              }

              Navigator.pop(context);
            },
            child: Text(template == null ? 'إضافة' : 'حفظ'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(MessageTemplate template) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف القالب'),
        content: const Text('هل أنت متأكد من حذف هذا القالب؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              TemplateService.deleteTemplate(template.id);
              Navigator.pop(context);
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
} 