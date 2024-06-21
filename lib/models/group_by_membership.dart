class Groupbymembership {
  Groupbymembership({
    required this.group,
  });

  final List<GroupElement> group;

  factory Groupbymembership.fromJson(Map<String, dynamic> json) {
    return Groupbymembership(
      group: json["group"] == null
          ? []
          : List<GroupElement>.from(
              json["group"]!.map((x) => GroupElement.fromJson(x))),
    );
  }
}

class GroupMemberGroup {
  GroupMemberGroup({
    required this.id,
    required this.name,
    required this.adminId,
    required this.createdAt,
    required this.updatedAt,
    required this.groupMembers,
    required this.events,
    required this.posts,
  });

  final int id;
  final String name;
  final String adminId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<GroupElement> groupMembers;
  final List<Event> events;
  final List<Post> posts;

  factory GroupMemberGroup.fromJson(Map<String, dynamic> json) {
    return GroupMemberGroup(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      adminId: json["admin_id"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      groupMembers: json["group_members"] == null
          ? []
          : List<GroupElement>.from(
              json["group_members"]!.map((x) => GroupElement.fromJson(x))),
      events: json["events"] == null
          ? []
          : List<Event>.from(json["events"]!.map((x) => Event.fromJson(x))),
      posts: json["posts"] == null
          ? []
          : List<Post>.from(json["posts"]!.map((x) => Post.fromJson(x))),
    );
  }
}

class GroupElement {
  GroupElement({
    required this.id,
    required this.userId,
    required this.groupId,
    required this.createdAt,
    required this.updatedAt,
    required this.group,
    required this.users,
  });

  final int id;
  final String userId;
  final String groupId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final GroupMemberGroup? group;
  final Users? users;

  factory GroupElement.fromJson(Map<String, dynamic> json) {
    return GroupElement(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? "",
      groupId: json["group_id"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      group: json["group"] == null
          ? null
          : GroupMemberGroup.fromJson(json["group"]),
      users: json["users"] == null ? null : Users.fromJson(json["users"]),
    );
  }
}

class Event {
  Event({
    required this.id,
    required this.userId,
    required this.groupId,
    required this.title,
    required this.description,
    required this.location,
    required this.image,
    required this.date,
    required this.time,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int userId;
  final int groupId;
  final String title;
  final String description;
  final String location;
  final String image;
  final DateTime? date;
  final String time;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? 0,
      groupId: json["group_id"] ?? 0,
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      location: json["location"] ?? "",
      image: json["image"] ?? "",
      date: DateTime.tryParse(json["date"] ?? ""),
      time: json["time"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }
}

class Post {
  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.postImage,
    required this.postType,
    required this.groupId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.comments,
    required this.likes,
    this.isDisplayingComments = false,
    this.isCommenting = false,
    this.issendingcoment = false,
  });

  final int id;
  final String title;
  final String description;
  final String postImage;
  final int postType;
  final int groupId;
  final int userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Comment> comments;
  final List<Like> likes;
  bool isDisplayingComments;
  bool isCommenting;
  bool issendingcoment;

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      postImage: json["post_image"] ?? "",
      postType: json["post_type"] ?? 0,
      groupId: json["group_id"] ?? 0,
      userId: json["user_id"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      comments: json["comments"] == null
          ? []
          : List<Comment>.from(
              json["comments"]!.map((x) => Comment.fromJson(x))),
      likes: json["likes"] == null
          ? []
          : List<Like>.from(json["likes"]!.map((x) => Like.fromJson(x))),
      isDisplayingComments: json["is_displaying_comments"] ?? false,
      isCommenting: json["is_commenting"] ?? false,
      issendingcoment: json["is_sendingcoment"] ?? false,
    );
  }
}

class Comment {
  Comment({
    required this.id,
    required this.message,
    required this.userId,
    required this.postId,
    required this.createdAt,
    required this.updatedAt,
    required this.replies,
    this.isreplying = false,
    this.isshowingreplybutton = false,
  });

  final int id;
  final String message;
  final int userId;
  final int postId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Reply> replies;
  bool isreplying;
  bool isshowingreplybutton;

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json["id"] ?? 0,
      message: json["message"] ?? "",
      userId: json["user_id"] ?? 0,
      postId: json["post_id"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      replies: json["replies"] == null
          ? []
          : List<Reply>.from(json["replies"]!.map((x) => Reply.fromJson(x))),
      isreplying: json["is_repying"] ?? false,
      isshowingreplybutton: json["is_showingreplybutton"] ?? false,

    );
  }
}

class Reply {
  Reply({
    required this.id,
    required this.message,
    required this.userId,
    required this.commentId,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String message;
  final int userId;
  final int commentId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      id: json["id"] ?? 0,
      message: json["message"] ?? "",
      userId: json["user_id"] ?? 0,
      commentId: json["comment_id"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }
}

class Like {
  Like({
    required this.id,
    required this.postId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String postId;
  final String userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json["id"] ?? 0,
      postId: json["post_id"] ?? "",
      userId: json["user_id"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }
}

class Users {
  Users({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.phone,
    required this.email,
    required this.photo,
    required this.userType,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String gender;
  final String phone;
  final String email;
  final String photo;
  final String userType;
  final dynamic emailVerifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json["id"] ?? 0,
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      gender: json["gender"] ?? "",
      phone: json["phone"] ?? "",
      email: json["email"] ?? "",
      photo: json["photo"] ?? "",
      userType: json["user_type"] ?? "",
      emailVerifiedAt: json["email_verified_at"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }
}
