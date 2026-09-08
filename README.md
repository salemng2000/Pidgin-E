# Pidgin Translator — Pidgin Everywhere — v1.9.0

Android Studio project for the Pidgin Everywhere translator.

## Android Studio
Open this folder in Android Studio. The project uses:
- Android Gradle Plugin 8.7.3
- Kotlin 2.1.0
- Gradle 8.9
- compileSdk/targetSdk 35
- minSdk 26

The project includes `gradlew`, `gradlew.bat`, and `gradle/wrapper/gradle-wrapper.properties` so it can build through the Gradle wrapper. The first wrapper build may download Gradle 8.9 if it is not already installed.

## Build
- Android Studio: Sync Project with Gradle Files, then Build > Make Project.
- Terminal (macOS/Linux): `./gradlew assembleDebug`
- Windows: `gradlew.bat assembleDebug`

APK output: `app/build/outputs/apk/debug/app-debug.apk`


## v1.9.0 Central API integration

This version keeps the Phase 1.8 screen/accessibility/OCR features and changes the
translation layer to use the Pidgin Central API by default:

`https://translate.pidginbible.com/wp-json/pidgin/v1/translate`

### Translation request

The Android client sends JSON containing:
- `text`
- `target_language`: `Nigerian Pidgin`

### Response handling

The client accepts the common response fields:
- `translation`
- `translated_text`
- `result`
- `data` (including a nested object)

It also reports useful network/API errors instead of exposing a generic HTTP 500.

### Configuration

The Central API endpoint is pre-filled automatically. The endpoint field is kept
as an advanced setting for testing compatible servers. An API key can be supplied
only when the Central API installation requires one.

### Important

This app is an overlay translator. It does not modify the source app's own UI;
it reads accessible/OCR text and displays the Pidgin result over the current screen.
