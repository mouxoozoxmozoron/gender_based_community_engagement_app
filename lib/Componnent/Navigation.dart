import "package:flutter/material.dart";
import "package:gbce/APIV1/Auth/logout.dart";
import "package:gbce/constants/widgets.dart";
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

  @override
  void initState() {
    super.initState();
    _checkUserType();
  }

  Future<void> _checkUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userTypeId = prefs.getString('usertypeId');
    print('Fetched userTypeId: $userTypeId'); // Debug print statement

    if (userTypeId != null) {
      successToast('Online user type is: $userTypeId');
    }

    if (userTypeId == '2') {
      setState(() {
        groupadminlogedin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Mussa Aron'),
            accountEmail: const Text('mussaaron20@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg',
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
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notification'),
            trailing: ClipOval(
              child: Container(
                color: Colors.red,
                height: 20,
                width: 20,
                child: const Center(
                  child: Text(
                    '10',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            onTap: () {},
          ),
          const Divider(),
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
