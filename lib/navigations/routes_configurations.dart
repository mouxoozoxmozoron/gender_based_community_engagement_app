import 'package:gbce/APIV1/Auth/login.dart';
import 'package:gbce/APIV1/Register.dart';
import 'package:gbce/main.dart';
import 'package:gbce/screens/community.dart';
import 'package:gbce/screens/home.dart';
import 'package:gbce/screens/more.dart';
import 'package:gbce/screens/posts.dart';
import 'package:gbce/splash_screen.dart';
import 'package:get/get.dart';

class RoutesClass {
  //home
  static String home = "/";
  static String getHomeRoute() => home;

//
//splash
  static String splashscreen = "/splash_screen";
  static String getsplashscreenRoute() => splashscreen;

  static String login = "/login";
  static String getloginRoute() => login;

  static String posts = "/posts";
  static String getpostsRoute() => posts;

  static String myhome = "/myhome";
  static String getmyhomeRoute() => myhome;

//
  static String register = "/register";
  static String getregisterscreenRoute() => register;

  static String more = "/more";
  static String getmorescreenRoute() => more;

  static String community = "/community";
  static String getcommunityRoute() => community;

  static List<GetPage> routes = [
    GetPage(page: () => const InitHome(), name: home),
    //any other routes goes here
    GetPage(page: () => const SplashScreen(), name: splashscreen),
    GetPage(page: () => const Register(), name: register),
    GetPage(page: () => const Login(), name: login),
    GetPage(page: () => const Home(), name: posts),
    GetPage(page: () => const More(), name: more),
    GetPage(page: () => const Community(), name: community),
    GetPage(page: () => const MyHome(), name: myhome),
  ];
}

