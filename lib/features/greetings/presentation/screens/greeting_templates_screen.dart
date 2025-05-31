import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../services/localization/app_localizations.dart';
import '../../../services/template_service.dart';

class GreetingTemplatesScreen extends StatefulWidget {
  const GreetingTemplatesScreen({super.key});

  @override
  State<GreetingTemplatesScreen> createState() => _GreetingTemplatesScreenState();
}

class _GreetingTemplatesScreenState extends State<GreetingTemplatesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;
  bool _showFavoritesOnly = false;

  final List<String> _categories = [
    'جميع الفئات',
    'دينية',
    'اجتماعية',
    'وطنية',
    'خاصة',
    'تعزية',
    'أيام عالمية',
  ];

  @override
  void initState() {
    super.initState();
    TemplateService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('templates.title')),
        actions: [
          IconButton(
            icon: Icon(_showFavoritesOnly ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              setState(() => _showFavoritesOnly = !_showFavoritesOnly);
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
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
                hintText: 'البحث في القوالب...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          
          // قائمة القوالب
          Expanded(
            child: ValueListenableBuilder<List<MessageTemplate>>(
              valueListenable: TemplateService.templatesNotifier,
              builder: (context, templates, child) {
                final filteredTemplates = _filterTemplates(templates);
                
                if (filteredTemplates.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.view_module, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          templates.isEmpty ? 'لا توجد قوالب' : 'لا توجد نتائج للبحث',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        if (templates.isEmpty) ...[
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => _showAddEditTemplateDialog(),
                            child: const Text('إضافة قالب جديد'),
                          ),
                        ],
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  itemCount: filteredTemplates.length,
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
        onPressed: () => _showAddEditTemplateDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  List<MessageTemplate> _filterTemplates(List<MessageTemplate> templates) {
    var filtered = templates;
    
    // تصفية حسب البحث
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((template) {
        return template.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               template.content.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
    
    // تصفية حسب الفئة
    if (_selectedCategory != null && _selectedCategory != 'جميع الفئات') {
      filtered = filtered.where((template) => template.category == _selectedCategory).toList();
    }
    
    // تصفية المفضلة فقط
    if (_showFavoritesOnly) {
      filtered = filtered.where((template) => template.isFavorite).toList();
    }
    
    return filtered;
  }

  Widget _buildTemplateCard(MessageTemplate template) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          template.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              template.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    template.category,
                    style: const TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ),
                if (template.isFavorite) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.favorite, size: 16, color: Colors.red),
                ],
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(value, template),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'use',
              child: ListTile(
                leading: Icon(Icons.send),
                title: Text('استخدام'),
              ),
            ),
            const PopupMenuItem(
              value: 'copy',
              child: ListTile(
                leading: Icon(Icons.copy),
                title: Text('نسخ'),
              ),
            ),
            PopupMenuItem(
              value: 'favorite',
              child: ListTile(
                leading: Icon(template.isFavorite ? Icons.favorite : Icons.favorite_border),
                title: Text(template.isFavorite ? 'إزالة من المفضلة' : 'إضافة للمفضلة'),
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
              value: 'share',
              child: ListTile(
                leading: Icon(Icons.share),
                title: Text('مشاركة'),
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
        onTap: () => _useTemplate(template),
      ),
    );
  }

  void _handleMenuAction(String action, MessageTemplate template) {
    switch (action) {
      case 'use':
        _useTemplate(template);
        break;
      case 'copy':
        _copyTemplate(template);
        break;
      case 'favorite':
        _toggleFavorite(template);
        break;
      case 'edit':
        _showAddEditTemplateDialog(template: template);
        break;
      case 'share':
        _shareTemplate(template);
        break;
      case 'delete':
        _deleteTemplate(template);
        break;
    }
  }

  void _useTemplate(MessageTemplate template) {
    Navigator.pushNamed(context, '/sendGreeting', arguments: {
      'template': template.content,
      'occasion': template.category,
    });
  }

  void _copyTemplate(MessageTemplate template) {
    Clipboard.setData(ClipboardData(text: template.content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم نسخ القالب')),
    );
  }

  void _toggleFavorite(MessageTemplate template) {
    final updatedTemplate = MessageTemplate(
      id: template.id,
      name: template.name,
      content: template.content,
      category: template.category,
      isFavorite: !template.isFavorite,
      createdAt: template.createdAt,
      updatedAt: DateTime.now(),
    );
    TemplateService.updateTemplate(updatedTemplate);
  }

  void _shareTemplate(MessageTemplate template) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم تنفيذ المشاركة قريباً')),
    );
  }

  void _deleteTemplate(MessageTemplate template) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف القالب "${template.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              TemplateService.deleteTemplate(template.id);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
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
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(labelText: 'الفئة'),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category == 'جميع الفئات' ? null : category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCategory = value);
              },
            ),
            CheckboxListTile(
              title: const Text('المفضلة فقط'),
              value: _showFavoritesOnly,
              onChanged: (value) {
                setState(() => _showFavoritesOnly = value ?? false);
              },
            ),
          ],
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

  void _showAddEditTemplateDialog({MessageTemplate? template}) {
    final nameController = TextEditingController(text: template?.name);
    final contentController = TextEditingController(text: template?.content);
    String selectedCategory = template?.category ?? _categories[1];
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
                  hintText: 'أدخل اسم القالب',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'محتوى القالب',
                  hintText: 'أدخل نص القالب',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(labelText: 'الفئة'),
                items: _categories.skip(1).map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedCategory = value!;
                },
              ),
              CheckboxListTile(
                title: const Text('إضافة للمفضلة'),
                value: isFavorite,
                onChanged: (value) {
                  isFavorite = value ?? false;
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
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty || 
                  contentController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('يرجى ملء جميع الحقول')),
                );
                return;
              }

              final newTemplate = MessageTemplate(
                id: template?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameController.text.trim(),
                content: contentController.text.trim(),
                category: selectedCategory,
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
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
