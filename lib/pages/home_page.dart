import 'package:chat_app/auth/services/auth_services.dart';
import 'package:chat_app/auth/services/database_service.dart';
import 'package:chat_app/auth/services/preferences.dart';
import 'package:chat_app/misc/constant.dart';
import 'package:chat_app/misc/utils.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/pages/search_page.dart';
import 'package:chat_app/widgets/group_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String email = "";
  String groupName = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool isLoading = false;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    await Preferences.getUserEmail().then((value) {
      setState(() {
        email = value!;
      });
    });

    await Preferences.getUserName().then((value) {
      setState(() {
        userName = value!;
      });
    });

    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

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
          "Groups",
          style: TextStyle(color: Colors.white, fontSize: 27),
        ),
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(context, const SearchPage());
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          )
        ],
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
              userName,
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
              color: Colors.white,
            ),
            ListTile(
              onTap: () {},
              selectedColor: Colors.white,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: Text(
                "Groups",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                nextScreen(
                    context,
                    ProfilePage(
                      userEmail: email,
                      userName: userName,
                    ));
              },
              selectedColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: Text(
                "Profile",
                style: TextStyle(color: Colors.grey.shade500),
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
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          popUpDialog(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Constant.primaryColor,
            elevation: 1,
            title: const Text(
              "Create a Group",
              textAlign: TextAlign.left,
            ),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor),
                        )
                      : TextField(
                          onChanged: (value) {
                            setState(() {
                              groupName = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: "Group Name",
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            border: const UnderlineInputBorder(),
                          ),
                        ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    textStyle: TextStyle(color: Colors.white)),
                child: const Text(
                  "CANCEL",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (groupName != "") {
                    // createGroup()
                    setState(() {
                      isLoading = true;
                    });
                    DatabaseService(
                            uid: FirebaseAuth.instance!.currentUser!.uid)
                        .createGroup(userName,
                            FirebaseAuth.instance!.currentUser!.uid, groupName)
                        .whenComplete(() {
                      isLoading = false;
                    });
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const Text(
                  "CREATE",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          );
        });
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  groupList() {
    return StreamBuilder(
        stream: groups,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['groups'] != null &&
                snapshot.data['groups'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: (context, index) {
                    int reverseIndex =
                        snapshot.data['groups'].length - index - 1;
                    return GroupTile(
                      snapshot.data['fullName'],
                      getName(snapshot.data['groups'][reverseIndex]),
                      getId(
                        snapshot.data['groups'][reverseIndex],
                      ),
                    );
                  });
            } else {
              return zeroStateWidget();
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }
        });
  }

  Widget zeroStateWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                popUpDialog(context);
              },
              icon: Icon(
                Icons.add_circle,
                color: Colors.grey[700],
                size: 75,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "You have not joined any group, Tap add Icon to create a Group or also Search to Join a Group",
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
