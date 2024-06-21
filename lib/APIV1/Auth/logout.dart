import 'package:gbce/navigations/routes_configurations.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

logoutPage() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  await prefs.remove('profilephotourl');
  await prefs.remove('userId');
  await prefs.remove('usertypeId');
  Get.offAllNamed(RoutesClass.getmyhomeRoute());
}
