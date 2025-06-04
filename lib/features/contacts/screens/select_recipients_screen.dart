import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class Group {
  final String id;
  final String name;
  final List<Contact> contacts;

  Group({required this.id, required this.name, required this.contacts});
}

class SelectRecipientsScreen extends StatefulWidget {
  final Function(List<Contact>, String? groupId) onRecipientsSelected;
  final List<Group> groups; // قائمة المجموعات المحفوظة
  
  const SelectRecipientsScreen({
    super.key, 
    required this.onRecipientsSelected, 
    required this.groups
  });

  @override
  State<SelectRecipientsScreen> createState() => _SelectRecipientsScreenState();
}

class _SelectRecipientsScreenState extends State<SelectRecipientsScreen> {
  List<Contact> allContacts = [];
  List<Contact> filteredContacts = [];
  List<Contact> selectedContacts = [];
  String? selectedGroupId;
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    final permission = await FlutterContacts.requestPermission();
    if (!permission) return;
    final contacts = await FlutterContacts.getContacts(withProperties: true);
    setState(() {
      allContacts = contacts;
      filteredContacts = contacts;
      isLoading = false;
    });
  }

  void filter(String keyword) {
    setState(() {
      filteredContacts = allContacts.where((c) =>
        c.displayName.toLowerCase().contains(keyword.toLowerCase()) ||
        (c.phones.isNotEmpty && c.phones.first.number.contains(keyword))
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('اختر المستلمين')),
      body: Column(
        children: [
          // خانة البحث
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: filter,
              decoration: const InputDecoration(
                hintText: 'بحث في جهات الاتصال...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          // المجموعات
          if (widget.groups.isNotEmpty)
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.groups.length,
                itemBuilder: (context, idx) {
                  final group = widget.groups[idx];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
          // قائمة جهات الاتصال
          Expanded(
            child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: filteredContacts.length,
                  itemBuilder: (context, idx) {
                    final contact = filteredContacts[idx];
                    final selected = selectedContacts.contains(contact);
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          contact.displayName.isNotEmpty ? contact.displayName[0] : '?'
                        )
                      ),
                      title: Text(contact.displayName),
                      subtitle: Text(
                        contact.phones.isNotEmpty ? contact.phones.first.number : 'بدون رقم'
                      ),
                      trailing: Checkbox(
                        value: selected,
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
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
          // زر التأكيد
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: (selectedContacts.isNotEmpty || selectedGroupId != null)
                ? () {
                    widget.onRecipientsSelected(selectedContacts, selectedGroupId);
                    Navigator.pop(context);
                  }
                : null,
              child: Text(
                selectedGroupId != null 
                  ? 'تأكيد المجموعة المحددة'
                  : 'تأكيد (${selectedContacts.length} محدد)'
              ),
            ),
          ),
        ],
      ),
    );

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
