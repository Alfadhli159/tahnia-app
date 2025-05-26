// lib/features/contacts/screens/groups_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tahania_app/features/contacts/screens/select_contacts_screen.dart';

class ContactGroup {
  final String id;
  final String name;
  final List<String> contactNames;
  final List<String> phoneNumbers;
  final DateTime createdAt;

  ContactGroup({
    required this.id,
    required this.name,
    required this.contactNames,
    required this.phoneNumbers,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contactNames': contactNames,
      'phoneNumbers': phoneNumbers,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ContactGroup.fromMap(Map<String, dynamic> map) {
    return ContactGroup(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      contactNames: List<String>.from(map['contactNames'] ?? []),
      phoneNumbers: List<String>.from(map['phoneNumbers'] ?? []),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
    );
  }
}

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  List<ContactGroup> groups = [];
  late Box groupsBox;

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    groupsBox = Hive.box('groupsBox');
    _loadGroups();
  }

  void _loadGroups() {
    final groupsData = groupsBox.values.toList();
    setState(() {
      groups = groupsData
          .map((data) => ContactGroup.fromMap(Map<String, dynamic>.from(data)))
          .toList();
    });
  }

  Future<void> _saveGroup(ContactGroup group) async {
    await groupsBox.put(group.id, group.toMap());
    _loadGroups();
  }

  Future<void> _deleteGroup(String groupId) async {
    await groupsBox.delete(groupId);
    _loadGroups();
  }

  void _showCreateGroupDialog() {
    showDialog(
      context: context,
      builder: (context) => _CreateGroupDialog(
        onGroupCreated: (group) {
          _saveGroup(group);
        },
      ),
    );
  }

  void _showGroupDetails(ContactGroup group) {
    showDialog(
      context: context,
      builder: (context) => _GroupDetailsDialog(
        group: group,
        onGroupUpdated: (updatedGroup) {
          _saveGroup(updatedGroup);
        },
        onGroupDeleted: () {
          _deleteGroup(group.id);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('مجموعات الاتصال'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: _showCreateGroupDialog,
              icon: const Icon(Icons.add),
              tooltip: 'إنشاء مجموعة جديدة',
            ),
          ],
        ),
        body: groups.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.group, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'لا توجد مجموعات',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'اضغط على + لإنشاء مجموعة جديدة',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  final group = groups[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Text(
                          group.name.isNotEmpty ? group.name[0] : 'م',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        group.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${group.phoneNumbers.length} جهة اتصال',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _showGroupDetails(group),
                            icon: const Icon(Icons.visibility),
                            tooltip: 'عرض التفاصيل',
                          ),
                          IconButton(
                            onPressed: () => _deleteGroup(group.id),
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'حذف المجموعة',
                          ),
                        ],
                      ),
                      onTap: () => _showGroupDetails(group),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showCreateGroupDialog,
          backgroundColor: Colors.teal,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

class _CreateGroupDialog extends StatefulWidget {
  final Function(ContactGroup) onGroupCreated;

  const _CreateGroupDialog({required this.onGroupCreated});

  @override
  State<_CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<_CreateGroupDialog> {
  final TextEditingController _nameController = TextEditingController();
  List<Contact> selectedContacts = [];

  void _selectContacts() {
    showDialog(
      context: context,
      builder: (_) => SelectContactsScreen(
        onContactsSelected: (contacts) {
          setState(() {
            selectedContacts = contacts;
          });
        },
      ),
    );
  }

  void _createGroup() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال اسم المجموعة')),
      );
      return;
    }

    if (selectedContacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار جهات اتصال للمجموعة')),
      );
      return;
    }

    final group = ContactGroup(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      contactNames: selectedContacts.map((c) => c.displayName).toList(),
      phoneNumbers: selectedContacts
          .where((c) => c.phones.isNotEmpty)
          .map((c) => c.phones.first.number)
          .toList(),
      createdAt: DateTime.now(),
    );

    widget.onGroupCreated(group);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text('إنشاء مجموعة جديدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'اسم المجموعة',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _selectContacts,
              icon: const Icon(Icons.contacts),
              label: Text(
                selectedContacts.isEmpty
                    ? 'اختيار جهات الاتصال'
                    : 'تم اختيار ${selectedContacts.length} جهة',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: _createGroup,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text('إنشاء', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}

class _GroupDetailsDialog extends StatelessWidget {
  final ContactGroup group;
  final Function(ContactGroup) onGroupUpdated;
  final VoidCallback onGroupDeleted;

  const _GroupDetailsDialog({
    required this.group,
    required this.onGroupUpdated,
    required this.onGroupDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Text(group.name),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'عدد جهات الاتصال: ${group.phoneNumbers.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'جهات الاتصال:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: group.contactNames.length,
                  itemBuilder: (context, index) {
                    final name = group.contactNames[index];
                    final phone = index < group.phoneNumbers.length
                        ? group.phoneNumbers[index]
                        : 'بدون رقم';
                    
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal.shade100,
                        child: Text(
                          name.isNotEmpty ? name[0] : '؟',
                          style: TextStyle(color: Colors.teal.shade700),
                        ),
                      ),
                      title: Text(name),
                      subtitle: Text(phone),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              onGroupDeleted();
              Navigator.pop(context);
            },
            child: const Text('حذف المجموعة', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
