import 'package:shared_preferences/shared_preferences.dart';

class SharedHelper {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveOnboardingDone(bool value) async {
    await _prefs.setBool('onboardingDonee', value);
  }

  static bool getOnboardingDone() {
    return _prefs.getBool('onboardingDonee') ?? false;
  }
}
