import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

/// Widget محسن لاختيار جهات الاتصال مع دعم البحث والتحديد المتقدم
class EnhancedContactSelector extends StatefulWidget {
  final List<Contact> contacts;
  final List<Contact> selectedContacts;
  final Function(List<Contact>) onContactsChanged;
  final VoidCallback? onRefreshContacts;

  const EnhancedContactSelector({
    super.key,
    required this.contacts,
    required this.selectedContacts,
    required this.onContactsChanged,
    this.onRefreshContacts,
  });

  @override
  State<EnhancedContactSelector> createState() => _EnhancedContactSelectorState();
}

class _EnhancedContactSelectorState extends State<EnhancedContactSelector>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<Contact> _filteredContacts = [];
  bool _isExpanded = false;
  
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _filteredContacts = widget.contacts;
    _searchController.addListener(_filterContacts);
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(EnhancedContactSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.contacts != widget.contacts) {
      _filteredContacts = widget.contacts;
      _filterContacts();
    }
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredContacts = widget.contacts;
      } else {
        _filteredContacts = widget.contacts.where((contact) {
          final name = contact.displayName.toLowerCase();
          final phones = contact.phones.map((p) => p.number).join(' ').toLowerCase();
          return name.contains(query) || phones.contains(query);
        }).toList();
      }
    });
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    
    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _selectAll() {
    widget.onContactsChanged(List.from(_filteredContacts));
  }

  void _clearAll() {
    widget.onContactsChanged([]);
  }

  void _toggleContact(Contact contact) {
    final newSelection = List<Contact>.from(widget.selectedContacts);
    
    if (newSelection.any((c) => c.id == contact.id)) {
      newSelection.removeWhere((c) => c.id == contact.id);
    } else {
      newSelection.add(contact);
    }
    
    widget.onContactsChanged(newSelection);
  }

  bool _isContactSelected(Contact contact) {
    return widget.selectedContacts.any((c) => c.id == contact.id);
  }

  String _getContactPhone(Contact contact) {
    if (contact.phones.isNotEmpty) {
      return contact.phones.first.number;
    }
    return 'لا يوجد رقم';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // رأس القسم
          _buildSectionHeader(),
          
          // قائمة جهات الاتصال المحددة
          if (widget.selectedContacts.isNotEmpty) _buildSelectedContactsList(),
          
          // منطقة البحث والتحديد
          if (_isExpanded) ...[
            _buildSearchBar(),
            _buildContactsList(),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: _isExpanded ? Radius.zero : const Radius.circular(16),
          bottomRight: _isExpanded ? Radius.zero : const Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.contacts,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'جهات الاتصال',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.contacts.isEmpty
                          ? 'لا توجد جهات اتصال'
                          : 'تم تحديد ${widget.selectedContacts.length} من ${widget.contacts.length}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // أزرار الأدوات
              Row(
                children: [
                  if (widget.contacts.isNotEmpty) ...[
                    IconButton(
                      onPressed: _toggleExpanded,
                      icon: AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: const Icon(Icons.expand_more),
                      ),
                      tooltip: _isExpanded ? 'إخفاء القائمة' : 'عرض القائمة',
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                        foregroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                  if (widget.onRefreshContacts != null) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: widget.onRefreshContacts,
                      icon: const Icon(Icons.refresh),
                      tooltip: 'إعادة تحميل جهات الاتصال',
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.blue.withOpacity(0.1),
                        foregroundColor: Colors.blue,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          
          // أزرار التحديد السريع
          if (_isExpanded && widget.contacts.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectAll,
                    icon: const Icon(Icons.select_all, size: 16),
                    label: const Text('تحديد الكل'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clearAll,
                    icon: const Icon(Icons.clear_all, size: 16),
                    label: const Text('إلغاء الكل'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSelectedContactsList() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'جهات الاتصال المحددة:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.selectedContacts.map((contact) {
              return Chip(
                avatar: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    contact.displayName.isNotEmpty 
                        ? contact.displayName[0].toUpperCase()
                        : '؟',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                label: Text(
                  contact.displayName,
                  style: const TextStyle(fontSize: 12),
                ),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => _toggleContact(contact),
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                deleteIconColor: Colors.red,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: _searchController,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: 'البحث في جهات الاتصال...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      _filterContacts();
                    },
                    icon: const Icon(Icons.clear),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildContactsList() {
    return SizeTransition(
      sizeFactor: _expandAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 300),
          child: _filteredContacts.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredContacts.length,
                  itemBuilder: (context, index) {
                    final contact = _filteredContacts[index];
                    final isSelected = _isContactSelected(contact);
                    
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isSelected 
                              ? Theme.of(context).primaryColor
                              : Colors.grey[300],
                          child: Text(
                            contact.displayName.isNotEmpty 
                                ? contact.displayName[0].toUpperCase()
                                : '؟',
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          contact.displayName,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            color: isSelected ? Theme.of(context).primaryColor : null,
                          ),
                        ),
                        subtitle: Text(
                          _getContactPhone(contact),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: Checkbox(
                          value: isSelected,
                          onChanged: (_) => _toggleContact(contact),
                          activeColor: Theme.of(context).primaryColor,
                        ),
                        onTap: () => _toggleContact(contact),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isNotEmpty
                ? 'لا توجد نتائج للبحث'
                : 'لا توجد جهات اتصال',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isNotEmpty
                ? 'جرب البحث بكلمات مختلفة'
                : 'تأكد من منح الإذن للوصول إلى جهات الاتصال',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
