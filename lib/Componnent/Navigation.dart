import "package:flutter/material.dart";
import "package:gbce/APIV1/Auth/logout.dart";
import "package:gbce/navigations/routes_configurations.dart";
import "package:get/get_navigation/get_navigation.dart";
import "package:get/utils.dart";

class NavBar extends StatelessWidget {
  const NavBar({super.key});

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
                image: AssetImage('assets/cargo_logo.jpg'),
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
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.event_available_outlined),
            title: const Text('Events'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.groups),
            title: const Text('Community'),
            onTap: () {},
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
