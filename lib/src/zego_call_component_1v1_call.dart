import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:o_zz_rtc_call/src/zego_call_component_base.dart';
import 'package:o_zz_rtc_call/src/zego_express_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class ParticipantViewController extends ChangeNotifier {
  bool videoEnable = false;
  String userName = '';
  Widget videoView = Container();
  Widget audioView = Container();

  void setVideoView(Widget view) {
    videoEnable = true;
    videoView = view;
    audioView = Container();
    notifyListeners();
  }

  void setAudioView(Widget view) {
    videoEnable = false;
    videoView = Container();
    audioView = view;
    notifyListeners();
  }

  void setUserName(String name) {
    userName = name;
    notifyListeners();
  }
}

class ParticipantView extends StatefulWidget {
  ParticipantView({Key? key}) : super(key: key);

  void setVideoView(Widget view) {
    controller.setVideoView(view);
  }

  void setUserName(String userName) {
    controller.setUserName(userName);
  }

  ParticipantViewController controller = ParticipantViewController();

  @override
  _ParticipantViewState createState() => _ParticipantViewState();
}

class _ParticipantViewState extends State<ParticipantView> {
  bool _videoEnable = false;
  String _userName = '';
  Widget _videoView = Container();
  Widget _audioView = Container();

  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {
        _videoEnable = widget.controller.videoEnable;
        _userName = widget.controller.userName;
        _videoView = widget.controller.videoView;
        _audioView = widget.controller.audioView;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          SizedBox.expand(
            child: _videoEnable ? _videoView : _audioView,
          ),
          Positioned(
              bottom: 10,
              left: 10,
              right: 0,
              child: Text(
                _userName,
                style: TextStyle(
                  color: Colors.blue,
                ),
              ))
        ],
      ),
    );
  }
}

enum ZegoCallOption {
  autoPlayAudio,
  autoPlayVideo,
  publishLocalAudio,
  publishLocalVideo
}

typedef ZegoCallOptions = List<ZegoCallOption>;

class ZegoCallSwitchButton extends StatefulWidget {
  ZegoCallSwitchButton(
      {Key? key,
      required this.iconOn,
      required this.iconOff,
      this.defaultStateOn = true})
      : super(key: key);
  IconData iconOn;
  IconData iconOff;
  bool defaultStateOn;
  Function(bool)? onButtonClicked;

  void setOnButtonClicked(Function(bool) callback) {
    onButtonClicked = callback;
  }

  @override
  _ZegoCallSwitchButtonState createState() => _ZegoCallSwitchButtonState();
}

class _ZegoCallSwitchButtonState extends State<ZegoCallSwitchButton> {
  bool _stateOn = false;

  @override
  void initState() {
    _stateOn = widget.defaultStateOn;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(10),
        primary: Colors.black26,
      ),
      child: Icon(
        _stateOn ? widget.iconOn : widget.iconOff,
        size: 28,
      ),
      onPressed: () {
        if (widget.onButtonClicked != null) {
          widget.onButtonClicked!(_stateOn);
        }
        setState(() {
          _stateOn = !_stateOn;
        });
      },
    );
  }
}

class ZegoCallComponent1v1Call extends ZegoCallComponentBase {
  static final ZegoCallComponent1v1Call _component1v1call =
      ZegoCallComponent1v1Call._internal();

  ZegoCallComponent1v1Call._internal();

  factory ZegoCallComponent1v1Call() {
    return _component1v1call;
  }

  final ParticipantView _localParticipantView = ParticipantView();
  final ParticipantView _remoteParticipantView = ParticipantView();
  final ZegoCallSwitchButton _micSwitchButton =
      ZegoCallSwitchButton(iconOn: Icons.mic, iconOff: Icons.mic_off);
  final ZegoCallSwitchButton _cameraSwitchButton = ZegoCallSwitchButton(
      iconOn: Icons.camera_alt, iconOff: Icons.camera_alt_outlined);
  final ZegoCallSwitchButton _handUpSwitchButton =
      ZegoCallSwitchButton(iconOn: Icons.call_end, iconOff: Icons.call_end);

  set onMicSwitchClicked(Function(bool) callback) {
    _micSwitchButton.setOnButtonClicked((bool stateOn) {
      ZegoExpressManager.shared.enableMic(stateOn);
      callback(stateOn);
    });
  }

  set onCameraSwitchClicked(Function(bool) callback) {
    _cameraSwitchButton.setOnButtonClicked((bool stateOn) {
      ZegoExpressManager.shared.enableCamera(stateOn);
      callback(stateOn);
    });
  }

  set onHandUpSwitchButtonClicked(Function(bool) callback) {
    _handUpSwitchButton.setOnButtonClicked((bool stateOn) {
      ZegoExpressManager.shared.leaveRoom();
      callback(stateOn);
    });
  }

  Future<void> startAudioCall(
      String callID, String userID, String userName) async {
    await _requestPermission();

    ZegoExpressManager.shared.joinRoom(callID, ZegoUser(userID, userID),
        [ZegoMediaOption.publishLocalAudio, ZegoMediaOption.autoPlayAudio]);

    ZegoExpressManager.shared.setupCallback();
    ZegoExpressManager.shared.onRoomUserUpdate =
        (ZegoUpdateType updateType, List<String> userIDList) {
      // if (updateType == ZegoUpdateType.Add) {
      //   for (final userID in userIDList) {
      //     if (options.contains(ZegoCallOption.autoPlayVideo)) {
      //       // For one-to-one call we just need to display the other user at the small view
      //       _remoteVideoWidget.setVideoView(
      //           ZegoExpressManager.shared.getRemoteVideoView(userID)!);
      //     }
      //   }
      // }
    };
    ZegoExpressManager.shared.onRoomUserDeviceUpdate =
        (ZegoDeviceUpdateType updateType, String userID) {
      log("Device update: $updateType, $userID");
    };
  }

  Future<void> startVideoCall(
      String callID, String userID, String userName) async {
    await _requestPermission();

    ZegoExpressManager.shared.joinRoom(callID, ZegoUser(userID, userName), [
      ZegoMediaOption.publishLocalAudio,
      ZegoMediaOption.publishLocalVideo,
      ZegoMediaOption.autoPlayAudio,
      ZegoMediaOption.autoPlayVideo
    ]);

    _localParticipantView.setUserName(userName); // TODO
    _localParticipantView
        .setVideoView(ZegoExpressManager.shared.getLocalVideoView()!);

    ZegoExpressManager.shared.setupCallback();
    ZegoExpressManager.shared.onRoomUserUpdate =
        (ZegoUpdateType updateType, List<String> userIDList) {
      if (updateType == ZegoUpdateType.Add) {
        for (final userID in userIDList) {
          // For one-to-one call we just need to display the other user at the small view
          _remoteParticipantView.setUserName(userID); // TODO
          _remoteParticipantView.setVideoView(
              ZegoExpressManager.shared.getRemoteVideoView(userID)!);
        }
      }
    };
    ZegoExpressManager.shared.onRoomUserDeviceUpdate =
        (ZegoDeviceUpdateType updateType, String userID) {
      log("[ZEGO CALL KIT]Device update: $updateType, $userID");
    };
  }

  Widget get localView {
    return _localParticipantView;
  }

  Widget get remoteView {
    return _remoteParticipantView;
  }

  Widget get micSwitchButton {
    return _micSwitchButton;
  }

  Widget get cameraSwitchButton {
    return _cameraSwitchButton;
  }

  Widget get handUpButton {
    return _handUpSwitchButton;
  }

  @override
  void internalInitByCallKit() {}

  @override
  void internalUnInitByCallKit() {
    // TODO: implement internalUnInitByCallKit
  }

  @override
  void internalListenOn(String eventName, Function(dynamic) callback) {
    // TODO: implement internalListenOn
  }

  /// Check the permission or ask for the user if not grant
  Future<bool> _requestPermission() async {
    PermissionStatus microphoneStatus = await Permission.microphone.request();
    if (microphoneStatus != PermissionStatus.granted) {
      log('[ZEGO CALL KIT]Error: Microphone permission not granted!!!');
      return false;
    }
    PermissionStatus cameraStatus = await Permission.camera.request();
    if (cameraStatus != PermissionStatus.granted) {
      log('[ZEGO CALL KIT]Error: Camera permission not granted!!!');
      return false;
    }
    return true;
  }
}
