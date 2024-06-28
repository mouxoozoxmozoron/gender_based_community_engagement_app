import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api.dart';
import 'package:gbce/APIV1/api_end_points.dart';
import 'package:gbce/constants/widgets.dart';
import 'package:gbce/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Providefeedback {
  static Future<ApiResponse> providefeedback(
    BuildContext context,
    String eventId,
    File? imageFile,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    ApiResponse apiResponse = ApiResponse();
    try {
      // Convert image file to base64
      String? base64Image;
      if (imageFile != null) {
        List<int> imageBytes = await imageFile.readAsBytes();
        base64Image = base64Encode(imageBytes);
      }

      // Make POST request to the registration endpoint
      final response = await http.post(
        Uri.parse(providefeedbackreport),
        body: json.encode({
          'event_id': eventId,
          'report': base64Image,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 201:
          apiResponse.error = null;
          break;
        case 401:
          errorToast("we could not process your request, try agin later");
          final errors = jsonDecode(response.body);
          apiResponse.error = errors[errors.keys.elementAt(0)];
          break;
        default:
          apiResponse.error = "Something went wrong, try again later";
      }
    } catch (e) {
      apiResponse.error = "Error: $e";
      // Handle errors
      print('Error: $e');
      // ignore: use_build_context_synchronously
      CustomSnackBar.show(context, "$e");
    }
    return apiResponse;
  }
}
