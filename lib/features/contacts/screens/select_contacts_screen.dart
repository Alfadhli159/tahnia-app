import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class SelectContactsScreen extends StatefulWidget {
  final Function(List<Contact>) onContactsSelected;
  const SelectContactsScreen({super.key, required this.onContactsSelected});

  @override
  State<SelectContactsScreen> createState() => _SelectContactsScreenState();
}

class _SelectContactsScreenState extends State<SelectContactsScreen> {
  List<Contact> allContacts = [];
  List<Contact> filteredContacts = [];
  List<Contact> selectedContacts = [];
  bool isLoading = true;
  bool selectAll = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    try {
      if (!await FlutterContacts.requestPermission()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('⚠️ لم يتم منح إذن الوصول لجهات الاتصال')),
          );
        }
        return;
      }

      // Fetch contacts directly, not with compute
      final contacts = await _fetchContactsOptimized(null);
      debugPrint('Loaded contacts: ${contacts.length}');
      
      if (mounted) {
        setState(() {
          allContacts = contacts;
          filteredContacts = contacts;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading contacts: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ خطأ في تحميل جهات الاتصال')),
        );
      }
    }
  }

  // Optimized contact fetching - only get name and phone numbers
  static Future<List<Contact>> _fetchContactsOptimized(_) async {
    return await FlutterContacts.getContacts(
      withProperties: true,
      withThumbnail: true,
      withPhoto: true,
      withGroups: true,
      withAccounts: true,
    );
  }

  void filterContacts(String keyword) {
    if (keyword.isEmpty) {
      setState(() {
        filteredContacts = allContacts;
      });
      return;
    }

    setState(() {
      filteredContacts = allContacts.where((contact) {
        final name = contact.displayName.toLowerCase();
        final phone = contact.phones.isNotEmpty ? contact.phones.first.number : '';
        return name.contains(keyword.toLowerCase()) || phone.contains(keyword);
      }).toList();
    });
  }

  void toggleSelectAll(bool? value) {
    final checked = value ?? false;
    setState(() {
      selectAll = checked;
      selectedContacts = checked ? List.from(filteredContacts) : [];
    });
  }

  void toggleContactSelection(Contact contact, bool? selected) {
    setState(() {
      if (selected == true) {
        selectedContacts.add(contact);
      } else {
        selectedContacts.remove(contact);
      }
      // Update selectAll state
      selectAll = selectedContacts.length == filteredContacts.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'اختر جهات الاتصال',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Search field
                TextField(
                  controller: searchController,
                  onChanged: filterContacts,
                  decoration: InputDecoration(
                    hintText: 'بحث في جهات الاتصال...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              searchController.clear();
                              filterContacts('');
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Select all checkbox
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    border: Border.all(color: Colors.teal.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: selectAll,
                        onChanged: toggleSelectAll,
                        activeColor: Colors.teal,
                      ),
                      const Text(
                        'اختيار الكل',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Text(
                        '${selectedContacts.length} محدد',
                        style: TextStyle(
                          color: Colors.teal.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                
                // Contacts list
                Expanded(
                  child: isLoading
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: Colors.teal),
                              SizedBox(height: 16),
                              Text('جاري تحميل جهات الاتصال...'),
                            ],
                          ),
                        )
                      : filteredContacts.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.contacts, size: 64, color: Colors.grey),
                                  SizedBox(height: 16),
                                  Text('لا توجد جهات اتصال'),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredContacts.length,
                              itemBuilder: (context, index) {
                                final contact = filteredContacts[index];
                                final selected = selectedContacts.contains(contact);
                                final number = contact.phones.isNotEmpty 
                                    ? contact.phones.first.number 
                                    : 'بدون رقم';
                                
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 2),
                                  child: CheckboxListTile(
                                    value: selected,
                                    title: Text(
                                      contact.displayName.isNotEmpty 
                                          ? contact.displayName 
                                          : 'بدون اسم',
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text(
                                      number,
                                      style: TextStyle(color: Colors.grey.shade600),
                                    ),
                                    onChanged: (val) => toggleContactSelection(contact, val),
                                    controlAffinity: ListTileControlAffinity.leading,
                                    activeColor: Colors.teal,
                                    secondary: CircleAvatar(
                                      backgroundColor: Colors.teal.shade100,
                                      child: Text(
                                        contact.displayName.isNotEmpty 
                                            ? contact.displayName[0].toUpperCase()
                                            : '؟',
                                        style: TextStyle(
                                          color: Colors.teal.shade700,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
                const SizedBox(height: 16),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('إلغاء'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: selectedContacts.isEmpty
                            ? null
                            : () {
                                widget.onContactsSelected(selectedContacts);
                                Navigator.pop(context);
                              },
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: Text(
                          'تأكيد (${selectedContacts.length})',
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
