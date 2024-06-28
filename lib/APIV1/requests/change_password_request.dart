import 'dart:convert';
import 'package:gbce/APIV1/api.dart';
import 'package:gbce/APIV1/api_end_points.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Changepassword {
  static Future<ApiResponse> changepassword(
    String oldpass,
    String newpass,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await http.post(
        Uri.parse(changepasswordendpoint),
        body: json.encode({
          'old_password': oldpass,
          'new_password': newpass,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 201:
          apiResponse.data = response.body;
          apiResponse.error = null;
          break;
        case 401:
          final errors = jsonDecode(response.body);
          apiResponse.error = errors[errors.keys.elementAt(0)];
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
