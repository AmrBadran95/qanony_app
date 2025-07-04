import 'package:shared_preferences/shared_preferences.dart';

class SharedHelper {
  static late SharedPreferencesWithCache _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: <String>{'onboardingDonee', 'action'},
      ),
    );
  }

  static Future<void> saveOnboardingDone(bool value) async {
    await _prefs.setBool('onboardingDonee', value);
  }

  static Future<bool> getOnboardingDone() async {
    return _prefs.getBool('onboardingDonee') ?? false;
  }
}
