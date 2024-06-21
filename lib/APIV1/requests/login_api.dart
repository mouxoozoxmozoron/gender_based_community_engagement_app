import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api_end_points.dart';
import 'package:gbce/navigations/routes_configurations.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import http package

class LoginApi {
  static Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      final response = await http.post(Uri.parse(loginEndpoint),
          body: json.encode({'email': email, 'password': password}),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        // Parse the response body
        Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody.containsKey('user') &&
            responseBody.containsKey('token')) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();

          await prefs.setString('token', responseBody['token']);
          await prefs.setInt('userId', responseBody['user']['id']);
          await prefs.setString(
              'profilephotourl', responseBody['user']['photo']);
          await prefs.setString('firsname', responseBody['user']['first_name']);
          await prefs.setString('phonenumber', responseBody['user']['phone']);
          await prefs.setString('lastname', responseBody['user']['last_name']);
          await prefs.setString('email', responseBody['user']['email']);

          await prefs.setInt(
              'usertypeId', int.parse(responseBody['user']['user_type']));

          Get.offAllNamed(RoutesClass.getpostsRoute());
        } else {
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Invalid response from server.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to login. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('An error occurred. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
