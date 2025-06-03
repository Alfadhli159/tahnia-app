import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'error_handler.dart';

class StorageManager {
  static final StorageManager _instance = StorageManager._internal();
  factory StorageManager() => _instance;
  StorageManager._internal();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/tahnia_data.json');
  }
  Future<void> writeData(Map<String, dynamic> data) async {
    try {
      final file = await _localFile;
      final content = json.encode(data);
      await file.writeAsString(content);
    } catch (e) {
      ErrorHandler().handleError(e);
    }
  }

  Future<Map<String, dynamic>> readData() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) return {};

      final content = await file.readAsString();
      return json.decode(content) as Map<String, dynamic>;
    } catch (e) {
      ErrorHandler().handleError(e);
      return {};
    }
  }

  Future<void> clearData() async {
    try {
      final file = await _localFile;
      await file.delete();
    } catch (e) {
      ErrorHandler().handleError(e);
    }
  }

  Future<void> checkStorageSize() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) return;

      final size = await file.length();
      if (size > 50 * 1024 * 1024) { // 50MB limit
        await clearData();
      }
    } catch (e) {
      ErrorHandler().handleError(e);
    }
  }

  Future<void> backupData() async {
    try {
      final data = await readData();
      if (data.isEmpty) return;

      final backupPath = await _localPath;
      final backupFile =
          File('$backupPath/tahnia_data_backup.json');
      await backupFile.writeAsString(json.encode(data));
    } catch (e) {
      ErrorHandler().handleError(e);
    }
  }
}
