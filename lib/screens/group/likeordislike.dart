// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api.dart';
import 'package:gbce/APIV1/requests/likeordislike_post.dart';

void likeOrdislikeposts(BuildContext context, String postId) async {
  ApiResponse response = await LikeorDislikepost.likeordislikepost(postId);

  if (response.error == null && response.data != null) {}
}



// void getEventticket(BuildContext context, String eventId) async {
//   // Geteventticket();
//   showErrorDialog(context, eventId);
// }
