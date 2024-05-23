import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api_end_points.dart';

class UserProfileScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  const UserProfileScreen(this.userData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
        title: const Text(
          'Profile',
          style: TextStyle(
            // color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User's profile image
            AspectRatio(
              aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
              child: Container(
                color: Colors.black,
                // child: Image.network(
                //   '${serverUrlPlain}storage/${userData['Photo']}',
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
            // Divider to separate the image from the user information
            Divider(color: Colors.white.withOpacity(0.5), thickness: 0.5),
            // User information
            Card(
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // User's name
                  ListTile(
                    title: Text(
                      userData['UserName'],
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  // User's email
                  ListTile(
                    title: Text(
                      userData['email'],
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  // User's phone number
                  ListTile(
                    title: Text(
                      userData['Phone'],
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  // Add more user information widgets as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
