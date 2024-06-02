// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api.dart';
import 'package:gbce/APIV1/requests/event_booking_request.dart';
import 'package:gbce/constants/widgets.dart';
import 'package:gbce/screens/group/pdf_preview.dart';
import 'package:path_provider/path_provider.dart';

void getEventticket(BuildContext context, String eventId) async {
  ApiResponse response = await Geteventticket.geteventticket(eventId);

  if (response.error == null && response.data != null) {
    if (response.data is List<int>) {
      List<int> pdfBytes = response.data as List<int>;
      successToast('PDF created successfully');
      await saveAndOpenPdf(context, pdfBytes, 'event_ticket.pdf');
    } else {
      errorToast('Invalid PDF data');
    }
  } else {
    errorToast('Event creation failed');
  }
}

Future<void> saveAndOpenPdf(
    BuildContext context, List<int> pdfBytes, String fileName) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PDFViewer(filePath: filePath)),
    );
  } catch (e) {
    print('Error saving or opening PDF: $e');
  }
}




// void getEventticket(BuildContext context, String eventId) async {
//   // Geteventticket();
//   showErrorDialog(context, eventId);
// }
