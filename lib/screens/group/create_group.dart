import "dart:io";

import "package:flutter/material.dart";
import "package:gbce/APIV1/api.dart";
import "package:gbce/APIV1/requests/creategroup_request.dart";
import "package:gbce/Componnent/Navigation.dart";
import "package:gbce/constants/widgets.dart";
import "package:gbce/navigations/routes_configurations.dart";
import "package:get/get_navigation/get_navigation.dart";
import "package:get/utils.dart";

class Newgroup extends StatefulWidget {
  const Newgroup({super.key});

  @override
  State<Newgroup> createState() => _NewpostState();
}

class _NewpostState extends State<Newgroup> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

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

  bool iseventcreationloading = false;
  bool postcreated = false;
  String? errors;
  void creatinggroup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        iseventcreationloading = true;
      });
      // File? imageFile = _image != null ? File(_image!.path) : null;

      // ignore: use_build_context_synchronously
      ApiResponse response = await CreategroupRequest.createevent(
        context,
        nameController.text,
      );

      if (response.error == null) {
        setState(() {
          iseventcreationloading = false;
          postcreated = true;
        });
        successToast('Group created succesfuly');
        Get.toNamed(RoutesClass.getcommunityRoute());
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
                        "New Community",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.grey[800],
                          fontSize: 36,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "Group name",
                          hintText: "Give name for the community",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Group name must be given';
                          }
                          if (value.length < 2) {
                            return 'Group name must be atleast 2 character';
                          }
                          return null;
                        },
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
                              onPressed: creatinggroup,
                              child: const Text(
                                "Create",
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
