import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api.dart';
import 'package:gbce/APIV1/api_end_points.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreateeventRequest {
  static Future<ApiResponse> createevent(
    BuildContext context,
    String title,
    String description,
    String location,
    String date,
    String time,
    int? groupid,
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
        Uri.parse(newEvent),
        body: json.encode({
          'title': title,
          'description': description,
          'date': date,
          'location': location,
          'time': time,
          'image': base64Image,
          'group_id': groupid,
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
