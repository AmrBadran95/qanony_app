import 'package:shared_preferences/shared_preferences.dart';

class AppCache {
  static late SharedPreferencesWithCache appCache;

  static Future init() async {
    appCache = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {'isFirstLaunch', 'isLoggedIn', 'isLawyer', 'phoneNumber'},
      ),
    );
  }

  static Future setFirstLaucnch(bool value) async {
    await appCache.setBool('isFirstLaunch', value);
  }

  static bool get isFirstLaunch => appCache.getBool('isFirstLaunch') ?? true;

  static Future setLoggedIn(bool value) async {
    await appCache.setBool('isLoggedIn', value);
  }

  static bool get isLoggedIn => appCache.getBool('isLoggedIn') ?? false;

  static Future setIsLawyer(bool value) async {
    await appCache.setBool('isLawyer', value);
  }

  static bool get isLawyer => appCache.getBool('isLawyer') ?? false;

  static Future savePhone(String phone) async {
    await appCache.setString('phoneNumber', phone);
  }

  static String? getPhone() => appCache.getString('phoneNumber');

  static Future clearPhone() async {
    await appCache.remove('phoneNumber');
  }

  static Future reload() async {
    await appCache.reloadCache();
  }
}
