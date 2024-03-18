import 'package:chat_app/auth/services/auth_services.dart';
import 'package:chat_app/auth/services/database_service.dart';
import 'package:chat_app/misc/constant.dart';
import 'package:chat_app/misc/utils.dart';
import 'package:flutter/material.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key});

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  String email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Password Reset",
          style: TextStyle(color: Colors.white, fontSize: 27),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 180,
                  ),
                  Container(
                    child: const Text(
                      "Enter you Registered Email Address , We will send a password reset link to your Email",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      email = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter Email";
                      } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return "Please Enter a Valid Email";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Email",
                      enabled: true,
                      fillColor: Constant.secondaryColor,
                      filled: true,
                      hoverColor: Constant.secondaryColor,
                      contentPadding: EdgeInsets.symmetric(horizontal: 25),
                      hintText: "Enter Your Email",
                      labelStyle: TextStyle(color: Constant.hintText),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Constant.primaryColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Constant.primaryColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Constant.primaryColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      border: const UnderlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                            color: Colors.white, fontSize: 16, height: 3),
                      ),
                      onPressed: () async {
                        // register();
                        await sendPasswordResetLink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  sendPasswordResetLink() async {
    if (formKey.currentState!.validate()) {
      await authService.sendResetPasswordLink(email).then((value) {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: Text(
                  "Password Reset Link Sent to you Mail ID. Please check you Email",
                ),
              );
            });
      });
    }
  }
}
