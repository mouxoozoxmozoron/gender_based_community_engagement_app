import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api.dart';
import 'package:gbce/APIV1/api_end_points.dart';
import 'package:gbce/models/user.dart';
import 'package:http/http.dart' as http;

class RegisterApi {
  static Future<ApiResponse> register(
    BuildContext context,
    String first_name,
    String last_name,
    String email,
    String phone,
    String password,
    File? imageFile,
    String gender,
  ) 
  
  async {
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
      print('first name: $first_name');
      print('last name: $last_name');
      print('email: $email');
      print('phone: $phone');
      print('Password: $password');
      print('Base64 Image: $base64Image');
      print('gender: $gender');

      // Make POST request to the registration endpoint
      final response = await http.post(
        Uri.parse(registrationEndpoint),
        body: json.encode({
          'first_name': first_name,
          'last_name': last_name,
          'gender': gender,
          'email': email,
          'phone': phone,
          'password': password,
          'photo': base64Image, // Adding the photo property
          // Add other fields as needed
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
      );

      switch (response.statusCode) {
        case 201:
          apiResponse.data = userFromJson(response.body);
          break;
        case 422:
          final errors = jsonDecode(response.body);
          apiResponse.error = errors[errors.keys.elementAt(0)];
          break;
        default:
          apiResponse.error = "Something went wrong, try again later";
      }
    } catch (e) {
      apiResponse.error = "Something went wrong, try again later";
      // Handle errors
      print('Error: $e');
    }
    return apiResponse;
  }
}
