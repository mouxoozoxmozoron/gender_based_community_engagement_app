import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api_end_points.dart';
import 'package:gbce/models/home_model.dart';

class UserProfileScreen extends StatelessWidget {
  final User user;

  const UserProfileScreen(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            child: Column(
              children: [
                // User's profile image
                AspectRatio(
                  aspectRatio: 16 / 16,
                  child: Container(
                    // color: Colors.black,
                    height: 400,
                    width: 400,
                    child: user.photo.isNotEmpty
                        ? Image.network(
                            '${serverUrlPlain}storage/${user.photo}',
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/default_profile.webp',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Divider(color: Colors.white.withOpacity(0.5), thickness: 0.5),
                // User information
                Center(
                  child: Card(
                    // color: Colors.black,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // User's name
                        ListTile(
                          title: Row(
                            children: [
                              Text(
                                '${user.firstName} ${user.lastName}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              Text(
                                'Member since: ${user.createdAt}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.verified,
                                color: Colors.green,
                                size: 20,
                              ),
                            ],
                          ),
                        ),

                        ListTile(
                          title: Row(
                            children: [
                              const Icon(
                                Icons.email,
                                color: Colors.grey,
                                size: 30,
                              ),
                              Text(
                                user.email,
                                style: const TextStyle(
                                    fontSize: 18, fontFamily: 'Poppins'),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              const Icon(
                                Icons.call,
                                color: Colors.grey,
                                size: 30,
                              ),
                              Text(
                                user.phone,
                                style: const TextStyle(
                                    fontSize: 18, fontFamily: 'Poppins'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
