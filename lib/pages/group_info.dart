import 'package:chat_app/auth/services/database_service.dart';
import 'package:chat_app/misc/utils.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/widgets/group_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../misc/constant.dart';

class GroupInfoPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  final String userName;
  const GroupInfoPage({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.adminName,
    required this.userName,
  });

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  Stream? members;
  @override
  void initState() {
    getMembers();
    super.initState();
  }

  void getMembers() {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((value) {
      print(value);
      print("tarun");
      setState(() {
        members = value;
      });
    });
  }

  getName(String res) {
    print(res);
    return res.substring(res.indexOf('_') + 1);
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "Yes",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
      ),
      onPressed: () async {
        await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .toggleGroupJoin(
          widget.groupId,
          widget.userName,
          getName(widget.groupName),
        )
            .whenComplete(() {
          nextScreenReplace(context, const HomePage());
        });
      },
    );
    Widget continueButton = TextButton(
      child: const Text(
        "No",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    return AlertDialog(
      backgroundColor: Constant.primaryColor,
      title: const Text("Exit "),
      content: const Text("Are you sure you want to Exit the Group?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Group Info",
            style: TextStyle(color: Colors.white, fontSize: 27),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return showAlertDialog(context);
                  },
                );
              },
              icon: const Icon(Icons.exit_to_app_sharp),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).primaryColor.withOpacity(0.6),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        widget.groupName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Group: ${widget.groupName}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Admin: ${getName(widget.adminName)}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              membersList(),
            ],
          ),
        ));
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  membersList() {
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['members'] != null &&
                snapshot.data['members'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['members'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    // int reverseIndex =
                    //     snapshot.data['members'].length - index - 1;
                    var data = snapshot.data['members'][index];
                    return Container(
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            getName(data).substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                        title: Text(
                          getName(data),
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(
                child: Text(
                  "NO MEMBERS",
                ),
              );
              // return zeroStateWidget();
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
}
