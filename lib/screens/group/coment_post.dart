// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api.dart';
import 'package:gbce/APIV1/requests/create_coment_request.dart';

Future<ApiResponse> comentPost(
    BuildContext context, String postId, String message) async {
  ApiResponse response = await Comentpost.comentpost(postId, message);

  if (response.error == null && response.data != null) {
    // Additional logic can be added here if needed
  }

  return response;
}
