// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gbce/APIV1/Auth/login.dart';
import 'package:gbce/APIV1/api.dart';
import 'package:gbce/constants/widgets.dart';
import 'package:gbce/models/user.dart';
import 'package:gbce/navigations/routes_configurations.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gbce/APIV1/API/Register_api.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
        title: const Text("Register"),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/equality.jpg'),
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
                      SizedBox(height: 20),
                      Text(
                        "Register",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.grey[800],
                          fontSize: 36,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),

                      TextFormField(
                        controller: _first_nameController,
                        decoration: InputDecoration(
                          labelText: "First Name",
                          hintText: "Enter your first name",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          if (value.length < 5) {
                            return 'fist name must be at least 5 characters';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 20),

//last name start here
                      TextFormField(
                        controller: _last_nameController,
                        decoration: InputDecoration(
                          labelText: "Last Nme",
                          hintText: "Enter your last name",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          if (value.length < 5) {
                            return 'last name must be at least 5 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

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
                        decoration: InputDecoration(
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
                      SizedBox(height: 20),

                      //phone number start here
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
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
                      SizedBox(height: 20),
//end of phone number

//password start here
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
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
                      SizedBox(height: 20),
//password end here

//password conermation
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
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
                      SizedBox(height: 20),
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
                      SizedBox(height: 20),

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
                                "Register",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                      SizedBox(height: 20),

                      TextButton(
                        onPressed: () {
                          Get.offAllNamed(RoutesClass.getloginRoute());
                        },
                        child: const Text(
                          'Login ?',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Color.fromARGB(255, 3, 114, 206),
                          ),
                        ),
                      )
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
      }
      );
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
      }
      
      );
      // File? imageFile = _image != null ? File(_image!.path) : null;
      File? imageFile;
      if (_image != null) {
        imageFile = File(_image!.path);
      }
      // ignore: use_build_context_synchronously
      ApiResponse response = await RegisterApi.register(
        context,
        _first_nameController.text,
        _last_nameController.text,
        _emailController.text,
        _phoneController.text,
        _passwordController.text,
        imageFile,
        gender,
      );

      if (response.error == null) {
        setState(() {
          isRegistrationLoading = false;
          userCreated = true;
          user = response.data as User;
        });
        //Storing token and user details in local storage
        //IMPORTANT
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', user!.token);
        await prefs.setInt('userId', user!.data.id);

        final token = prefs.getString('token');

        //navigation to login
        Get.offAllNamed(RoutesClass.getpostsRoute());

        if (userCreated) {
          //paaing variable as an argumment
          successToast(token ?? '');
        }
      } 
      
      
      
      else {
        setState(() {
          isRegistrationLoading = false;
          userCreated = false;
        });
        // errorToast("hello there");
        errorToast("Not connected !");
      }
    }
  }
}
