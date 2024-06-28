// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api.dart';
import 'package:gbce/APIV1/requests/change_password_request.dart';

Future<ApiResponse> changepassaction(
    BuildContext context, String oldpass, String newpass) async {
  ApiResponse response = await Changepassword.changepassword(oldpass, newpass);

  if (response.error == null && response.data != null) {
    // Additional logic can be added here if needed
  }
  return response;
}
