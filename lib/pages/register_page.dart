import 'package:chat_app/auth/services/auth_services.dart';
import 'package:chat_app/auth/services/preferences.dart';
import 'package:chat_app/misc/constant.dart';
import 'package:chat_app/misc/utils.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/misc/text_input_decoration.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";

  bool isLoading = false;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.primaryColor,

      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).primaryColor,
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
                          "Create a new Account",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15),
                        ),
                        Icon(
                          Icons.message_rounded,
                          color: Colors.black,
                          size: 250,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(28.0),
                        //   child: Image.asset(
                        //     'assets/Designer.png',
                        //     width: 300,
                        //     height: 150,
                        //   ),
                        // ),
                        TextFormField(
                          onChanged: (value) {
                            fullName = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Name";
                            } else if (value!.length < 2) {
                              return "Please Enter Name with min length 3";
                            }
                            return null;
                          },
                          decoration: textInputDecoration1.copyWith(
                            hoverColor: Constant.secondaryColor,
                            enabled: true,
                            fillColor: Constant.secondaryColor,
                            filled: true,
                            labelStyle: TextStyle(color: Constant.hintText),
                            labelText: "Full Name",
                            prefixIcon: Icon(
                              Icons.person,
                              color: Constant.hintText,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
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
                            enabled: true,
                            hoverColor: Constant.secondaryColor,
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
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                height: 3,
                              ),
                            ),
                            onPressed: () {
                              register();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(
                            text: "Already have an Account?",
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
                                text: " Login here",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, const LoginPage());
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

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(
        fullName,
        email,
        password,
      )
          .then((value) async {
        if (value == true) {
          //  Save Data to Shared Preferences
          await Preferences.saveUserEmailToSf(email);
          await Preferences.saveUserLoggedinStatusToSf(true);
          await Preferences.saveUserNameToSf(fullName);
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
