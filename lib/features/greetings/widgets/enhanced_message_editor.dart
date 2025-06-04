import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget محسن لتحرير ومعاينة الرسالة
class EnhancedMessageEditor extends StatefulWidget {
  final TextEditingController controller;
  final String? senderName;
  final String? recipientName;
  final VoidCallback? onSignatureTap;
  final bool showSignatureButton;

  const EnhancedMessageEditor({
    super.key,
    required this.controller,
    this.senderName,
    this.recipientName,
    this.onSignatureTap,
    this.showSignatureButton = true,
  });

  @override
  State<EnhancedMessageEditor> createState() => _EnhancedMessageEditorState();
}

class _EnhancedMessageEditorState extends State<EnhancedMessageEditor>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _focusNode.addListener(_onFocusChange);
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    
    if (_isFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _copyToClipboard() {
    if (widget.controller.text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: widget.controller.text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('تم نسخ الرسالة'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _clearMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد المسح'),
        content: const Text('هل تريد مسح الرسالة الحالية؟'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.controller.clear();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('مسح'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isFocused 
                      ? Theme.of(context).primaryColor
                      : Colors.grey[300]!,
                  width: _isFocused ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isFocused 
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    spreadRadius: _isFocused ? 2 : 1,
                    blurRadius: _isFocused ? 8 : 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // رأس المحرر
                  _buildEditorHeader(),
                  
                  // منطقة التحرير
                  _buildTextEditor(),
                  
                  // شريط الأدوات السفلي
                  _buildBottomToolbar(),
                ],
              ),
            ),
          ),
        );
      },
    );

  Widget _buildEditorHeader() => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.edit_note,
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تحرير الرسالة',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                if (widget.recipientName != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'إلى: ${widget.recipientName}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
          // أزرار الأدوات
          Row(
            children: [
              IconButton(
                onPressed: _copyToClipboard,
                icon: const Icon(Icons.copy, size: 20),
                tooltip: 'نسخ الرسالة',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  foregroundColor: Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _clearMessage,
                icon: const Icon(Icons.clear, size: 20),
                tooltip: 'مسح الرسالة',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.1),
                  foregroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );

  Widget _buildTextEditor() => Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            maxLines: 8,
            minLines: 6,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              fontFamily: 'Cairo',
            ),
            decoration: InputDecoration(
              hintText: 'اكتب رسالتك هنا أو استخدم زر التوليد التلقائي...',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.all(16),
            ),
            onChanged: (value) => setState(() {}),
          ),
          
          // معلومات إضافية
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'عدد الأحرف: ${widget.controller.text.length}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'عدد الكلمات: ${_getWordCount()}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );

  Widget _buildBottomToolbar() => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          // معلومات المرسل
          if (widget.senderName != null) ...[
            Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'من: ${widget.senderName}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // زر إعدادات التوقيع
          if (widget.showSignatureButton && widget.onSignatureTap != null)
            TextButton.icon(
              onPressed: widget.onSignatureTap,
              icon: const Icon(Icons.edit, size: 16),
              label: const Text(
                'إعدادات التوقيع',
                style: TextStyle(fontSize: 12),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
        ],
      ),
    );

  int _getWordCount() {
    if (widget.controller.text.isEmpty) return 0;
    return widget.controller.text.trim().split(RegExp(r'\s+')).length;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
