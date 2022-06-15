# ZegoCallKit

## Add ZegoCallKit into your project

### Add ZegoCallKit dependencies
- Add by pub
```bash
$ flutter pub add o_zz_rtc_call
```
- Using git repository
```xml
dependencies:
  flutter:
    sdk: flutter


  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.2
  o_zz_rtc_call:
    git:
      url: https://github.com/Match-Yang/o_zz_rtc_call.git
```

### Import the library
```dart
import 'package:o_zz_rtc_call/o_zz_rtc_call.dart';
```

### Setup permission configuration

1. Android
   Add the lines to [project/android/app/src/main/AndroidManifest.xml]
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.zego_call_kit_example">
<!--    Add the lines below to your project\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/ -->
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.CAMERA" />
<!--    Add the lines above to your project/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ -->
   <application
```

2. iOS
   Add the lines to [your_project/ios/Runner/Info.plist]
```xml
<dict>
	<key>NSCameraUsageDescription</key>
	<string>We need to use your camera to help you join the voice interaction.</string>
	<key>NSMicrophoneUsageDescription</key>
	<string>We need to use your mic to help you join the voice interaction.</string>
```

## How to add 1v1 call functionality into my app?

### Using prebuilt UI widget
1. Enable 1v1 call component on callkit
```dart
ZegoCallKit().enableComponent([Component.k1v1Call]);
```
2. Listening button click callback
```dart
ZegoCallKit().component1v1Call.handUpButton.onClicked = (bool stateOn) {
  // Back to home page
  Navigator.pushReplacementNamed(context, '/home_page');
};
```
3. Add participant view to your UI
```dart
child: Stack(
          children: <Widget>[
            SizedBox.expand(
              child:
              ZegoCallKit().component1v1Call.remoteView, // Get from ZegoCallKit
            ),
            Positioned(
                top: 100,
                right: 16,
                child: SizedBox(
                  width: 114,
                  height: 170,
                  child: ZegoCallKit().component1v1Call.localView, // Get from ZegoCallKit
                )),
```
4. Add call control buttons to your UI
```dart
child: Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    // You can call Button.click in your own style button instead using the prebuilt button provided by the ZegoCallComponent.
    ElevatedButton(onPressed: () {
      ZegoCallKit().component1v1Call.cameraSwitchButton.click(false);
    }, child: const Text('Camera Off')),
    // Microphone control button
    ZegoCallKit().component1v1Call.micSwitchButton,
    // End call button
    ZegoCallKit().component1v1Call.handUpButton,
    // Camera control button
    ZegoCallKit().component1v1Call.cameraSwitchButton,
  ],
```
5. Start the call
```dart
ZegoCallKit().component1v1Call.startVideoCall(callID, userID, userName);
```

Check completed example code: https://github.com/Match-Yang/o_zz_rtc_call/blob/master/example/lib/main.dart

