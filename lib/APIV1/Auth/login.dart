// ignore: file_names
import 'package:flutter/material.dart';
import 'package:gbce/APIV1/requests/login_api.dart';
import 'package:gbce/APIV1/Register.dart';
import 'package:gbce/Componnent/AppBar.dart';
import 'package:gbce/navigations/routes_configurations.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();

  // Public method to perform login
  void login(BuildContext context, String email, String password) {
    // Your login logic here...
    print("Email: $email");
    print("Password: $password");
    // Call your endpoint for login logic here
  }
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // appBar: AppBar(
        //   title: const Text("Login Page"),
        // ),

        appBar: CustomAppBar(
          title: 'gbce',
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Handle search action
              },
            ),
          ],
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
              child: Card(
                // padding: const EdgeInsets.all(16.0),
                color: Colors.grey.shade100.withOpacity(0.7),
                elevation: 8,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Login",
                        // style: Theme.of(context).textTheme.headline5,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.grey[800],
                          fontSize: 36,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
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
                          // Add additional password validation if needed
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.green.shade800,
                            ), // Background color
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // If form is valid, call login function from the Login class
                              // widget.login(
                              //   context,
                              //   _emailController.text,
                              //   _passwordController.text,
                              // );

                              // If form is valid, call login method from the LoginApi class
                              LoginApi.login(
                                context,
                                _emailController.text,
                                _passwordController.text,
                              );
                            }
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Register()),
                          );

                          Get.offAllNamed(RoutesClass.getregisterscreenRoute());
                        },
                        child: const Text(
                          'Don\'t have an account?',
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
            )),
          ],
        ));
  }
}
