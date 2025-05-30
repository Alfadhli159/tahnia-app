import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tahania_app/core/services/ai_service.dart';
import 'package:tahania_app/core/models/greeting.dart';
import 'package:tahania_app/core/models/message_category.dart';
import 'package:tahania_app/features/greetings/widgets/hierarchical_message_selector.dart';
import 'package:tahania_app/services/contact_utils.dart';
import 'package:tahania_app/services/settings_service.dart';

/// صفحة إرسال الرسائل المحسنة - كل شيء في صفحة واحدة مع جميع التحسينات
class ImprovedSendGreetingScreen extends StatefulWidget {
  const ImprovedSendGreetingScreen({super.key});

  @override
  State<ImprovedSendGreetingScreen> createState() => _ImprovedSendGreetingScreenState();
}

class _ImprovedSendGreetingScreenState extends State<ImprovedSendGreetingScreen> {
  // Controllers
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  
  // State variables
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  List<Contact> selectedContacts = [];
  
  String? selectedMessageType;
  String? selectedOccasion;
  String? selectedPurpose;
  String? senderName;
  String? defaultSignature;
  
  bool isLoading = false;
  bool isGenerating = false;
  bool isLoadingContacts = false;
  bool selectAll = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => isLoading = true);
    
    try {
      await Future.wait([
        _loadContacts(),
        _loadSettings(),
      ]);
    } catch (e) {
      _showError('حدث خطأ في تحميل البيانات: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadSettings() async {
    try {
      final name = await SettingsService.getSenderName();
      final signature = await SettingsService.getDefaultSignature();
      setState(() {
        senderName = name;
        defaultSignature = signature;
      });
    } catch (e) {
      print('خطأ في تحميل الإعدادات: $e');
    }
  }

  Future<void> _loadContacts() async {
    setState(() => isLoadingContacts = true);
    
    try {
      // التحقق من الإذن
      PermissionStatus permissionStatus = await Permission.contacts.status;
      
      if (permissionStatus.isDenied) {
        permissionStatus = await Permission.contacts.request();
      }
      
      if (permissionStatus.isPermanentlyDenied) {
        _showError('يرجى الذهاب إلى إعدادات التطبيق وتفعيل إذن جهات الاتصال');
        await openAppSettings();
        return;
      }
      
      if (!permissionStatus.isGranted) {
        _showError('يرجى السماح بالوصول إلى جهات الاتصال لاستخدام هذه الميزة');
        return;
      }

      // جلب جهات الاتصال
      final contactsList = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: false,
        withThumbnail: false,
        withAccounts: false,
        withGroups: false,
      );

      // فلترة جهات الاتصال الصالحة
      final validContacts = contactsList.where((contact) {
        bool hasValidPhone = contact.phones.isNotEmpty && 
                           contact.phones.any((phone) => phone.number.trim().isNotEmpty);
        bool hasValidName = contact.displayName.isNotEmpty;
        return hasValidPhone && hasValidName;
      }).toList();

      // ترتيب أبجدي
      validContacts.sort((a, b) => a.displayName.compareTo(b.displayName));

      setState(() {
        contacts = validContacts;
        filteredContacts = validContacts;
      });

      if (contacts.isEmpty) {
        _showError('لا توجد جهات اتصال صالحة');
      }
    } catch (e) {
      _showError('حدث خطأ في تحميل جهات الاتصال: $e');
    } finally {
      setState(() => isLoadingContacts = false);
    }
  }

  void _filterContacts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredContacts = contacts;
      } else {
        filteredContacts = contacts.where((contact) =>
          contact.displayName.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    });
  }

  void _toggleSelectAll() {
    setState(() {
      selectAll = !selectAll;
      if (selectAll) {
        selectedContacts = List.from(filt
