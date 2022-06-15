# ZegoCallKit

## Add ZegoCallKit into your project

### Add ZegoCallKit dependencies
```bash
$ flutter pub add o_zz_rtc_call
```

### Import the library
```dart
import 'package:o_zz_rtc_call/o_zz_rtc_call.dart';
```

### Setup permission configuration

1. Android
   
Add the lines to [project/android/app/src/main/AndroidManifest.xml]
```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.CAMERA" />
```
![add_android_permission](https://user-images.githubusercontent.com/5242852/173782994-56139dd3-ce83-48ea-ae21-e01e359813ef.gif)


2. iOS
   
Add the lines to [your_project/ios/Runner/Info.plist]
```xml
<key>NSCameraUsageDescription</key>
<string>We need to use your camera to help you join the voice interaction.</string>
<key>NSMicrophoneUsageDescription</key>
<string>We need to use your mic to help you join the voice interaction.</string>
```
![add_ios_permission](https://user-images.githubusercontent.com/5242852/173783331-7e3a3849-0265-424d-84a1-05022458471a.gif)


## How to add 1v1 call functionality into my app?

### Using prebuilt UI widget

Check completed example code: https://pub.dev/packages/o_zz_rtc_call/example

1. Init ZegoCallKit on your application start up

You can get the AppID and AppSign from ZEGOCLOUD Console [My Projects] : https://console.zegocloud.com/project
```dart
ZegoCallKit().init(appID, appSign);
```
2. Enable 1v1 call component on callkit
```dart
ZegoCallKit().enableComponent([Component.k1v1Call]);
```
3. Listening button click callback if you want to handle some events of ZegoCallKit
```dart
ZegoCallKit().component1v1Call.handUpButton.onClicked = (bool stateOn) {
  // For example, you want to back to home page after call ended
  // Navigator.pushReplacementNamed(context, '/home_page');
};
```
4. Add participant view to your UI
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
...
```
5. Add call control buttons to your UI
```dart
child: Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    // You can call also Button.click in your own style button instead using the prebuilt button provided by the ZegoCallKit.
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
6. Start the call

The `callID` should be same as the other participant use to start the call. We recommend only contain letters, numbers, and '\_\'.

The `userID` should be unique and we recommend only contain letters, numbers, and '\_\'.
```dart
ZegoCallKit().component1v1Call.startVideoCall(callID, userID, userName);
```



