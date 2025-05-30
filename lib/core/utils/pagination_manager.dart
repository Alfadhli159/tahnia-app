import 'dart:async';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';

class PaginationManager<T> {
  final int pageSize;
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  List<T> _items = [];
  final Future<List<T>> Function(int page, int pageSize) _fetchData;

  PaginationManager({
    required Future<List<T>> Function(int page, int pageSize) fetchData,
    this.pageSize = 20,
  }) : _fetchData = fetchData;

  List<T> get items => _items;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    _currentPage++;

    try {
      final newItems = await _fetchData(_currentPage, pageSize);
      
      if (newItems.isEmpty) {
        _hasMore = false;
      } else {
        _items.addAll(newItems);
      }
    } catch (e) {
      debugPrint('Error loading more items: $e');
      _currentPage--;
    } finally {
      _isLoading = false;
    }
  }

  Future<void> refresh() async {
    _currentPage = 0;
    _hasMore = true;
    _items.clear();
    
    await loadMore();
  }

  void clear() {
    _currentPage = 0;
    _hasMore = true;
    _items.clear();
  }

  void dispose() {
    clear();
  }
}
