import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api_end_points.dart';
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

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

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
            'Pofile',
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
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ==
                                          true) {
                                        setState(() {
                                          ischangingpassword = true;
                                        });
                                        print(
                                            'Old Password: ${_oldPasswordController.text}');
                                        print(
                                            'New Password: ${_newPasswordController.text}');
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
