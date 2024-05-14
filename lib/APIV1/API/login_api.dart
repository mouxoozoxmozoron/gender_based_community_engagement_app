import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api_end_points.dart';
import 'package:gbce/navigations/routes_configurations.dart';
import 'package:gbce/screens/posts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http; // Import http package

class LoginApi {
  static Future<void> login(
      BuildContext context, String email, String password) async {
    //I HAVE DEFINED ALL OF MY END POINT INSIDE THE api_end_points FILE AND IMPORT
    //THEM TO USE IN DIFFERENT FILES

    try {
      // Make POST request to the login endpoint
      final response = await http.post(Uri.parse(loginEndpoint),
          body: json.encode({'email': email, 'password': password}),
          headers: {'Content-Type': 'application/json'});

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        // Parse the response body
        Map<String, dynamic> responseBody = json.decode(response.body);

        // Check if the response contains a user and token
        if (responseBody.containsKey('user') &&
            responseBody.containsKey('token')) {
          // Extract user and token

          //IN CASE YOU WANT TO USE THESE , UN COMENT
          // String user = responseBody['user'];
          // String token = responseBody['token'];

          // Navigate to Home page or do something else with the user and token
          // ignore: use_build_context_synchronously

          Get.offAllNamed(RoutesClass.getpostsRoute());
        } else {
          // Show error message if the response does not contain user and token
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Invalid response from server.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Show error message if the response status code is not 200
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to login. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle any errors that occur during the API request
      print('Error: $e');
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
