// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api.dart';
import 'package:gbce/APIV1/api_end_points.dart';
import 'package:gbce/constants/widgets.dart';
import 'package:gbce/screens/actions/change_password_action.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewerPage extends StatefulWidget {
  const ProfileViewerPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfileViewerPageState createState() {
    return _ProfileViewerPageState();
  }
}

class _ProfileViewerPageState extends State<ProfileViewerPage> {
  late SharedPreferences _prefs;
  String? token;
  int? userId;
  String username = '';
  String useremail = '';
  String userphonenumber = '';
  String fullProfileImageUrl = '';
  String serverurl = serverUrlPlain;
  bool isdisplayingformfield = false;
  bool ischangingpassword = false;
  bool isButtonDisabled = false;
  int remainingTimeInSeconds = 0;
  Timer? countdownTimer;

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
    _checkLastPasswordChange();
  }

// time checker logics
  Future<void> _checkLastPasswordChange() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? lastChangeTimestamp = prefs.getInt('lastPasswordChange');
    if (lastChangeTimestamp != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final diff = now - lastChangeTimestamp;
      const int buttonHidingTimeInMillis =
          2 * 60 * 1000; // Two minutes in milliseconds

      if (diff < buttonHidingTimeInMillis) {
        setState(() {
          isButtonDisabled = true;
          remainingTimeInSeconds = (buttonHidingTimeInMillis - diff) ~/ 1000;
        });

        countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            remainingTimeInSeconds--;
          });

          if (remainingTimeInSeconds <= 0) {
            timer.cancel();
            setState(() {
              isButtonDisabled = false;
            });
          }
        });
      }
    }
  }

// end of time checker logics

  Future<void> _fetchProfileData() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      userphonenumber = _prefs.getString('phonenumber') ?? 'Unknown';
      token = _prefs.getString('token');
      userId = _prefs.getInt('userId');
      String firstName = _prefs.getString('firsname') ?? 'Unknown';
      String lastName = _prefs.getString('lastname') ?? 'Unknown';
      username = '$firstName $lastName';
      useremail = _prefs.getString('email') ?? 'Unknown';
      String profilePhotoUrl = _prefs.getString('profilephotourl') ?? '';
      fullProfileImageUrl =
          _constructFullImageUrl(serverUrlPlain, 'storage', profilePhotoUrl);
    });
  }

  String _constructFullImageUrl(
      String baseUrl, String storagePath, String photoUrl) {
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }
    if (storagePath.startsWith('/')) {
      storagePath = storagePath.substring(1);
    }
    return '$baseUrl/$storagePath/$photoUrl';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 22, color: Colors.blue),
          ),
        ),
        body: SingleChildScrollView(
          child: Card(
            color: Colors.grey[200],
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color: Colors.grey.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(fullProfileImageUrl),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      username,
                      style: const TextStyle(
                          fontSize: 24,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userphonenumber,
                      style:
                          const TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                    ),
                    Text(
                      useremail,
                      style:
                          const TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                    ),
                    const SizedBox(height: 30),

                    if (!isButtonDisabled)
                      TextButton(
                          onPressed: () {
                            setState(() {
                              isdisplayingformfield = !isdisplayingformfield;
                            });
                            print('Update Profile button clicked');
                          },
                          child: isdisplayingformfield
                              ? const Text('Cancel')
                              : const Text('Change password')),

                    if (isButtonDisabled)
                      Text(
                        'You can update your password after  ${remainingTimeInSeconds ~/ 60} minutes ${remainingTimeInSeconds % 60} seconds',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        ),
                      ),
                    // start of form
                    if (isdisplayingformfield)
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _oldPasswordController,
                              decoration: const InputDecoration(
                                labelText: 'Old Password',
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your old password';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _newPasswordController,
                              decoration: const InputDecoration(
                                labelText: 'New Password',
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your new password';
                                }
                                if (value.length < 6) {
                                  return 'New password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            ischangingpassword
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      if (_formKey.currentState?.validate() ==
                                          true) {
                                        setState(() {
                                          ischangingpassword = true;
                                        });

                                        ApiResponse response =
                                            await changepassaction(
                                                context,
                                                _oldPasswordController.text,
                                                _newPasswordController.text);

                                        if (response.error == null) {
                                          setState(() {
                                            isButtonDisabled = true;
                                            ischangingpassword = false;
                                            isdisplayingformfield = false;
                                            remainingTimeInSeconds = 2 * 60;
                                          });

                                          prefs.setInt(
                                              'lastPasswordChange',
                                              DateTime.now()
                                                  .millisecondsSinceEpoch);
                                          _oldPasswordController.clear();
                                          _newPasswordController.clear();

                                          CustomSnackBar.show(
                                              context, 'Password changed',
                                              backgroundColor: Colors.green,
                                              actionLabel: 'OK');

                                          countdownTimer = Timer.periodic(
                                              const Duration(seconds: 1),
                                              (timer) {
                                            setState(() {
                                              remainingTimeInSeconds--;
                                            });

                                            if (remainingTimeInSeconds <= 0) {
                                              timer.cancel();
                                              setState(() {
                                                isButtonDisabled = false;
                                              });
                                            }
                                          });
                                        } else {
                                          setState(() {
                                            ischangingpassword = false;
                                          });
                                          CustomSnackBar.show(context,
                                              response.error.toString());
                                        }
                                      }
                                    },
                                    child: const Text('Request'),
                                  ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    // ending of form
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
