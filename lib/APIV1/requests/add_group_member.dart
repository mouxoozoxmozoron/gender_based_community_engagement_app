import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api.dart';
import 'package:gbce/APIV1/api_end_points.dart';
import 'package:gbce/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Addgroupmember {
  static Future<ApiResponse> addgroupmember(
    BuildContext context,
    String first_name,
    String last_name,
    String email,
    String phone,
    String password,
    File? imageFile,
    String gender,
    int? groupId,
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
        Uri.parse(newgroupMmeberendpoint),
        body: json.encode({
          'first_name': first_name,
          'last_name': last_name,
          'gender': gender,
          'email': email,
          'phone': phone,
          'password': password,
          'photo': base64Image,
          'group_id': groupId,
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
          final errors = jsonDecode(response.body);
          apiResponse.error = errors[errors.keys.elementAt(0)];
      }
    } catch (e) {
      apiResponse.error = "Something went wrong, try again later";
      // Handle errors
      print('Error: $e');
    }
    return apiResponse;
  }
}
