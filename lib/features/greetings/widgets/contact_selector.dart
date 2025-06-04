import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:tahania_app/services/localization/app_localizations.dart';

class ContactSelector extends StatefulWidget {
  final List<Contact> contacts;
  final List<Contact> selectedContacts;
  final Function(List<Contact>) onContactsChanged;

  const ContactSelector({
    super.key,
    required this.contacts,
    required this.selectedContacts,
    required this.onContactsChanged,
  });

  @override
  State<ContactSelector> createState() => _ContactSelectorState();
}

class _ContactSelectorState extends State<ContactSelector> {
  final TextEditingController _searchController = TextEditingController();
  List<Contact> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    _filteredContacts = widget.contacts;
    _searchController.addListener(_filterContacts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = widget.contacts.where((contact) => contact.displayName.toLowerCase().contains(query) ||
            contact.phones.any((phone) => phone.number.contains(query))).toList();
    });
  }

  void _toggleContact(Contact contact) {
    final selectedContacts = List<Contact>.from(widget.selectedContacts);
    
    if (selectedContacts.any((c) => c.id == contact.id)) {
      selectedContacts.removeWhere((c) => c.id == contact.id);
    } else {
      selectedContacts.add(contact);
    }
    
    widget.onContactsChanged(selectedContacts);
  }

  void _toggleSelectAll() {
    if (widget.selectedContacts.length == _filteredContacts.length && _filteredContacts.isNotEmpty) {
      // إلغاء تحديد الكل
      widget.onContactsChanged([]);
    } else {
      // تحديد الكل
      widget.onContactsChanged(List<Contact>.from(_filteredContacts));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool allSelected = widget.selectedContacts.length == _filteredContacts.length && _filteredContacts.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.contacts, color: Theme.of(context).primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).translate('greetings.contacts'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // شريط البحث
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).translate('greetings.search_contacts'),
              prefixIcon: const Icon(Icons.search, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // شريط التحكم
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppLocalizations.of(context).translate('greetings.selected_count')} ${widget.selectedContacts.length}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              TextButton.icon(
                onPressed: _filteredContacts.isNotEmpty ? _toggleSelectAll : null,
                icon: Icon(
                  allSelected ? Icons.deselect : Icons.select_all,
                  size: 18,
                ),
                label: Text(
                  allSelected
                      ? AppLocalizations.of(context).translate('greetings.deselect_all')
                      : AppLocalizations.of(context).translate('greetings.select_all'),
                  style: const TextStyle(fontSize: 12),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // قائمة جهات الاتصال
          if (_filteredContacts.isEmpty)
            Container(
              height: 100,
              alignment: Alignment.center,
              child: Text(
                _searchController.text.isNotEmpty
                    ? 'لا توجد نتائج للبحث'
                    : AppLocalizations.of(context).translate('greetings.no_contacts'),
                style: TextStyle(color: Colors.grey[600]),
              ),
            )
          else
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                itemCount: _filteredContacts.length,
                itemBuilder: (context, index) {
                  final contact = _filteredContacts[index];
                  final isSelected = widget.selectedContacts.any((c) => c.id == contact.id);
                  
                  return Container(
                    decoration: BoxDecoration(
                      border: index < _filteredContacts.length - 1
                          ? Border(bottom: BorderSide(color: Colors.grey[200]!))
                          : null,
                    ),
                    child: CheckboxListTile(
                      title: Text(
                        contact.displayName,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: contact.phones.isNotEmpty
                          ? Text(
                              contact.phones.first.number,
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              overflow: TextOverflow.ellipsis,
                            )
                          : null,
                      value: isSelected,
                      onChanged: (_) => _toggleContact(contact),
                      secondary: CircleAvatar(
                        radius: 18,
                        backgroundColor: isSelected 
                            ? Theme.of(context).primaryColor 
                            : Colors.grey[400],
                        child: Text(
                          contact.displayName.isNotEmpty ? contact.displayName[0].toUpperCase() : '؟',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
