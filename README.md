# IELTS Prep App

A Flutter application for IELTS exam preparation with Google Sign-In functionality.

## Google Sign-In Setup

To enable Google Sign-In in your app, follow these steps:

### 1. Firebase Configuration

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Register your Android and/or iOS app
3. Download and add the `google-services.json` file to `android/app/`
4. For iOS, add the `GoogleService-Info.plist` to the iOS project

### 2. Google Sign-In Configuration

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to API & Services > OAuth consent screen
3. Create an OAuth consent screen
4. Add the necessary scopes (email, profile)
5. Configure the Firebase Authentication to enable Google Sign-In method

### 3. Project Setup

Ensure you have the correct dependencies in your `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^2.27.1
  firebase_auth: ^4.17.9
  google_sign_in: ^6.2.1
  cloud_firestore: ^4.15.9
  provider: ^6.1.2
```

### 4. Android-specific Configuration

Make sure your `android/app/build.gradle` includes:

```gradle
dependencies {
    implementation platform('com.google.firebase:firebase-bom:32.7.4')
    implementation 'com.google.firebase:firebase-analytics'
    implementation 'com.google.firebase:firebase-auth'
    implementation 'com.google.android.gms:play-services-auth:20.7.0'
}

apply plugin: 'com.google.gms.google-services'
```

And your project-level `android/build.gradle` includes:

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

## Running the App

1. Install dependencies: `flutter pub get`
2. Run the app: `flutter run`

## Features

- Clean and sleek Google Sign-In
- User authentication with Firebase
- User profile data storage in Firestore
- Simple navigation between screens
