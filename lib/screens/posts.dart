import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api_end_points.dart';
import 'package:gbce/models/home_model.dart';
import 'package:gbce/screens/user_profile.dart';
import '/Componnent/Navigation.dart';

import '../APIV1/requests/home_api.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Post> posts;
  bool isPostAvailable = false;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final fetchedPosts = await PostService.fetchPosts();
      setState(() {
        posts = fetchedPosts;
        isPostAvailable = true;
      });
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black.withOpacity(0.5),
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text('Posts'),
        centerTitle: true,
        backgroundColor: Colors.grey[400],
      ),
      body: isPostAvailable
          ? ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return Card(
                  // color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Column(
                    children: [
                      // User information
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white.withOpacity(0.5),
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            // User's profile image with gesture detector
                            GestureDetector(
                              onTap: () async {
                                try {
                                  // Navigate to user profile screen with user data
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserProfileScreen(post.user!),
                                    ),
                                  );
                                } catch (e) {
                                  print('Error fetching user profile: $e');
                                  // Handle the error gracefully, e.g., show a snackbar or display a message to the user
                                }
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  '${serverUrlPlain}storage/${post.user!.photo}',
                                ),
                                radius: 20.0,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            // User's name
                            Text(
                              '${post.user!.firstName} ${post.user!.lastName}',
                              style: const TextStyle(
                                color: Colors.black,
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
                              post.title,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              post.description,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Image.network(
                            '${serverUrlPlain}storage/${post.postImage}',
                          ),
                          // Divider
                          Divider(
                            color: Colors.white.withOpacity(0.5),
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
                              Text(
                                post.likes.length.toString(),
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  color: Colors.blue,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Handle comment button press
                                },
                                icon: const Icon(Icons.comment),
                              ),
                              Text(
                                post.comments.length.toString(),
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
