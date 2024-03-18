import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("user");

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "prodiclePic": "",
      "uid": uid,
    });
  }

  Future getUserData(String email) async {
    QuerySnapshot userData =
        await userCollection.where("email", isEqualTo: email).get();
    return userData;
  }

  Future getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  // Creating a User
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "recentMessage": "",
      "recentMessageSender": "",
    });

    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_${userName}"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(['${groupDocumentReference.id}_${groupName}'])
    });
  }

  getChats(String groupId) async {
    return await groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  getGroupAdmin(String groupId) async {
    DocumentReference docReference = groupCollection.doc(groupId);
    DocumentSnapshot doc = await docReference.get();
    return doc['admin'];
  }

  getGroupMembers(String groupId) async {
    return await groupCollection.doc(groupId).snapshots();
  }

  searchByName(String groupName) {
    // return groupCollection
    //     .orderBy("groupName")
    //     .startAt([groupName]).endAt([groupName + '\uf8ff']);
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_${groupName}")) {
      return true;
    } else {
      return false;
    }
  }

  Future toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_${groupName}")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_${groupName}"])
      });

      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_${userName}"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_${groupName}"])
      });

      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_${userName}"])
      });
    }
  }

  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }
}
