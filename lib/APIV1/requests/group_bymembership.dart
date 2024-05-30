import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api.dart';
import 'package:gbce/APIV1/api_end_points.dart';
import 'package:gbce/models/group_by_membership.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Getgroupbymembership {
  static Future<ApiResponse> getgroupbymembership(
    BuildContext context,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await http.get(
        Uri.parse(getGroupbyMembership),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
            // Parse the JSON response and create a Groupbymembership instance
          final Map<String, dynamic> responseData = json.decode(response.body);
          apiResponse.data = Groupbymembership.fromJson(responseData);
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
