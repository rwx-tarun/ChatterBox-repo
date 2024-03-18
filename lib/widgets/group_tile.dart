import 'package:chat_app/misc/utils.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupName;
  final String groupId;

  const GroupTile(this.userName, this.groupName, this.groupId, {super.key});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
          context,
          ChatPage(
            userName: widget.userName,
            groupId: widget.groupId,
            groupName: widget.groupName,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.black,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
          title: Text(
            widget.groupName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            "Join the conversation as ${widget.userName}",
          ),
        ),
      ),
    );
  }
}
