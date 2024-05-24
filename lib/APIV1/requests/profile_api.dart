import 'dart:convert';
import 'package:gbce/APIV1/api_end_points.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getUserProfile(int userId) async {
  try {
    print('Fetching user profile for ID: $userId'); // Print the ID
    final response = await http.get(Uri.parse('${serverUrl}Profile/$userId'));
    // .get(Uri.parse('http://127.0.0.1:8000/api/Profile?id=$userId'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['user'];
    }
    if (response.statusCode == 404) {
      throw Exception(
          'Failed to load user profile: ${response.statusCode} - ${response.body}');
    } else {
      throw Exception(
          'Failed to load user profile: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    // Handle any errors that occur during the API call
    print('Error fetching user profile: $e');
    throw Exception('Failed to load user profile, internal server error');
  }
}
