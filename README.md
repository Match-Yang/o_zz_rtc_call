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

**Working Flow**

1. Init ZegoCallKit on your application start up
2. Enable 1v1 call component on callkit
3. Listening button click callback if you want to handle some events of ZegoCallKit(Optional)
4. Add participant view to your UI
5. Add call control buttons to your UI
6. Start the call

**Sample Code**
```dart
class CallPage extends StatefulWidget {
  const CallPage({Key? key}) : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {

  @override
  void initState() {
    // Using ZegoCallKit
    // You can get the AppID and AppSign from ZEGOCLOUD Console [My Projects] : https://console.zegocloud.com/project
    ZegoCallKit().init(0000000, "Your AppSign"); /// <--- 1.Init ZegoCallKit on your application start up, we put it on CallPage's initState() just for example.
    ZegoCallKit().enableComponent([Component.k1v1Call]); /// <--- 2. Enable 1v1 call component on callkit
    // You can decide how to display the participant's view by setting some options
    // ZegoCallKit().component1v1Call.setLocalVideoConfig(config);
    // ZegoCallKit().component1v1Call.setRemoteVideoConfig(config);
    ZegoCallKit().component1v1Call.handUpButton.onClicked = (bool stateOn) { /// <--- 3. Listening button click callback if you want to handle some events of ZegoCallKit
      // Back to home page
      Navigator.pushReplacementNamed(context, '/home_page');
    };
    // You can start the call whenever you want
    // The callID should be same as the other participant use to start the call. We recommend only contain letters, numbers, and '_'.
    // The userID should be unique and we recommend only contain letters, numbers, and '_'.
    ZegoCallKit().component1v1Call.startVideoCall('123321', 'user_id', 'user_name'); /// <--- 6. Start the call

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            SizedBox.expand(
              child:
              ZegoCallKit().component1v1Call.remoteView, /// <--- 4. Add participant view to your UI
            ),
            Positioned(
                top: 100,
                right: 16,
                child: SizedBox(
                  width: 114,
                  height: 170,
                  child: ZegoCallKit().component1v1Call.localView, /// <--- 4. Add participant view to your UI
                )),
            Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // You can call Button.click in your own style button instead using the prebuilt button provided by the ZegoCallComponent.
                    ElevatedButton(onPressed: () {
                      ZegoCallKit().component1v1Call.cameraSwitchButton.click(false);
                    }, child: const Text('Camera Off')),
                    // Microphone control button
                    ZegoCallKit().component1v1Call.micSwitchButton, /// <--- 5. Add call control buttons to your UI
                    // End call button
                    ZegoCallKit().component1v1Call.handUpButton, /// <--- 5. Add call control buttons to your UI
                    // Camera control button
                    ZegoCallKit().component1v1Call.cameraSwitchButton, /// <--- 5. Add call control buttons to your UI
                  ],
                )),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
```



