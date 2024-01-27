
 import 'package:shared_preferences/shared_preferences.dart';

  Future<SharedPreferences> sharedPref() async {
  return await SharedPreferences.getInstance();
}