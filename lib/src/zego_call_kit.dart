import 'dart:developer';

import 'package:o_zz_rtc_call/src/zego_call_component_1v1_call.dart';
import 'package:o_zz_rtc_call/src/zego_call_component_base.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

enum Component { k1v1Call, kGroupCall }

typedef Components = List<Component>;

class ZegoCallKit {
  static final ZegoCallKit _callKit = ZegoCallKit._internal();

  ZegoCallKit._internal();

  factory ZegoCallKit() {
    return _callKit;
  }

  Components _components = [];

  void enableComponent(Components components) {
    assert(
        !(components.contains(Component.k1v1Call) &&
            components.contains(Component.kGroupCall)),
        "[ZEGO CALL KIT]: Enable component failed! Should not enable k1v1Call and kGroupCall at the same time.");
    if (components.contains(Component.k1v1Call) &&
        components.contains(Component.kGroupCall)) {
      log("[ZEGO CALL KIT]: Enable component failed! Should not enable k1v1Call and kGroupCall at the same time.");
      return;
    }
    _components = components;
  }

  void init(int appID, String appSign) {
    // 在这里初始化SDK，RTC、IM、Effect（根据实际注册插件判断哪些SDK要初始化）
    // 各插件自行监听SDK回调
    _createEngine(appID, appSign);

    // 在这里对插件的初始化顺序进行管理
    if (_components.contains(Component.k1v1Call)) {
      ZegoCallComponent1v1Call().internalInitByCallKit();
    }
  }

  void unInit() {
    // 在这里反初始化SDK，RTC、IM、Effect（根据实际注册插件判断哪些SDK要反初始化）
    // 在这里对插件的初始化顺序进行管理
    if (_components.contains(Component.k1v1Call)) {
      ZegoCallComponent1v1Call().internalUnInitByCallKit();
    }
  }

  /// Create SDK instance and setup some callbacks
  ///
  /// You need to call createEngine before call any of other methods of the SDK
  /// Read more about it: https://pub.dev/documentation/zego_express_engine/latest/zego_express_engine/ZegoExpressEngine/createEngine.html
  void _createEngine(int appID, String appSign) {
    // if your scenario is live,you can change to ZegoScenario.Live.
    // if your scenario is communication , you can change to ZegoScenario.Communication
    ZegoEngineProfile profile = ZegoEngineProfile(appID, ZegoScenario.General,
        appSign: appSign, enablePlatformView: true);

    ZegoExpressEngine.createEngineWithProfile(profile);
  }
}
