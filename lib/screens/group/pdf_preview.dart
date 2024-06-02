// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PDFViewer extends StatefulWidget {
  final String filePath;

  const PDFViewer({Key? key, required this.filePath}) : super(key: key);

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  Future<void> _downloadPdf() async {
    try {
      if (await Permission.storage.request().isGranted) {
        final directory = await getExternalStorageDirectory();
        final downloadsDirectory = Directory(
            '${directory!.parent.parent.parent.parent.path}/Download');

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final newFilePath =
            '${downloadsDirectory.path}/event_ticket_$timestamp.pdf';
        final newFile = File(newFilePath);

        await File(widget.filePath).copy(newFilePath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF downloaded to ${newFile.path}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Event ticket',
          style: TextStyle(
            fontFamily: 'Popppins',
            fontSize: 26,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadPdf,
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: PDFView(
            filePath: widget.filePath,
          ),
        ),
      ),
    );
  }
}
