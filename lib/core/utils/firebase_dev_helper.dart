import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseDevHelper {
  /// Handle Firebase initialization for development mode
  /// This is especially useful during hot restarts
  static Future<void> initializeForDevelopment() async {
    if (kDebugMode) {
      // In debug mode, handle hot restart scenarios
      try {
        // Check if any Firebase apps exist
        if (Firebase.apps.isNotEmpty) {
          // Delete all existing apps to start fresh
          for (final app in Firebase.apps) {
            await app.delete();
          }
        }
      } catch (e) {
        // Ignore errors during cleanup
        debugPrint('Firebase cleanup error (safe to ignore): $e');
      }
    }
  }

  /// Reset Firebase for testing purposes
  static Future<void> resetForTesting() async {
    try {
      // Delete all Firebase apps
      final apps = List<FirebaseApp>.from(Firebase.apps);
      for (final app in apps) {
        await app.delete();
      }
    } catch (e) {
      debugPrint('Firebase reset error: $e');
    }
  }

  /// Check Firebase status
  static void logFirebaseStatus() {
    if (kDebugMode) {
      debugPrint('Firebase apps count: ${Firebase.apps.length}');
      for (final app in Firebase.apps) {
        debugPrint('Firebase app: ${app.name} - ${app.options.projectId}');
      }
    }
  }
}
