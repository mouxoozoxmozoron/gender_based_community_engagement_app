import 'dart:convert';
import 'package:gbce/APIV1/api.dart';
import 'package:gbce/APIV1/api_end_points.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Verifyotp {
  static Future<ApiResponse> verifyotp(String otp) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final useremail = prefs.getString('requestingemail');

    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await http.post(
        Uri.parse(verifytoken),
        body: json.encode({
          'token': otp,
          'email': useremail,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      switch (response.statusCode) {
        case 200:
          apiResponse.data =
              jsonDecode(response.body); // Expecting JSON response
          apiResponse.error = null;
          break;
        case 401:
          final errors = jsonDecode(response.body);
          apiResponse.error = errors[errors.keys.elementAt(0)];
          break;
        default:
          final responseBody = jsonDecode(response.body);
          apiResponse.error = responseBody['error'] ?? 'Unknown error';
      }
    } catch (e) {
      apiResponse.error = "Something went wrong, server internal error $e";
    }
    return apiResponse;
  }
}
