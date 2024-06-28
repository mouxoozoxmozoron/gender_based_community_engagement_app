import "package:flutter/material.dart";
import "package:gbce/APIV1/Auth/logout.dart";
import "package:gbce/APIV1/api_end_points.dart";
import "package:gbce/navigations/routes_configurations.dart";
import 'package:get/get.dart';
import "package:shared_preferences/shared_preferences.dart";

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool groupadminlogedin = false;
  String fullProfileImageUrl = '';
  String username = '';
  String useremail = '';

  @override
  void initState() {
    super.initState();
    _checkUserType();
  }

  Future<void> _checkUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Try to get usertypeId as a string, if it was stored as an int, convert it to a string
    String? userTypeId;
    if (prefs.containsKey('usertypeId')) {
      if (prefs.get('usertypeId') is int) {
        userTypeId = prefs.getInt('usertypeId')?.toString();
      } else {
        userTypeId = prefs.getString('usertypeId');
      }
    }

    final profileImageUrl = prefs.getString('profilephotourl');
    final uname = prefs.getString('firsname');
    final lname = prefs.getString('lastname');
    final uemail = prefs.getString('email');
    String profilePhotoUrl = prefs.getString('profilephotourl') ?? '';

    if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
      setState(() {
        fullProfileImageUrl =
            _constructFullImageUrl(serverUrlPlain, 'storage', profilePhotoUrl);
        username = "$uname $lname";
        useremail = uemail.toString();
      });
    }

    if (userTypeId == '2') {
      setState(() {
        groupadminlogedin = true;
      });
    }
  }

  String _constructFullImageUrl(
      String baseUrl, String storagePath, String photoUrl) {
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }
    if (storagePath.startsWith('/')) {
      storagePath = storagePath.substring(1);
    }
    return '$baseUrl/$storagePath/$photoUrl';
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(username),
            accountEmail: Text(useremail),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: fullProfileImageUrl.isNotEmpty
                    ? Image.network(
                        fullProfileImageUrl,
                        height: 90,
                        width: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.error,
                            size: 90,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/cargoprofile.jpeg', // Provide a default image
                        height: 90,
                        width: 90,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.purple,
              image: DecorationImage(
                image: AssetImage('assets/equalitycolored.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Center(
            child: Text(
              'Advocacy',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 30,
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Get.toNamed(RoutesClass.getpostsRoute());
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Get.toNamed(RoutesClass.getuserprofileRoute());
            },
          ),
          const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.notifications),
          //   title: const Text('Notification'),
          //   trailing: ClipOval(
          //     child: Container(
          //       color: Colors.red,
          //       height: 20,
          //       width: 20,
          //       child: const Center(
          //         child: Text(
          //           '10',
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 12,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          //   onTap: () {},
          // ),
          // const Divider(),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('New post'),
            onTap: () {
              Get.toNamed(RoutesClass.getnewpostRoute());
            },
          ),
          // if (groupadminlogedin)
          // ListTile(
          //   leading: const Icon(Icons.add),
          //   title: const Text('New event'),
          //   onTap: () {
          //     Get.toNamed(RoutesClass.getneweventRoute());
          //   },
          // ),

          ListTile(
            leading: const Icon(Icons.groups),
            title: const Text('Community'),
            onTap: () {
              Get.toNamed(RoutesClass.getcommunityRoute());
            },
          ),
          ListTile(
            leading: const Icon(Icons.groups),
            title: const Text('Create group'),
            onTap: () {
              Get.toNamed(RoutesClass.getnewgroupRoute());
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              logoutPage();
            },
          ),
        ],
      ),
    );
  }
}
