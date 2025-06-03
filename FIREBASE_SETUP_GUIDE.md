# Firebase Setup Guide for Flutter

## Problem: [core/duplicate-app] Error

The `[core/duplicate-app] A Firebase App named "[DEFAULT]" already exists` error is a common issue in Flutter Firebase integration, especially during development with hot restarts.

## Root Causes

1. **Hot Restart**: Flutter's hot restart doesn't reset static variables, so Firebase remains initialized
2. **Multiple Initialization**: Calling `Firebase.initializeApp()` multiple times
3. **State Restoration**: App state restoration can trigger re-initialization
4. **Testing**: Running tests without proper cleanup

## Solutions Implemented

### 1. Firebase Service Class (`lib/services/firebase_service.dart`)

A centralized service that handles Firebase initialization safely:

```dart
// Usage in main.dart
await FirebaseService.initialize();

// Check if initialized
if (FirebaseService.isInitialized) {
  // Use Firebase services
}
```

**Features:**
- Checks if Firebase is already initialized
- Handles duplicate app errors gracefully
- Provides debugging information in development mode
- Supports re-initialization for testing

### 2. Development Helper (`lib/core/utils/firebase_dev_helper.dart`)

Handles development-specific scenarios:

```dart
// Automatically called in debug mode
await FirebaseDevHelper.initializeForDevelopment();
```

**Features:**
- Cleans up existing Firebase apps during hot restart
- Provides detailed logging for debugging
- Resets Firebase state for testing

### 3. Updated Main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase using our service
  await FirebaseService.initialize();

  runApp(const TahniaApp());
}
```

## Best Practices

### 1. Always Check Before Initializing

```dart
// ✅ Good
if (Firebase.apps.isEmpty) {
  await Firebase.initializeApp();
}

// ❌ Bad
await Firebase.initializeApp(); // Can cause duplicate app error
```

### 2. Use Try-Catch for Error Handling

```dart
try {
  await Firebase.initializeApp();
} catch (e) {
  if (e.toString().contains('duplicate-app')) {
    // Handle gracefully
  } else {
    rethrow;
  }
}
```

### 3. Centralize Firebase Logic

- Use a dedicated service class
- Handle all Firebase operations in one place
- Provide clear error messages

### 4. Development vs Production

```dart
if (kDebugMode) {
  // Development-specific Firebase handling
  await FirebaseDevHelper.initializeForDevelopment();
}
```

## Testing Considerations

### Unit Tests

```dart
setUp(() async {
  await FirebaseService.reinitialize();
});

tearDown(() async {
  await FirebaseDevHelper.resetForTesting();
});
```

### Integration Tests

```dart
setUpAll(() async {
  await FirebaseService.initialize();
});
```

## Debugging Tips

### 1. Check Firebase Apps

```dart
print('Firebase apps: ${Firebase.apps.length}');
for (final app in Firebase.apps) {
  print('App: ${app.name}');
}
```

### 2. Enable Debug Logging

Add to your `main.dart`:

```dart
if (kDebugMode) {
  FirebaseDevHelper.logFirebaseStatus();
}
```

### 3. Monitor Hot Restart

The Firebase service automatically handles hot restart scenarios in debug mode.

## Common Scenarios

### Scenario 1: First App Launch
- Firebase initializes normally
- No duplicate app error

### Scenario 2: Hot Restart
- Development helper cleans up existing apps
- Firebase re-initializes cleanly

### Scenario 3: App State Restoration
- Service checks if Firebase is already initialized
- Skips initialization if already done

### Scenario 4: Testing
- Reset helper cleans up between tests
- Fresh initialization for each test

## Error Messages and Solutions

| Error | Cause | Solution |
|-------|-------|----------|
| `[core/duplicate-app]` | Multiple initialization | Use `Firebase.apps.isEmpty` check |
| `[core/no-app]` | Firebase not initialized | Call `FirebaseService.initialize()` |
| `[core/app-deleted]` | App was deleted | Re-initialize Firebase |

## Migration from Direct Firebase.initializeApp()

### Before
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
```

### After
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(MyApp());
}
```

## Additional Resources

- [Firebase Flutter Documentation](https://firebase.flutter.dev/)
- [FlutterFire GitHub](https://github.com/firebase/flutterfire)
- [Firebase Core Package](https://pub.dev/packages/firebase_core)

## Troubleshooting

If you still encounter issues:

1. Clean your project: `flutter clean`
2. Delete `pubspec.lock` and run `flutter pub get`
3. Restart your IDE
4. Check Firebase console for project configuration
5. Verify `firebase_options.dart` is correctly generated

## Support

For additional help:
- Check the Firebase console logs
- Enable debug mode logging
- Review the Firebase service implementation
- Test with a fresh Flutter project