import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:o_zz_rtc_call/o_zz_rtc_call.dart';

// TODO mark is for let you know you need to do something, please check all of it!
//\/\/\/\/\/\/\/\/\/\/\/\/\/ 👉👉👉👉 READ THIS IF YOU WANT TO DO MORE 👈👈👈 \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
// For how to use ZEGOCLOUD's API: https://docs.zegocloud.com/article/5560
//\/\/\/\/\/\/\/\/\/\/\/\/\ 👉👉👉👉 READ THIS IF YOU WANT TO DO MORE 👈👈👈 /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\

void main() {
  runApp(const MyApp());
}

/// MyApp class is use for example only
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/home_page',
      routes: {
        '/home_page': (context) => HomePage(),
        '/call_page': (context) => CallPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // TODO Test data <<<<<<<<<<<<<<
  // Get your AppID and AppSign from ZEGOCLOUD Console [My Projects] : https://console.zegocloud.com/project
  final int appID = ;
  final String appSign = '';

  final String callID = '222';

  /// Get the necessary arguments to join the room for start the talk or live streaming
  ///
  ///  TODO DO NOT use special characters for userID and roomID.
  ///  We recommend only contain letters, numbers, and '_'.
  Future<Map<String, String>> getJoinRoomArgs() async {
    final userID = math.Random().nextInt(10000).toString();
    return {
      'userID': userID,
      'userName': userID,
      'callID': callID,
      'appID': appID.toString(),
      'appSign': appSign,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            'ZEGOCLOUD',
            style: TextStyle(fontSize: 30, color: Colors.blue),
          ),
          ElevatedButton(
              onPressed: () async {
                Navigator.pushReplacementNamed(context, '/call_page',
                    arguments: await getJoinRoomArgs());
              },
              child: const Text('Start Call')),
        ],
      ),
    );
  }
}

/// CallPage use for display the Caller Video view and the Callee Video view
///
/// TODO You can copy the completed class to your project
class CallPage extends StatefulWidget {
  const CallPage({Key? key}) : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  @override
  void didChangeDependencies() {
    // Read data from HomePage
    RouteSettings settings = ModalRoute.of(context)!.settings;
    if (settings.arguments != null) {
      // Read arguments
      Map<String, String> obj = settings.arguments as Map<String, String>;
      var userID = obj['userID'] ?? "";
      var userName = obj['userName'] ?? "";
      var callID = obj['callID'] ?? "";
      var appID = int.parse(obj['appID'] ?? "0");
      var appSign = obj['appSign'] ?? "";


      // Using ZegoCallKit
      ZegoCallKit().enableComponent([Component.k1v1Call]);
      ZegoCallKit().init(appID, appSign);
      ZegoCallComponent1v1Call().onHandUpSwitchButtonClicked = (bool stateOn) {
        // Back to home page
        Navigator.pushReplacementNamed(context, '/home_page');
      };
      // You can start the call whenever you want
      ZegoCallComponent1v1Call().startVideoCall(callID, userID, userName);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            SizedBox.expand(
              child:
                  ZegoCallComponent1v1Call().remoteView, // Get from ZegoCallKit
            ),
            Positioned(
                top: 100,
                right: 16,
                child: SizedBox(
                  width: 114,
                  height: 170,
                  child: ZegoCallComponent1v1Call()
                      .localView, // Get from ZegoCallKit
                )),
            Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Microphone control button
                    ZegoCallComponent1v1Call().micSwitchButton,
                    // End call button
                    ZegoCallComponent1v1Call().handUpButton,
                    // Camera control button
                    ZegoCallComponent1v1Call().cameraSwitchButton,
                  ],
                )),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
