import 'package:flutter/material.dart';
import 'package:tahania_app/services/sticker_service.dart';
import 'package:tahania_app/services/favorite_stickers_service.dart';
import 'package:tahania_app/config/theme/app_theme.dart';

class StickerPicker extends StatefulWidget {
  final String occasion;
  final Function(Sticker) onStickerSelected;
  final double height;
  final double stickerSize;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;

  const StickerPicker({
    Key? key,
    required this.occasion,
    required this.onStickerSelected,
    this.height = 120,
    this.stickerSize = 48,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
  }) : super(key: key);

  @override
  State<StickerPicker> createState() => _StickerPickerState();
}

class _StickerPickerState extends State<StickerPicker> {
  Sticker? _selectedSticker;
  late List<Sticker> _stickers;
  int _currentTabIndex = 0;
  List<Sticker> _favorites = [];
  List<Sticker> _recent = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    _stickers = StickerService.getStickersForOccasion(widget.occasion);
    _favorites = await FavoriteStickersService.getFavorites();
    _recent = await FavoriteStickersService.getRecent();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didUpdateWidget(StickerPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.occasion != widget.occasion) {
      setState(() {
        _stickers = StickerService.getStickersForOccasion(widget.occasion);
        _selectedSticker = null;
        _currentTabIndex = 0;
      });
    }
  }

  List<Sticker> _getFilteredStickers() {
    switch (_currentTabIndex) {
      case 0: // جميع الاستيكرات
        return _stickers;
      case 1: // الصور
        return _stickers.where((s) => s.type == StickerType.image).toList();
      case 2: // المتحركة
        return _stickers.where((s) => s.type == StickerType.lottie).toList();
      case 3: // الأيقونات
        return _stickers.where((s) => s.type == StickerType.icon).toList();
      case 4: // المفضلة
        return _favorites;
      case 5: // الاستخدامات الأخيرة
        return _recent;
      default:
        return _stickers;
    }
  }

  Future<void> _toggleFavorite(Sticker sticker) async {
    final isFavorite = await FavoriteStickersService.isFavorite(sticker.id);
    
    if (isFavorite) {
      await FavoriteStickersService.removeFromFavorites(sticker.id);
    } else {
      await FavoriteStickersService.addToFavorites(sticker);
    }
    
    await _loadData();
  }

  Future<void> _onStickerSelected(Sticker sticker) async {
    setState(() {
      _selectedSticker = sticker;
    });
    
    await FavoriteStickersService.addToRecent(sticker);
    await _loadData();
    
    widget.onStickerSelected(sticker);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: widget.height + 48,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? (isDark ? Colors.grey[900] : Colors.grey[100]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // أزرار التصفية
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'اختر استيكر',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.emoji_emotions,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const Spacer(),
                _buildFilterButton(0, Icons.all_inclusive, 'الكل'),
                _buildFilterButton(1, Icons.image, 'صور'),
                _buildFilterButton(2, Icons.animation, 'متحركة'),
                _buildFilterButton(3, Icons.emoji_emotions, 'أيقونات'),
                _buildFilterButton(4, Icons.favorite, 'المفضلة'),
                _buildFilterButton(5, Icons.history, 'الأخيرة'),
              ],
            ),
          ),
          // قائمة الاستيكرات
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    itemCount: _getFilteredStickers().length,
                    itemBuilder: (context, index) {
                      final sticker = _getFilteredStickers()[index];
                      final isSelected = _selectedSticker?.id == sticker.id;

                      return GestureDetector(
                        onTap: () => _onStickerSelected(sticker),
                        child: Container(
                          width: widget.stickerSize + 16,
                          height: widget.stickerSize + 16,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (widget.selectedColor ?? AppTheme.primaryColor.withOpacity(0.1))
                                : (widget.unselectedColor ?? Colors.transparent),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? (widget.selectedColor ?? AppTheme.primaryColor)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: sticker.widget,
                              ),
                              if (sticker.type == StickerType.lottie)
                                Positioned(
                                  right: 4,
                                  top: 4,
                                  child: Icon(
                                    Icons.animation,
                                    size: 12,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              Positioned(
                                right: 4,
                                bottom: 4,
                                child: GestureDetector(
                                  onTap: () => _toggleFavorite(sticker),
                                  child: FutureBuilder<bool>(
                                    future: FavoriteStickersService.isFavorite(sticker.id),
                                    builder: (context, snapshot) {
                                      final isFavorite = snapshot.data ?? false;
                                      return Icon(
                                        isFavorite ? Icons.favorite : Icons.favorite_border,
                                        size: 12,
                                        color: isFavorite ? Colors.red : theme.colorScheme.onSurface,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(int index, IconData icon, String label) {
    final theme = Theme.of(context);
    final isSelected = _currentTabIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _currentTabIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? (widget.selectedColor ?? AppTheme.primaryColor.withOpacity(0.1))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? (widget.selectedColor ?? AppTheme.primaryColor)
                    : theme.colorScheme.onSurface,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? (widget.selectedColor ?? AppTheme.primaryColor)
                      : theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 