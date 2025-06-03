import 'package:flutter/material.dart';
import 'package:tahania_app/core/models/message_category.dart';

/// Widget لاختيار الرسالة بنظام التصنيف المتدرج
class HierarchicalMessageSelector extends StatefulWidget {
  final String? selectedMessageType;
  final String? selectedOccasion;
  final String? selectedPurpose;
  final Function(String?) onMessageTypeChanged;
  final Function(String?) onOccasionChanged;
  final Function(String?) onPurposeChanged;
  final VoidCallback? onGeneratePressed;
  final bool isGenerating;

  const HierarchicalMessageSelector({
    super.key,
    this.selectedMessageType,
    this.selectedOccasion,
    this.selectedPurpose,
    required this.onMessageTypeChanged,
    required this.onOccasionChanged,
    required this.onPurposeChanged,
    this.onGeneratePressed,
    this.isGenerating = false,
  });

  @override
  State<HierarchicalMessageSelector> createState() =>
      _HierarchicalMessageSelectorState();
}

class _HierarchicalMessageSelectorState
    extends State<HierarchicalMessageSelector>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  List<MessageCategory> _categories = [];
  List<String> _messageTypes = [];
  List<String> _occasions = [];
  List<String> _purposes = [];
  bool _isLoading = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // تنفيذ AutomaticKeepAliveClientMixin للحفاظ على حالة الويدجت
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    // تأخير تحميل التصنيفات لتحسين وقت البدء
    Future.microtask(() => _loadCategories());
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  Future<void> _loadCategories() async {
    try {
      await MessageCategoriesService.initialize();
      final categories = MessageCategoriesService.getAllCategories();
      setState(() {
        _categories = categories;
        _messageTypes =
            categories.map((c) => c.getLocalizedName('ar')).toList();
        _isLoading = false;
      });
      _animationController.forward();

      // تحديث القوائم المعتمدة على الاختيار الحالي
      if (widget.selectedMessageType != null) {
        await _updateOccasions(widget.selectedMessageType!);
        if (widget.selectedOccasion != null) {
          await _updatePurposes(
              widget.selectedMessageType!, widget.selectedOccasion!);
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('حدث خطأ في تحميل التصنيفات');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _updateOccasions(String messageType) async {
    // البحث عن الفئة المطابقة
    final category = _categories.firstWhere(
      (c) => c.getLocalizedName('ar') == messageType,
      orElse: () => _categories.first,
    );

    final occasions = category.subCategories
        .map((sub) => sub.getLocalizedName('ar'))
        .toList();
    setState(() {
      _occasions = occasions;
      _purposes = []; // إعادة تعيين الأغراض
    });
  }

  Future<void> _updatePurposes(String messageType, String occasion) async {
    // استخدام قائمة افتراضية للأغراض
    final purposes = [
      'تهنئة',
      'دعاء',
      'امتنان',
      'فخر',
      'إشادة',
      'تشجيع',
      'دعم'
    ];
    setState(() {
      _purposes = purposes;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Call super.build for AutomaticKeepAliveClientMixin
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // عنوان القسم
            _buildSectionHeader(),
            const SizedBox(height: 16),

            // المستوى الأول: نوع الرسالة
            _buildMessageTypeSelector(),
            const SizedBox(height: 12),

            // المستوى الثاني: تصنيف المناسبة
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: widget.selectedMessageType != null ? null : 0,
              child: widget.selectedMessageType != null
                  ? Column(
                      children: [
                        _buildOccasionSelector(),
                        const SizedBox(height: 12),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),

            // المستوى الثالث: غرض الرسالة
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: widget.selectedOccasion != null ? null : 0,
              child: widget.selectedOccasion != null
                  ? Column(
                      children: [
                        _buildPurposeSelector(),
                        const SizedBox(height: 16),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),

            // تم إزالة زر توليد الرسالة من هنا ونقله إلى قسم الرسالة
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.1),
            Theme.of(context).primaryColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اختيار وتوليد الرسالة',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'اختر نوع الرسالة والمناسبة والغرض لتوليد رسالة مناسبة',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageTypeSelector() {
    return _buildSelectorCard(
      title: '🔷 نوع الرسالة',
      subtitle: 'اختر الفئة العليا للرسالة',
      value: widget.selectedMessageType,
      items: _messageTypes,
      hint: 'اختر نوع الرسالة',
      onChanged: (value) {
        widget.onMessageTypeChanged(value);
        if (value != null) {
          _updateOccasions(value);
          widget.onOccasionChanged(null);
          widget.onPurposeChanged(null);
        }
      },
      itemBuilder: (item) => _buildMessageTypeItem(item),
      level: 1,
    );
  }

  Widget _buildOccasionSelector() {
    return _buildSelectorCard(
      title: '🔶 تصنيف المناسبة',
      subtitle: 'اختر المناسبة المحددة',
      value: widget.selectedOccasion,
      items: _occasions,
      hint: 'اختر المناسبة',
      onChanged: (value) {
        widget.onOccasionChanged(value);
        if (value != null && widget.selectedMessageType != null) {
          _updatePurposes(widget.selectedMessageType!, value);
          widget.onPurposeChanged(null);
        }
      },
      level: 2,
    );
  }

  Widget _buildPurposeSelector() {
    return _buildSelectorCard(
      title: '🟢 غرض الرسالة',
      subtitle: 'اختر الهدف من الرسالة',
      value: widget.selectedPurpose,
      items: _purposes,
      hint: 'اختر غرض الرسالة',
      onChanged: widget.onPurposeChanged,
      level: 3,
    );
  }

  Widget _buildSelectorCard({
    required String title,
    required String subtitle,
    required String? value,
    required List<String> items,
    required String hint,
    required Function(String?) onChanged,
    Widget Function(String)? itemBuilder,
    required int level,
  }) {
    final isEnabled = items.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isEnabled
              ? Theme.of(context).primaryColor.withValues(alpha: 0.3)
              : Colors.grey[300]!,
          width: isEnabled ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isEnabled
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                ),
              ),
              if (level > 1)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'المستوى $level',
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: value,
            hint: Text(
              hint,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 13,
              ),
            ),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: itemBuilder?.call(item) ??
                      Text(
                        item,
                        style: const TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
              );
            }).toList(),
            onChanged: isEnabled ? onChanged : null,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              filled: true,
              fillColor: isEnabled ? Colors.white : Colors.grey[50],
            ),
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: isEnabled ? Theme.of(context).primaryColor : Colors.grey,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageTypeItem(String messageType) {
    // استخدام أيقونة افتراضية بناءً على نوع الرسالة
    String icon = '📝'; // أيقونة افتراضية
    if (messageType.contains('دينية')) {
      icon = '🕌';
    } else if (messageType.contains('عائلية')) {
      icon = '👨‍👩‍👧‍👦';
    } else if (messageType.contains('مهنية')) {
      icon = '💼';
    } else if (messageType.contains('تعزية')) {
      icon = '🤲';
    } else if (messageType.contains('وطنية')) {
      icon = '🇸🇦';
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              messageType,
              style: const TextStyle(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
