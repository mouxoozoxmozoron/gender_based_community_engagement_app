import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api_end_points.dart';
import 'package:gbce/Componnent/Navigation.dart';
import 'package:gbce/models/group_by_membership.dart';
import 'package:gbce/navigations/routes_configurations.dart';
import 'package:gbce/screens/group/event_booking.dart';
import 'package:gbce/screens/group/likeordislike.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Groupdetails extends StatefulWidget {
  const Groupdetails({super.key});

  @override
  State<Groupdetails> createState() => _GroupdetailsState();
}

class _GroupdetailsState extends State<Groupdetails> {
  final GroupElement group = Get.arguments;
  bool iseventbuttonclicked = false;
  bool isgroupadminlogedin = false;
  bool ispostbuttonclicked = false;
  bool ismembersbuttonclicked = false;
  bool isliked = false;
  int? userId;

  @override
  void initState() {
    super.initState();
    getauthuserdetails();
  }

  Future<void> getauthuserdetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId != null && group.group!.adminId == userId.toString()) {
      setState(() {
        this.userId = userId;
        isgroupadminlogedin = true;
      });
    } else {
      setState(() {
        this.userId = userId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            setState(() {
              iseventbuttonclicked = false;
              ispostbuttonclicked = false;
              ismembersbuttonclicked = false;
            });
          },
          child: Expanded(
            child: Text(
              group.group!.name,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  color: Colors.blueAccent),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  print('Event button pressed');
                  setState(() {
                    ismembersbuttonclicked = false;
                    ispostbuttonclicked = false;
                    iseventbuttonclicked = true;
                  });
                },
                child: const Text(
                  'Events',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  print('Post button pressed');

                  setState(() {
                    iseventbuttonclicked = false;
                    ismembersbuttonclicked = false;
                    ispostbuttonclicked = true;
                  });
                  print(ismembersbuttonclicked);
                },
                child: const Text(
                  'Posts',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  print('Mmebers button pressed');
                  setState(() {
                    ispostbuttonclicked = false;
                    iseventbuttonclicked = false;
                    ismembersbuttonclicked = true;
                  });
                },
                child: const Text(
                  'Members',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),

          // Expanded widget to make the remaining content scrollable
          Expanded(
            child: getContent(),
          ),
        ],
      ),
    );
  }

  Widget getContent() {
    if (ismembersbuttonclicked) {
      return SingleChildScrollView(
        child: Column(
          children: group.group!.groupMembers.map((groupElement) {
            var user = groupElement.users;
            print('im fetching group user data');
            return Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  children: [
                    CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 30,
                        backgroundImage: NetworkImage(
                            "${serverUrlPlain}storage/${user!.photo}")),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${user.firstName} ${user.lastName}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            user.email,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      Icons.verified,
                      color: Colors.green,
                      size: 20,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
    } else if (iseventbuttonclicked) {
      return SingleChildScrollView(
        child: Column(
          children: group.group!.events.map((event) {
            print('im fetching group event data');
            return Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  children: [
                    Image.network("${serverUrlPlain}storage/${event.image}"),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      event.description,
                      style:
                          const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                    ),
                    Text(
                      event.date.toString(),
                      style:
                          const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                    ),
                    Text(
                      event.time,
                      style:
                          const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                    ),
                    Text(
                      event.location,
                      style:
                          const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                    ),
                    const Divider(),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                              onPressed: () {
                                print('geting your ticket');
                                getEventticket(context, event.id.toString());
                              },
                              child: const Text(
                                'RSVP',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
    } else if (ispostbuttonclicked) {
      return SingleChildScrollView(
        child: Column(
          children: group.group!.posts.map((post) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  children: [
                    Image.network("${serverUrlPlain}storage/${post.postImage}"),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      post.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      post.description,
                      style:
                          const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),

                        IconButton(
                          onPressed: () {
                            setState(() {
                              isliked = true;
                            });
                            print('liking the post');

                            likeOrdislikeposts(context, post.id.toString());
                          },
                          icon: const Icon(Icons.thumb_up),
                          color: Colors.blue,
                          // color: isliked ? Colors.blue : Colors.grey,
                        ),
                        // userId
                        Text(
                          post.likes.length.toString(),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(
                          width: 150,
                        ),
                        IconButton(
                          onPressed: () {
                            print('reading comments');
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
              ),
            );
          }).toList(),
        ),
      );
    } else if (isgroupadminlogedin) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.toNamed(
                      RoutesClass.getaddgroupmemberRoute(),
                      arguments: group.group!.id,
                    );
                  },
                  icon: const Icon(
                    Icons.group_add,
                    size: 30,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                IconButton(
                  onPressed: () {
                    Get.toNamed(
                      RoutesClass.getnewpostRoute(),
                      arguments: group.group!.id,
                    );
                  },
                  icon: const Icon(
                    Icons.post_add_outlined,
                    size: 30,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                IconButton(
                  onPressed: () {
                    Get.toNamed(
                      RoutesClass.getneweventRoute(),
                      arguments: group.group!.id,
                    );
                  },
                  icon: const Icon(
                    Icons.event_repeat_rounded,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            child: Text(
              'Hello ${group.group!.name} admin',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                color: Colors.blueAccent,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            child: Text(
              'Manage your group from here',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                color: Colors.blueAccent,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              color: Colors.purple,
              image: DecorationImage(
                image: AssetImage('assets/equalitycolored.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            child: Text(
              'Hello ${group.group!.name} member',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                color: Colors.blueAccent,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            child: Text(
              'Advocacy equality and gender inclusion for future development',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.blueAccent,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            child: Text(
              'gbce is there for you',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 30,
                color: Colors.grey[800],
              ),
            ),
          ),
          Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              color: Colors.purple,
              image: DecorationImage(
                image: AssetImage('assets/equalitycolored.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      );
    }
  }
}
