import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api_end_points.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrganisationService {
  // Endpoint for fetching organisations

  // Method to fetch organisations
  static Future<List<Map<String, dynamic>>> fetchOrganisations() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse(getOrganisations),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['organisations']);
      } else {
        throw Exception('Failed to fetch organisations');
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
}
