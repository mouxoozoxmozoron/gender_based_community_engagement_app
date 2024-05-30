import 'package:gbce/APIV1/Auth/login.dart';
import 'package:gbce/APIV1/Register.dart';
import 'package:gbce/main.dart';
import 'package:gbce/screens/community.dart';
import 'package:gbce/screens/events/create_event.dart';
import 'package:gbce/screens/group/create_group.dart';
import 'package:gbce/screens/group/group_deatails.dart';
import 'package:gbce/screens/group/group_list.dart';
import 'package:gbce/screens/home.dart';
import 'package:gbce/screens/more.dart';
import 'package:gbce/screens/posts.dart';
import 'package:gbce/screens/posts/create_post.dart';
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

  static String newpost = "/newpost";
  static String getnewpostRoute() => newpost;

  static String newevent = "/newevent";
  static String getneweventRoute() => newevent;
// Newevent
  static String myhome = "/myhome";
  static String getmyhomeRoute() => myhome;

  static String register = "/register";
  static String getregisterscreenRoute() => register;

  static String newgroup = "/newgroup";
  static String getnewgroupRoute() => newgroup;
  static String groupdetails = "/groupdetails";
  static String getgroupdetailsRoute() => groupdetails;

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
    // GetPage(page: () => const Community(), name: community),
    GetPage(page: () => const Grouplist(), name: community),
    GetPage(page: () => const MyHome(), name: myhome),
    GetPage(page: () => const Newpost(), name: newpost),
    GetPage(page: () => const Newevent(), name: newevent),
    GetPage(page: () => const Newgroup(), name: newgroup),
    GetPage(page: () => const Groupdetails(), name: groupdetails),
  ];
}
