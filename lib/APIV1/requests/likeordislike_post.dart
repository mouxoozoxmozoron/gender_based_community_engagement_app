import 'dart:convert';
import 'package:gbce/APIV1/api.dart';
import 'package:gbce/APIV1/api_end_points.dart';
import 'package:gbce/constants/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LikeorDislikepost {
  static Future<ApiResponse> likeordislikepost(
    String postId,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await http.post(
        Uri.parse(likeOrdislikeapostendpoint),
        body: json.encode({
          'post_id': postId,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
          apiResponse.data = response.body;
          apiResponse.error = null;
          successToast('Disliked');
          break;
        case 201:
          apiResponse.data = response.body;
          apiResponse.error = null;
          successToast('Liked');
          break;
        case 422:
          final errors = jsonDecode(response.body);
          apiResponse.error = errors[errors.keys.elementAt(0)];
          errorToast('failed to process request');
          break;
        default:
          apiResponse.error = jsonDecode(response.body);
      }
    } catch (e) {
      apiResponse.error = "Something went wrong, server internal error $e";
    }
    return apiResponse;
  }
}
