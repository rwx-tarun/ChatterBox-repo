import 'package:chat_app/auth/services/auth_services.dart';
import 'package:chat_app/auth/services/database_service.dart';
import 'package:chat_app/auth/services/preferences.dart';
import 'package:chat_app/misc/constant.dart';
import 'package:chat_app/misc/utils.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/password_reset_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/misc/text_input_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  String email = "";
  String password = "";

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.primaryColor,
      // appBar: AppBar(
      //   backgroundColor: Constant.secondaryColor,
      // ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : SafeArea(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 30),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text(
                          "Chatter Box",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 40),
                        ),
                        const Text(
                          "Welcome to Chatter Box !!",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15),
                        ),
                        // Image.asset('assets/img.png'),
                        Icon(
                          Icons.message_rounded,
                          color: Colors.black,
                          size: 250,
                        ),
                        TextFormField(
                          onChanged: (value) {
                            email = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Email";
                            } else if (!RegExp(r'\S+@\S+\.\S+')
                                .hasMatch(value)) {
                              return "Please Enter a Valid Email";
                            }
                            return null;
                          },
                          decoration: textInputDecoration1.copyWith(
                            enabled: true,
                            hoverColor: Constant.secondaryColor,
                            labelText: "Email",
                            labelStyle: TextStyle(color: Constant.hintText),
                            fillColor: Constant.secondaryColor,
                            filled: true,
                            prefixIcon: Icon(
                              Icons.email,
                              color: Constant.hintText,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          onChanged: (value) {
                            password = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Password";
                            } else if (value!.length < 6) {
                              return "Please Enter Password with min length 7";
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: textInputDecoration1.copyWith(
                            hoverColor: Constant.secondaryColor,
                            enabled: true,
                            labelText: "Password",
                            labelStyle: TextStyle(color: Constant.hintText),
                            filled: true,
                            fillColor: Constant.secondaryColor,
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Constant.hintText,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                                onTap: () {
                                  nextScreen(
                                      context, const PasswordResetPage());
                                },
                                child: const Text("Forgot Password?"))),
                        const SizedBox(
                          height: 13,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                // primary: Theme.of(context).primaryColor,
                                backgroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16, height: 3),
                            ),
                            onPressed: () {
                              login();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(
                            text: "Don't Have an Account?",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                                text: " Register here",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, const RegisterPage());
                                  },
                              ),
                            ]))
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await authService
          .loginUsingEmailAndPassword(
        email,
        password,
      )
          .then((value) async {
        if (value == true) {
          // Get user data to store User name from Firebase
          QuerySnapshot userData = await DatabaseService().getUserData(email);
          //  Save Data to Shared Prefrences
          await Preferences.saveUserEmailToSf(email);
          await Preferences.saveUserLoggedinStatusToSf(true);
          await Preferences.saveUserNameToSf(userData.docs.first['fullName']);
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackBar(context, value, Colors.red);
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }
}
