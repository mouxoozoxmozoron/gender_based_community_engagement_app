import 'dart:convert';
import 'package:gbce/APIV1/api_end_points.dart';
import 'package:http/http.dart' as http;

class PostService {
  static Future<List<dynamic>> fetchPosts() async {
    final response = await http.get(Uri.parse(homeController));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['Posts'];
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
