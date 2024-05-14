import 'package:flutter/material.dart';
import 'package:gbce/navigations/routes_configurations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'splash_screen.dart';
import 'package:get/get.dart';

Future<void> main() async {
  //IMPORTANT
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    // home: InitHome(),
    initialRoute: RoutesClass.getHomeRoute(),
    getPages: RoutesClass.routes,
  ));
}

class InitHome extends StatefulWidget {
  const InitHome({Key? key}) : super(key: key);

  @override
  State<InitHome> createState() => _InitHomeState();
}

class _InitHomeState extends State<InitHome> {
  @override
  void initState() {
    super.initState();
    _navigateToSplashScreen();
  }

  void _navigateToSplashScreen() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    // ignore: use_build_context_synchronously
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const SplashScreen(),
    //   ),
    // );
//offAllNamed
    // Get.toNamed(RoutesClass.getsplashscreenRoute());
    Get.offAllNamed(RoutesClass.getsplashscreenRoute());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
