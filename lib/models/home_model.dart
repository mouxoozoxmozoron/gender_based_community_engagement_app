class Homemodel {
    Homemodel({
        required this.message,
        required this.posts,
    });

    final String message;
    final List<Post> posts;

    factory Homemodel.fromJson(Map<String, dynamic> json){ 
        return Homemodel(
            message: json["message"] ?? "",
            posts: json["Posts"] == null ? [] : List<Post>.from(json["Posts"]!.map((x) => Post.fromJson(x))),
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
        required this.user,
        required this.comments,
        required this.likes,
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
    final User? user;
    final List<Comment> comments;
    final List<Like> likes;

    factory Post.fromJson(Map<String, dynamic> json){ 
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
            user: json["user"] == null ? null : User.fromJson(json["user"]),
            comments: json["comments"] == null ? [] : List<Comment>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
            likes: json["likes"] == null ? [] : List<Like>.from(json["likes"]!.map((x) => Like.fromJson(x))),
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
    });

    final int id;
    final String message;
    final int userId;
    final int postId;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final List<dynamic> replies;

    factory Comment.fromJson(Map<String, dynamic> json){ 
        return Comment(
            id: json["id"] ?? 0,
            message: json["message"] ?? "",
            userId: json["user_id"] ?? 0,
            postId: json["post_id"] ?? 0,
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
            replies: json["replies"] == null ? [] : List<dynamic>.from(json["replies"]!.map((x) => x)),
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

    factory Like.fromJson(Map<String, dynamic> json){ 
        return Like(
            id: json["id"] ?? 0,
            postId: json["post_id"] ?? "",
            userId: json["user_id"] ?? "",
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
        );
    }

}

class User {
    User({
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
    final UserType? userType;
    final dynamic emailVerifiedAt;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    factory User.fromJson(Map<String, dynamic> json){ 
        return User(
            id: json["id"] ?? 0,
            firstName: json["first_name"] ?? "",
            lastName: json["last_name"] ?? "",
            gender: json["gender"] ?? "",
            phone: json["phone"] ?? "",
            email: json["email"] ?? "",
            photo: json["photo"] ?? "",
            userType: json["user_type"] == null ? null : UserType.fromJson(json["user_type"]),
            emailVerifiedAt: json["email_verified_at"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
        );
    }

}

class UserType {
    UserType({
        required this.id,
        required this.type,
    });

    final int id;
    final String type;

    factory UserType.fromJson(Map<String, dynamic> json){ 
        return UserType(
            id: json["id"] ?? 0,
            type: json["type"] ?? "",
        );
    }

}
