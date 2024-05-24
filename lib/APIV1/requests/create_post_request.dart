import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api.dart';
import 'package:gbce/APIV1/api_end_points.dart';
import 'package:gbce/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreatepostRequest {
  static Future<ApiResponse> createpost(
    BuildContext context,
    String title,
    String description,
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

      // Print all collected data before making the POST request
      print('Collected Data:');
      print('description: $description');
      print('post title: $title');
      print('Base64 Image: $base64Image');

      // Make POST request to the registration endpoint
      final response = await http.post(
        Uri.parse(newPost),
        body: json.encode({
          'title': title,
          'description': description,
          'post_image': base64Image, // Adding the photo property
          // Add other fields as needed
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
        case 422:
          final errors = jsonDecode(response.body);
          apiResponse.error = errors[errors.keys.elementAt(0)];
          break;
        default:
          apiResponse.error = jsonDecode(response.body);
      }
    } catch (e) {
      apiResponse.error = "Something went wrong, server intrnal error $e";
      // Handle errors
      print('Error: $e');
    }
    return apiResponse;
  }
}
