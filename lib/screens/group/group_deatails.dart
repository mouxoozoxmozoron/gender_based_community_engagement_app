import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api.dart';
import 'package:gbce/APIV1/api_end_points.dart';
import 'package:gbce/Componnent/Navigation.dart';
import 'package:gbce/constants/widgets.dart';
import 'package:gbce/models/group_by_membership.dart';
import 'package:gbce/navigations/routes_configurations.dart';
import 'package:gbce/screens/group/coment_post.dart';
import 'package:gbce/screens/group/event_booking.dart';
import 'package:gbce/screens/group/likeordislike.dart';
import 'package:gbce/screens/group/replie_coment.dart';
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

  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _replycontroller = TextEditingController();

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
                  // print('Post button pressed');
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
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              // successToast(event.id.toString());
                              Get.toNamed(
                                RoutesClass.getprovevefeedbackRoute(),
                                arguments: event.id.toString(),
                              );
                            },
                            child: const Text(
                              'Feedback',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20,
                              ),
                            ),
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
    } else if (ispostbuttonclicked) {
      return SingleChildScrollView(
        child: Column(
          children: group.group!.posts.map((post) {
            bool isLiked = post.likes.any((like) => like.userId == userId);

            return Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              isLiked = !isLiked;
                            });
                            print('liking the post');
                            likeOrdislikeposts(context, post.id.toString());
                          },
                          icon: const Icon(Icons.thumb_up),
                          color: isLiked ? Colors.blue : Colors.grey,
                        ),
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
                        post.issendingcoment
                            ? const CircularProgressIndicator()
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    post.isDisplayingComments =
                                        !post.isDisplayingComments;
                                    post.isCommenting = !post.isCommenting;
                                  });
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
                    if (post.isDisplayingComments)
                      ...post.comments.map((comment) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                comment.isshowingreplybutton =
                                    !comment.isshowingreplybutton;
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  color: Colors.blue,
                                  child: Text(
                                    comment.message,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      // color: Color.fromARGB(255, 78, 71, 71),
                                      // color: Colors.white
                                    ),
                                  ),
                                ),

                                if (comment.isshowingreplybutton)
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        comment.isreplying =
                                            !comment.isreplying;
                                        if (!comment.isreplying) {
                                          post.isCommenting = true;
                                        } else {
                                          post.isCommenting = false;
                                        }
                                      });
                                      // Handle reply action
                                      print('Reply to comment');
                                    },
                                    child: const Text(
                                      'Reply',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),

                                // Render replies associated with the comment
                                if (comment.replies != null)
                                  ...comment.replies.map((reply) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, top: 5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Card(
                                            color: Colors.blue,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                reply.message,
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14,
                                                  // color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),

                                // REPLYING START FROM HERE
                                if (comment.isreplying)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: _replycontroller,
                                            decoration: InputDecoration(
                                              labelText: 'Write a reply',
                                              border:
                                                  const OutlineInputBorder(),
                                              suffixIcon: IconButton(
                                                icon: const Icon(
                                                  Icons.send,
                                                  color: Colors.blue,
                                                ),
                                                onPressed: () async {
                                                  if (_replycontroller.text
                                                      .trim()
                                                      .isNotEmpty) {
                                                    setState(() {
                                                      // post.isCommenting = false;
                                                      // post.issendingcoment = true;
                                                      // post.isDisplayingComments = false;
                                                    });

                                                    // Call comentPost and handle the response
                                                    ApiResponse response =
                                                        await repliecoment(
                                                            context,
                                                            comment.id
                                                                .toString(),
                                                            _replycontroller
                                                                .text);

                                                    // Update the state based on the response
                                                    setState(() {
                                                      post.issendingcoment =
                                                          false;
                                                      if (response.error ==
                                                          null) {
                                                        setState(() {
                                                          comment.isreplying =
                                                              false;
                                                          post.isCommenting =
                                                              true;
                                                        });
                                                        // Comment was successfully posted, update the comments list
                                                        comment.replies.add(Reply(
                                                            message:
                                                                _replycontroller
                                                                    .text,
                                                            id: 1,
                                                            userId: 0,
                                                            createdAt: null,
                                                            updatedAt: null,
                                                            commentId: 0));
                                                        _replycontroller
                                                            .clear();
                                                        // successToast('Comment sent');
                                                        CustomSnackBar.show(
                                                            context,
                                                            'Replie sent',
                                                            backgroundColor:
                                                                Colors.green,
                                                            actionLabel: 'OK');
                                                      } else {
                                                        // Handle the error case
                                                        CustomSnackBar.show(
                                                            context,
                                                            response.error
                                                                .toString());
                                                      }
                                                    });
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Replie cannot be empty'),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                // REPLYING ENDS HERE
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    if (post.isCommenting)
                      if (post.isCommenting)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _commentController,
                                  decoration: InputDecoration(
                                    labelText: 'Write a comment',
                                    border: const OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      icon: const Icon(
                                        Icons.send,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () async {
                                        if (_commentController.text
                                            .trim()
                                            .isNotEmpty) {
                                          setState(() {
                                            // post.isCommenting = false;
                                            post.issendingcoment = true;
                                            // post.isDisplayingComments = false;
                                          });

                                          // Call comentPost and handle the response
                                          ApiResponse response =
                                              await comentPost(
                                                  context,
                                                  post.id.toString(),
                                                  _commentController.text);

                                          // Update the state based on the response
                                          setState(() {
                                            post.issendingcoment = false;
                                            if (response.error == null) {
                                              // Comment was successfully posted, update the comments list
                                              post.comments.add(Comment(
                                                  message:
                                                      _commentController.text,
                                                  id: 1,
                                                  postId: 0,
                                                  userId: 0,
                                                  createdAt: null,
                                                  updatedAt: null,
                                                  replies: []));
                                              _commentController
                                                  .clear(); // Clear the input field
                                              // successToast('Comment sent');
                                              CustomSnackBar.show(
                                                  context, 'Comment sent',
                                                  backgroundColor: Colors.green,
                                                  actionLabel: 'OK');
                                            } else {
                                              // Handle the error case
                                              CustomSnackBar.show(context,
                                                  response.error.toString());
                                            }
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Comment cannot be empty'),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  ],
//commenting text editing end here
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
          const Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            child: Text(
              'gbce is there for you',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                color: Colors.blueAccent,
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
