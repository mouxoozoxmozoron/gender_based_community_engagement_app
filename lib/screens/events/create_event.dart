import "dart:io";

import "package:flutter/material.dart";
import "package:gbce/APIV1/api.dart";
import "package:gbce/APIV1/requests/create_event_request.dart";
import "package:gbce/Componnent/Navigation.dart";
import "package:gbce/constants/widgets.dart";
import "package:gbce/navigations/routes_configurations.dart";
import "package:get/get_navigation/get_navigation.dart";
import "package:get/utils.dart";
import "package:image_picker/image_picker.dart";
import "package:permission_handler/permission_handler.dart";

class Newevent extends StatefulWidget {
  const Newevent({super.key});

  @override
  State<Newevent> createState() => _NewpostState();
}

class _NewpostState extends State<Newevent> {
  final int groupId = Get.arguments as int;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  XFile? _image;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text =
            pickedDate.toString().substring(0, 10); // Format date as desired
      });
    }
  }

  void showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

//permission checker
  void _checkPermissionAndPickImage() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if (status.isGranted) {
      _pickImage();
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  bool iseventcreationloading = false;
  bool postcreated = false;
  String? errors;
  void creatingevent() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if (status.isGranted && _formKey.currentState!.validate()) {
      setState(() {
        iseventcreationloading = true;
      });
      // File? imageFile = _image != null ? File(_image!.path) : null;
      File? imageFile;
      if (_image != null) {
        imageFile = File(_image!.path);
      }
      // ignore: use_build_context_synchronously
      ApiResponse response = await CreateeventRequest.createevent(
        context,
        descriptionController.text,
        titleController.text,
        locationController.text,
        dateController.text,
        timeController.text,
        groupId,
        imageFile,
      );

      if (response.error == null) {
        setState(() {
          iseventcreationloading = false;
          postcreated = true;
        });
        successToast('Event created succesfuly');
        // Get.off(RoutesClass.getgroupdetailsRoute());
        Get.back();
      } else {
        setState(() {
          iseventcreationloading = false;
          postcreated = false;
          errors = response.error;
        });
        print('API Error: ${response.error}');
        errorToast('API Error: ${response.error}');
        // ignore: use_build_context_synchronously
        showErrorDialog(context, response.error!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black.withOpacity(0.5),
      drawer: const NavBar(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[400],
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
                        "New event",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.grey[800],
                          fontSize: 36,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: "Event title",
                          hintText: "Give title to your event",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Event title must be given';
                          }
                          if (value.length < 2) {
                            return 'Event title must be atleast 2 character';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

//last name start here
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: "Desription",
                          hintText: "Provide desription",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Event desricption is required';
                          }
                          if (value.length < 2) {
                            return 'Event desription must be at least 2 character';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        controller: locationController,
                        decoration: const InputDecoration(
                          labelText: "Location",
                          hintText: "Provide location for the event",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Event location must be known';
                          }
                          if (value.length < 2) {
                            return 'Post title must be atleast 2 character';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

//BE CAREFULL
                      TextFormField(
                        controller: dateController,
                        decoration: const InputDecoration(
                          labelText: "Date",
                          hintText: "Date for the event",
                        ),
                        readOnly: true, // Makes the TextFormField read-only
                        onTap: () {
                          _selectDate(context);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Event date must be known';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: timeController,
                        decoration: const InputDecoration(
                          labelText: "Time",
                          hintText: "Provide time event",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Event time must be known';
                          }
                          if (value.length < 2) {
                            return 'Event time must be atleast 4 character';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

//event image
                      _image != null
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(File(_image!.path)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: _checkPermissionAndPickImage,
                              child: const Text(
                                'Upload Event image',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                      const SizedBox(height: 20),

                      //registartion process
                      iseventcreationloading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green.shade800),
                              ),
                              onPressed: creatingevent,
                              child: const Text(
                                "Publish",
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
        ],
      ),
    );
  }
}
