@echo off
echo Tahnia App Build Helper
echo ======================

if "%1"=="clean" goto clean_build
if "%1"=="fix" goto fix_issues
if "%1"=="analyze" goto run_analysis
goto usage

:clean_build
echo Cleaning project...
flutter clean
echo Getting dependencies...
flutter pub get
echo Running code generation...
flutter packages pub run build_runner build --delete-conflicting-outputs
echo Building APK...
flutter build apk --release
goto end

:fix_issues
echo Fixing common build issues...

REM Stop any running Gradle daemons
echo Stopping Gradle daemons...
cd android
gradlew.bat --stop
cd ..

REM Clear Flutter cache
echo Clearing Flutter cache...
flutter clean

REM Clear Gradle cache
echo Clearing Gradle cache...
rmdir /s /q "%USERPROFILE%\.gradle\caches"

REM Invalidate caches
echo Invalidating caches...
flutter pub cache repair

echo Issues fixed. Try building again.
goto end

:run_analysis
echo Running Dart analysis...
flutter analyze
goto end

:usage
echo Usage: %0 {clean^|fix^|analyze}
echo   clean   - Clean and rebuild the project
echo   fix     - Fix common build issues
echo   analyze - Run Dart analysis

:end