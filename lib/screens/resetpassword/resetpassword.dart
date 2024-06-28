// ignore: file_names
import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api.dart';
import 'package:gbce/APIV1/requests/request_otp.dart';
import 'package:gbce/APIV1/requests/resetpassword.dart';
import 'package:gbce/APIV1/requests/verify_otp.dart';
import 'package:gbce/constants/widgets.dart';
import 'package:gbce/navigations/routes_configurations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Resetpassword extends StatefulWidget {
  const Resetpassword({Key? key}) : super(key: key);

  @override
  State<Resetpassword> createState() => _ResetpasswordState();

  void login(BuildContext context, String email, String password) {
    // Your login logic here...
    print("Email: $email");
    print("Password: $password");
    // Call your endpoint for login logic here
  }
}

class _ResetpasswordState extends State<Resetpassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  final TextEditingController _tokenController = TextEditingController();

  bool isprovidingemail = true;
  bool isprovidingotp = false;
  bool isprovidingpasword = false;
  bool isresetinpassword = false;
  bool issendingotprequest = false;
  bool isverifyingotprequest = false;
  bool isresetingpassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'gbce',
            style: TextStyle(
              fontFamily: 'Poppins',
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/equality.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.grey.withOpacity(
                        0.8), // Adjust opacity here (0.0 - fully transparent, 1.0 - fully opaque)
                    BlendMode.dstATop,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
                child: Center(
              child: Padding(
                padding: const EdgeInsets.all(18.10),
                child: Card(
                  // padding: const EdgeInsets.all(16.0),
                  color: Colors.grey.shade100.withOpacity(0.7),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            "Account recovery",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.grey[800],
                              fontSize: 22,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          if (isprovidingemail)
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
                          if (isprovidingotp)
                            TextFormField(
                              controller: _tokenController,
                              decoration: const InputDecoration(
                                labelText: "Token",
                                hintText: "Enter your OTP from your email",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your OTP';
                                }
                                return null;
                              },
                            ),
                          const SizedBox(height: 20),
                          if (isprovidingpasword)
                            TextFormField(
                              controller: _passwordController,
                              decoration: const InputDecoration(
                                labelText: "New password",
                                hintText: "Enter New password",
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
                          if (isprovidingpasword)
                            TextFormField(
                              controller: _confirmpasswordController,
                              decoration: const InputDecoration(
                                labelText: "Confirm password",
                                hintText: "Re-enter your password",
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Password does not match!';
                                }
                                return null;
                              },
                            ),
                          const SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Column(
                              children: [
                                if (isprovidingemail)
                                  issendingotprequest
                                      ? CircularProgressIndicator()
                                      : ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                              Colors.green.shade800,
                                            ),
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                issendingotprequest = true;
                                              });
                                              ApiResponse response =
                                                  await Requestotp.requestotp(
                                                _emailController.text,
                                              );

                                              if (response.error == null) {
                                                setState(() {
                                                  issendingotprequest = false;
                                                  isprovidingemail = false;
                                                  isprovidingotp = true;
                                                });
                                                // ignore: use_build_context_synchronously
                                                CustomSnackBar.show(context,
                                                    'OTP has been sent to your email',
                                                    backgroundColor:
                                                        Colors.green,
                                                    actionLabel: 'OK');
                                              } else {
                                                setState(() {
                                                  issendingotprequest = false;
                                                });
                                                print(response.error);
                                                // ignore: use_build_context_synchronously
                                                CustomSnackBar.show(context,
                                                    response.error.toString());
                                              }
                                            }
                                          },
                                          child: const Text(
                                            "Request OTP",
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                const SizedBox(height: 20),
                                if (isprovidingotp)
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Colors.green.shade800,
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        ApiResponse response =
                                            await Verifyotp.verifyotp(
                                          _tokenController.text,
                                        );
                                        setState(() {
                                          isverifyingotprequest = true;
                                        });

                                        if (response.error == null) {
                                          setState(() {
                                            isverifyingotprequest = false;
                                            isprovidingotp = false;
                                            isprovidingpasword = true;
                                          });
                                          // ignore: use_build_context_synchronously
                                          CustomSnackBar.show(context,
                                              'You can now recover your account',
                                              backgroundColor: Colors.green,
                                              actionLabel: 'OK');
                                        } else {
                                          print(response.error);

                                          // ignore: use_build_context_synchronously
                                          CustomSnackBar.show(context,
                                              response.error.toString());
                                        }
                                      }
                                    },
                                    child: const Text(
                                      "Veryf OTP",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                if (isprovidingpasword)
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Colors.green.shade800,
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        ApiResponse response =
                                            await Resetpasswordreq
                                                .resetpasswordreq(
                                          _passwordController.text,
                                        );
                                        if (response.error == null) {
                                          final SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          await prefs.remove('requestingemail');
                                          setState(() {
                                            isresetingpassword = false;
                                          });
                                          // ignore: use_build_context_synchronously
                                          CustomSnackBar.show(context,
                                              'Password reset successfully',
                                              backgroundColor: Colors.green,
                                              actionLabel: 'OK');
                                          Get.toNamed(
                                              RoutesClass.getloginRoute());
                                        } else {
                                          print(response.error);

                                          // ignore: use_build_context_synchronously
                                          CustomSnackBar.show(context,
                                              response.error.toString());
                                        }
                                      }
                                    },
                                    child: const Text(
                                      "Reset password",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )),
          ],
        ));
  }
}
