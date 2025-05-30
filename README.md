# Tahnia App

## Description

Tahnia App is a mobile application built with Flutter for sending personalized greetings and messages. It allows users to generate greetings for various occasions, schedule messages, manage contacts, and utilize AI for message generation.

## Features

- **Send Greetings:** Create and send personalized messages for different occasions.
- **Occasion and Message Type Selection:** Easily select the type of occasion and message format.
- **Contact Management:** Manage contacts and groups for easy sending.
- **Message Scheduling:** Schedule messages to be sent at a later time.
- **Greeting Templates:** Use pre-defined templates for quick message creation.
- **Message History:** Keep track of sent and scheduled messages.
- **AI Message Generation:** (Requires API key) Generate creative greetings using AI.
- **Localization:** Supports multiple languages (Arabic and English).
- **Theme Support:** Light and dark mode support.

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

3.  For AI Message Generation, obtain API keys from [OpenAI](https://openai.com/) or [OpenRouter](https://openrouter.ai/) and update the placeholder values in `lib/core/services/openai_service.dart`.

4.  Run the app on a connected device or emulator:

    ```bash
    flutter run
    ```

## Improvements and Fixes

Based on recent development and debugging sessions, the following improvements and fixes have been implemented:

- **NDK Configuration:** Resolved NDK related build failures by removing explicit NDK version specifications in Gradle files to allow Android Studio to manage the NDK.
- **RenderFlex Overflow:** Fixed UI overflow issues in dropdown menus (`GreetingTypeSelector`, `OccasionSelector`) by using `Expanded`/`Flexible` widgets and setting `isExpanded`.
- **TextEditingController Disposal:** Ensured proper disposal of `TextEditingController` instances to prevent errors.
- **API Authentication Handling:** Improved handling of API authentication errors for AI message generation and implemented a fallback mechanism when API keys are missing or invalid. **Note:** Valid API keys are required for this feature to work fully.
- **Localization Loading:** Adjusted the application initialization flow (`main.dart`, `AppConfig`) to ensure localization settings are loaded earlier, addressing issues where localization keys were displayed.

## Remaining Requirements / Known Issues

- **Localization Display:** While the localization setup has been reviewed and adjusted, there is an ongoing issue where localization keys might still appear on some screens (specifically noted on the Send Greeting screen). Further debugging is required to understand why the correct locale context might not be propagated or used in certain widgets.
- **API Keys:** The AI message generation feature requires valid API keys to be added to `lib/core/services/openai_service.dart`.

## Contributing

[Add contributing guidelines here if applicable]

## License

[Add license information here if applicable]
