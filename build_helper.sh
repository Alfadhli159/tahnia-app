#!/bin/bash

echo "Tahnia App Build Helper"
echo "======================"

# Function to clean and rebuild
clean_build() {
    echo "Cleaning project..."
    flutter clean
    echo "Getting dependencies..."
    flutter pub get
    echo "Running code generation..."
    flutter packages pub run build_runner build --delete-conflicting-outputs
    echo "Building APK..."
    flutter build apk --release
}

# Function to fix common issues
fix_issues() {
    echo "Fixing common build issues..."
    
    # Stop any running Gradle daemons
    echo "Stopping Gradle daemons..."
    cd android
    ./gradlew --stop
    cd ..
    
    # Clear Flutter cache
    echo "Clearing Flutter cache..."
    flutter clean
    
    # Clear Gradle cache
    echo "Clearing Gradle cache..."
    rm -rf ~/.gradle/caches/
    
    # Invalidate caches
    echo "Invalidating caches..."
    flutter pub cache repair
    
    echo "Issues fixed. Try building again."
}

# Function to run analysis
run_analysis() {
    echo "Running Dart analysis..."
    flutter analyze
}

# Main menu
case "$1" in
    "clean")
        clean_build
        ;;
    "fix")
        fix_issues
        ;;
    "analyze")
        run_analysis
        ;;
    *)
        echo "Usage: $0 {clean|fix|analyze}"
        echo "  clean   - Clean and rebuild the project"
        echo "  fix     - Fix common build issues"
        echo "  analyze - Run Dart analysis"
        ;;
esac