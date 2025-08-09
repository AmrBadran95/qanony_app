import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../data/static/constants.dart';

class CallService {
  CallService._internal();
  static final CallService _instance = CallService._internal();

  factory CallService() => _instance;
  bool _isInitialized = false;
  Future<void> onUserLogin(String id, String userName) async {
    if (_isInitialized) {
      return;
    }

    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: Constant.appID,
      appSign: Constant.appSign,
      userID: id,
      userName: userName,
      plugins: [ZegoUIKitSignalingPlugin()],
    );

    _isInitialized = true;
  }

  void onUserLogout() {
    if (!_isInitialized) return;

    ZegoUIKitPrebuiltCallInvitationService().uninit();
    _isInitialized = false;
  }
}
