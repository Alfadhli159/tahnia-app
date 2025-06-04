# Tahnia App

## Description

Tahnia App is a mobile application built with Flutter for sending personalized greetings and messages. It allows users to generate greetings for various occasions, schedule messages, manage contacts, and utilize AI for message generation.

## Features

- **💬 Smart Messages:** AI-powered message generation with custom prompts and surprise options
- **� Classified Messages:** Pre-categorized official messages with filtering and search
- **🤖 Auto Reply:** Automatic reply system for incoming congratulations
- **⏰ Scheduled Messages:** Schedule messages for future delivery with repeat options
- **📄 Templates:** Library of ready-to-use message templates with categories
- **⚙️ Settings:** Comprehensive app settings including language, theme, and notifications
- **Contact Management:** Manage contacts and groups for easy sending
- **AI Message Generation:** (Requires API key) Generate creative greetings using AI
- **Localization:** Supports multiple languages (Arabic and English)
- **Theme Support:** Light and dark mode support

## New Navigation System

The app now features an enhanced bottom navigation bar with 6 optimized tabs (from right to left):

1. **الذكية (Smart)** - 💬 AI-powered message generation
2. **المصنفة (Classified)** - 📊 Official categorized messages  
3. **الرد التلقائي (Auto Reply)** - 🤖 Automatic reply system
4. **المجدولة (Scheduled)** - ⏰ Message scheduling
5. **القالب (Template)** - 📄 Message templates library
6. **الإعدادات (Settings)** - ⚙️ App settings and preferences

## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- Flutter SDK (See [Flutter Installation Guide](https://flutter.dev/docs/get-started/install))
- Android Studio or VS Code with Flutter and Dart plugins
- Android or iOS development environment setup

### Installation

1.  Clone the repository:

    ```bash
    git clone <repository_url>
    cd tahania_app
    ```

2.  Get dependencies:

    ```bash
    flutter pub get
    ```

3.  For AI Message Generation, obtain API keys from [OpenAI](https://openai.com/) or [OpenRouter](https://openrouter.ai/) and update the placeholder values in `lib/core/services/ai_service.dart`.

4.  Run the app on a connected device or emulator:

    ```bash
    flutter run
    ```

## Recent Updates (v2.2.0)

### ✨ New Features
- **Enhanced Navigation**: Redesigned bottom navigation with 6 optimized tabs
- **Smart Message Screen**: New AI-powered message generation with custom prompts
- **Improved UI/UX**: Better visual design with shadows, gradients, and animations
- **Enhanced Performance**: Reduced tabs from 7 to 6 for better user experience

### 🎨 Design Improvements
- **Modern Navigation Bar**: Rounded corners, shadows, and smooth animations
- **Color-coded Tabs**: Each tab has its own distinctive color
- **Responsive Icons**: Larger icons for active tabs with smooth transitions
- **Better Typography**: Improved font weights and sizes for better readability

### 🔧 Technical Improvements
- **Optimized Code Structure**: Better organization of navigation components
- **Enhanced Animations**: Smooth page transitions and icon animations
- **Improved Performance**: Faster navigation and reduced memory usage
- **Better Error Handling**: Enhanced error messages and fallback mechanisms

## File Structure

```
lib/
├── app/
│   ├── main_navigation_screen.dart      # Main navigation (6 tabs)
│   ├── enhanced_navigation_screen.dart  # Enhanced version with animations
│   └── app_routes.dart
├── features/
│   ├── greetings/
│   │   └── presentation/screens/
│   │       ├── smart_message_screen.dart      # NEW: AI message generation
│   │       ├── scheduled_messages_screen.dart # Scheduled messages
│   │       └── templates_screen.dart          # Message templates
│   ├── auto_reply/
│   │   └── presentation/screens/
│   │       └── auto_reply_screen.dart         # Auto reply system
│   ├── more/screens/
│   │   └── official_messages_screen.dart      # Classified messages
│   └── settings/
│       └── presentation/screens/
│           └── settings_screen.dart           # App settings
└── core/services/
    └── ai_service.dart                        # AI service integration
```

## Navigation Guide

For detailed information about the new navigation system, see [NAVIGATION_GUIDE.md](NAVIGATION_GUIDE.md).

## Improvements and Fixes

Based on recent development and debugging sessions, the following improvements and fixes have been implemented:

- **Enhanced Navigation System:** Redesigned bottom navigation with 6 optimized tabs instead of 7
- **Smart Message Integration:** New AI-powered message generation screen with advanced features
- **Improved UI/UX:** Better visual design with modern components and animations
- **Performance Optimization:** Faster navigation and reduced memory usage
- **Better Code Organization:** Cleaner file structure and improved maintainability

## Requirements

- **Flutter SDK:** 3.0+
- **Dart:** 3.0+
- **Android:** API 21+ 
- **iOS:** 12+
- **AI API Keys:** Optional (for AI message generation)

## Contributing

[Add contributing guidelines here if applicable]

## License

[Add license information here if applicable]

---

**Last Updated:** December 2024  
**Version:** 2.2.0  
**Developer:** Tahania App Development Team
