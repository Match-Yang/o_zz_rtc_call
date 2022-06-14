
abstract class ZegoCallComponentBase {
  void internalInitByCallKit();
  void internalUnInitByCallKit();
  void internalListenOn(String eventName, Function(dynamic) callback);
}