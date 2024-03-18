import 'package:chat_app/auth/services/auth_services.dart';
import 'package:chat_app/misc/utils.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String userEmail;
  const ProfilePage(
      {super.key, required this.userName, required this.userEmail});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontSize: 27),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          children: [
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[700],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.userName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {
                nextScreen(context, const HomePage());
              },
              selectedColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: Text(
                "Groups",
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ),
            ListTile(
              onTap: () {},
              selectedColor: Colors.white,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: Text(
                "Profile",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              onTap: () async {
                await authService.signOut().whenComplete(() {
                  nextScreenReplace(
                    context,
                    const LoginPage(),
                  );
                });
                Fluttertoast.showToast(
                  msg: "User Logged Out",
                  fontSize: 16.0,
                );
              },
              selectedColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.logout),
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.grey.shade500),
              ),
            )
          ],
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 25),
          child: Column(
            children: [
              Icon(
                Icons.account_circle,
                size: 150,
                color: Colors.grey[700],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Username",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    widget.userName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "User Email",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    widget.userEmail,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
