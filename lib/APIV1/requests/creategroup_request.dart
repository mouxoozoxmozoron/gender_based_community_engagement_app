import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api.dart';
import 'package:gbce/APIV1/api_end_points.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreategroupRequest {
  static Future<ApiResponse> creategroup(
    BuildContext context,
    String name,
    String legalDocs,
    String organisationId,
  ) async {
    // Retrieve token from SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Initialize the ApiResponse object
    ApiResponse apiResponse = ApiResponse();

    try {
      // Make POST request to the registration endpoint
      final response = await http.post(
        Uri.parse(newGroup), // Define the API endpoint
        body: json.encode({
          'name': name,
          'organisation_id': organisationId,
          'legal_docs': legalDocs,
        }),
        headers: _setHeaders(token), // Set headers with authorization
      );

      // Handle the response based on status code
      apiResponse = _handleResponse(response);
    } catch (e) {
      apiResponse.error = "Something went wrong: $e";
      print('Error: $e'); // Log the error
    }
    return apiResponse;
  }

  // Function to set headers for the API request
  static Map<String, String> _setHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token', // Bearer token for authentication
    };
  }

  // Function to handle the response from the API
  static ApiResponse _handleResponse(http.Response response) {
    ApiResponse apiResponse = ApiResponse();

    switch (response.statusCode) {
      case 201: // Created
        apiResponse.error = null; // No error
        break;
      case 422: // Unprocessable Entity
        final errors = jsonDecode(response.body);
        apiResponse.error =
            errors[errors.keys.elementAt(0)]; // Extract the first error
        break;
      case 401: // Unauthorized
        apiResponse.error =
            'Unauthorized access. Please log in again.'; // Handle unauthorized error
        break;
      default:
        apiResponse.error = jsonDecode(response.body); // Handle other errors
    }

    return apiResponse;
  }
}
