// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api.dart';
import 'package:gbce/APIV1/requests/add_group_member.dart';
import 'package:gbce/constants/widgets.dart';
import 'package:gbce/models/user.dart';
import 'package:gbce/navigations/routes_configurations.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class AddgroupMember extends StatefulWidget {
  const AddgroupMember({Key? key}) : super(key: key);

  @override
  State<AddgroupMember> createState() => _AddgroupMemberState();
}

class _AddgroupMemberState extends State<AddgroupMember> {
  final int groupId = Get.arguments as int;
  final _formKey = GlobalKey<FormState>();
  List<dynamic> genders = [];
  String? genderid;

  final TextEditingController _first_nameController = TextEditingController();
  final TextEditingController _last_nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  XFile? _image;
  String gender = "";

//asigning value to the variable
  @override
  void initState() {
    super.initState();
    this.genders.add({"id": "male", "label": "male"});
    this.genders.add({"id": "female", "label": "female"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add group member"),
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
              padding: const EdgeInsets.all(10.10),
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
                          "Add group member",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.grey[800],
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _first_nameController,
                          decoration: const InputDecoration(
                            labelText: "First Name",
                            hintText: "Enter your first name",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your first name';
                            }
                            if (value.length < 2) {
                              return 'fist name must be at least 2 characters';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        //last name start here
                        TextFormField(
                          controller: _last_nameController,
                          decoration: const InputDecoration(
                            labelText: "Last Nme",
                            hintText: "Enter your last name",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            if (value.length < 2) {
                              return 'last name must be at least 2 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        //we need to add gender selection here
                        FormHelper.dropDownWidgetWithLabel(
                          context,
                          "Gender",
                          "select your gender",
                          this.genderid,
                          this.genders,
                          (onChangedval) {
                            this.genderid = onChangedval;

                            gender = onChangedval;

                            print("user gender is : $onChangedval");
                          },
                          (onValidateval) {
                            if (onValidateval == null) {
                              return "please select gender";
                            }
                            return null;
                          },
                          borderColor: Theme.of(context).primaryColor,
                          borderFocusColor: Theme.of(context).primaryColor,
                          borderRadius: 10,
                          optionLabel: "label",
                          optionValue: "id",
                        ),

                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            hintText: "Enter your email",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        //phone number start here
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: "Phone",
                            hintText: "Enter your phone number",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (value.length < 10 || value.length > 12) {
                              return 'Phone number must be between 10 and 12 digits';
                            }
                            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        //end of phone number

                        //password start here
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: "Password",
                            hintText: "Enter your password",
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        //password end here

                        //password conermation
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: const InputDecoration(
                            labelText: "Confirm Password",
                            hintText: "Re-enter your password",
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        //end of password confirmation

                        //profile image
                        _image != null
                            ? CircleAvatar(
                                radius: 120,
                                backgroundImage: FileImage(File(_image!.path)),
                              )
                            : ElevatedButton(
                                onPressed: _checkPermissionAndPickImage,
                                child: const Text(
                                  'Select Profile Image',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                        const SizedBox(height: 20),

                        //registartion process
                        isRegistrationLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green.shade800),
                                ),
                                onPressed: _registerWithPermissionCheck,
                                child: const Text(
                                  "Add",
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

//permission hendler
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

  bool isRegistrationLoading = false;
  bool userCreated = false;
  User? user;
  void _registerWithPermissionCheck() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if (status.isGranted && _formKey.currentState!.validate()) {
      setState(() {
        isRegistrationLoading = true;
      });
      File? imageFile;
      if (_image != null) {
        imageFile = File(_image!.path);
      }
      ApiResponse response = await Addgroupmember.addgroupmember(
        context,
        _first_nameController.text,
        _last_nameController.text,
        _emailController.text,
        _phoneController.text,
        _passwordController.text,
        imageFile,
        gender,
        groupId,
      );

      if (response.error == null) {
        setState(() {
          isRegistrationLoading = false;
          userCreated = true;
        });
        successToast('member added succesfully');
        Get.back();
      } else {
        setState(() {
          isRegistrationLoading = false;
          userCreated = false;
        });
        // errorToast("hello there");
        errorToast("error $response.error");
        print(response.error);
        showErrorDialog(context, response.error!);
      }
    }
  }
}
