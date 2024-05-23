import 'package:flutter/material.dart';
import 'package:gbce/APIV1/requests/profile_api.dart';
import 'package:gbce/APIV1/api_end_points.dart';
import 'package:gbce/screens/user_profile.dart';
import 'package:get/get.dart';
import '/Componnent/Navigation.dart';

import '../APIV1/requests/home_api.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<dynamic> posts;

  @override
  void initState() {
    super.initState();
    fetchPosts(); // Call the fetchPosts method when the widget initializes
  }

  Future<void> fetchPosts() async {
    try {
      final fetchedPosts = await PostService.fetchPosts();
      setState(() {
        posts = fetchedPosts;
      });
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  @override
  void dispose() {
    // Cancel or dispose of any ongoing asynchronous operations
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text('Posts'),
        centerTitle: true,
        backgroundColor: Colors.grey[400],
      ),
      body: FutureBuilder(
        future: fetchPosts(),
        builder: (context, snapshot) {
          //LOADING SPINNER IS SET HERE
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          //END OF LOADING SPINNER HERE
          else if (snapshot.hasError) {
            return Center(
                child: Text('Error fetching data: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                //CONTENT START FROM HERE
                return Card(
                  color: Colors.black, // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        0.0), // Set to zero to remove rounded corners
                  ),
                  child: Column(
                    children: [
                      //USER INFORMATION

                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 0.5)), // Red bottom border
                        ),
                        child: Row(
                          children: [
                            // User's profile image
                            // Start of GestureDetector
                            GestureDetector(
                              onTap: () async {
                                try {
                                  Map<String, dynamic> userData =
                                      await getUserProfile(post['user']['id']);
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserProfileScreen(userData),
                                    ),
                                  );
                                } catch (e) {
                                  print('Error fetching user profile: $e');
                                  // Handle the error gracefully, e.g., show a snackbar or display a message to the user
                                }
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  '${serverUrlPlain}storage/${post['user']['photo']}',
                                ),
                                radius: 20.0,
                              ),
                            ),

                            // End of GestureDetector

                            const SizedBox(width: 8.0),
                            // User's name
                            Text(
                              post['user']['first_name'] +
                                  " " +
                                  post['user']['last_name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Post content section
                      Column(
                        children: [
                          ListTile(
                            title: Text(
                              post['title'],
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                            subtitle: Text(
                              post['description'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Image.network(
                            serverUrlPlain + "storage/${post['post_image']}",
                          ),
                          //DIVIDR BTN POST ANSD THE ACTION UPON
                          Divider(
                            color: Colors.white
                                .withOpacity(0.5), // Red divider line
                            height: 0.5,
                            thickness: 1.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Handle like button press
                                },
                                icon: const Icon(Icons.thumb_up),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Handle comment button press
                                },
                                icon: const Icon(Icons.comment),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
