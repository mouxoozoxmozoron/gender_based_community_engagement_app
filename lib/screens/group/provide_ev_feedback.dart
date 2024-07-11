// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api.dart';
import 'package:gbce/APIV1/requests/provide_ev_fdbrequest.dart';
import 'package:gbce/constants/widgets.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class Feedback extends StatefulWidget {
  const Feedback({Key? key}) : super(key: key);

  @override
  State<Feedback> createState() => _FeedbackState();
}

class _FeedbackState extends State<Feedback> {
  final _formKey = GlobalKey<FormState>();

  late String eventId;
  File? _report;
  bool issendingfeedback = false;

  @override
  void initState() {
    super.initState();
    eventId = Get.arguments as String? ?? '';
    successToast(eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback"),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/equality.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.grey.withOpacity(0.8),
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                color: Colors.grey.shade100.withOpacity(0.7),
                elevation: 8,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          "Provide event feedback",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.grey[800],
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),

                        Text(
                          "*PDF files are mostly preferable!",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.grey[800],
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // Document selection
                        _report != null
                            ? ListTile(
                                title:
                                    Text('Selected Document: ${_report!.path}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _report = null;
                                    });
                                  },
                                ),
                              )
                            : ElevatedButton(
                                onPressed: _checkPermissionAndPickDocument,
                                child: const Text(
                                  'Upload Document',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                        const SizedBox(height: 20),

                        issendingfeedback
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Colors.green.shade800,
                                  ),
                                ),
                                onPressed: () {
                                  if (_report == null) {
                                    CustomSnackBar.show(
                                        context, "File can not be empty");
                                  } else {
                                    _sendingfeedbackwithpermisioncheck();
                                  }
                                },
                                child: const Text(
                                  "Submit feedback",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _checkPermissionAndPickDocument() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if (status.isGranted) {
      _pickDocument();
    }
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _report = File(result.files.single.path!);
      });
    }
  }

  void _sendingfeedbackwithpermisioncheck() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    if (status.isGranted && _formKey.currentState!.validate()) {
      issendingfeedback = true;
      ApiResponse response =
          await Providefeedback.providefeedback(context, eventId, _report);

      if (response.error == null) {
        setState(() {
          issendingfeedback = false;
        });
        CustomSnackBar.show(context, 'Feedback sent',
            backgroundColor: Colors.green, actionLabel: 'OK');
        Get.back();
      } else {
        setState(() {
          issendingfeedback = false;
        });
        CustomSnackBar.show(context, response.error.toString());
      }
    }
  }
}
