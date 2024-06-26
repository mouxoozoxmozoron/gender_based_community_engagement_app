import 'dart:convert';
import 'package:gbce/APIV1/api_end_points.dart';
import 'package:gbce/models/home_model.dart';
import 'package:http/http.dart' as http;

class PostService {
  static Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse(homeController));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> postsJson = data['Posts'];
      return postsJson.map((postJson) => Post.fromJson(postJson)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
