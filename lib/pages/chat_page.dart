import 'package:chat_app/auth/services/database_service.dart';
import 'package:chat_app/misc/utils.dart';
import 'package:chat_app/pages/group_info.dart';
import 'package:chat_app/widgets/message_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatPage extends StatefulWidget {
  final String userName;
  final String groupName;
  final String groupId;
  ChatPage({
    super.key,
    required this.userName,
    required this.groupName,
    required this.groupId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  final speechToText = SpeechToText();
  String? generatedContent;
  String admin = "";
  Stream<QuerySnapshot>? chats;
  String lastWords = "";

  @override
  void initState() {
    getChatAndAdmin();
    initSpeechToText();

    super.initState();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> initSpeech() async {
    await speechToText.initialize();
    setState(() {});
  }

  // void _startListening() async {
  //   await _speechToText.listen(
  //     onResult: _onSpeechResult,
  //     listenFor: const Duration(seconds: 30),
  //     localeId: "en_En",
  //     cancelOnError: false,
  //     partialResults: false,
  //     listenMode: ListenMode.confirmation,
  //   );
  //   setState(() {});
  // }

  Future<void> startListening() async {
    await speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 30),
      cancelOnError: false,
    );

    setState(() {});
  }

  Future<void> _onSpeechResult(SpeechRecognitionResult result) async {
    setState(() {
      lastWords = result.recognizedWords;
      print(lastWords);
    });
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  @override
  void dispose() {
    speechToText.stop();
    messageController.dispose();
    super.dispose();
  }

  void getChatAndAdmin() {
    DatabaseService().getChats(widget.groupId).then((value) {
      setState(() {
        chats = value;
      });
    });

    DatabaseService().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.groupName,
          style: const TextStyle(color: Colors.white, fontSize: 27),
        ),
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(
                context,
                GroupInfoPage(
                  groupId: widget.groupId,
                  groupName: widget.groupName,
                  adminName: admin,
                  userName: widget.userName,
                ),
              );
            },
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: buildBody(),
      // body: Stack(
      //   children: [
      //     chatMessage(),
      //     Container(
      //       alignment: Alignment.bottomCenter,
      //       width: MediaQuery.of(context).size.width,
      //       child: Container(
      //         width: MediaQuery.of(context).size.width,
      //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      //         color: Colors.grey[700],
      //         child: Row(
      //           children: [
      //             Expanded(
      //               child: TextFormField(
      //                 controller: messageController,
      //                 style: const TextStyle(
      //                   color: Colors.white,
      //                 ),
      //                 decoration: const InputDecoration(
      //                   hintText: "Send a message ...",
      //                   hintStyle: TextStyle(
      //                     color: Colors.white,
      //                     fontSize: 16,
      //                   ),
      //                   border: InputBorder.none,
      //                 ),
      //               ),
      //             ),
      //             const SizedBox(
      //               width: 12,
      //             ),
      //             GestureDetector(
      //               onTap: () {
      //                 sendMessage();
      //               },
      //               child: Container(
      //                 width: 50,
      //                 height: 50,
      //                 // color: Theme.of(context).primaryColor,
      //                 child: const Icon(Icons.send),
      //                 decoration: BoxDecoration(
      //                     borderRadius: BorderRadius.circular(30),
      //                     color: Theme.of(context).primaryColor),
      //               ),
      //             ),
      //             SizedBox(
      //               width: 10,
      //             ),
      //             GestureDetector(
      //               onTap: () async {
      //                 if (await speechToText.hasPermission &&
      //                     speechToText.isNotListening) {
      //                   await startListening();
      //                 } else if (speechToText.isListening) {
      //                   print("************** $lastWords");
      //                   setState(() {
      //                     messageController.text = lastWords;
      //                   });
      //                   await stopListening();
      //                 } else {
      //                   initSpeechToText();
      //                 }
      //               },
      //               child: Container(
      //                 width: 50,
      //                 height: 50,
      //                 // color: Theme.of(context).primaryColor,
      //                 child: Icon(
      //                     speechToText.isListening ? Icons.stop : Icons.mic),
      //                 decoration: BoxDecoration(
      //                     borderRadius: BorderRadius.circular(30),
      //                     color: Theme.of(context).primaryColor),
      //               ),
      //             )
      //           ],
      //         ),
      //       ),
      //     )
      //   ],
      // ),
    );
  }

  buildBody() {
    return Column(
      children: [
        chatMessage(),
        Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            color: Colors.grey[700],
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Send a message ...",
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    // color: Theme.of(context).primaryColor,
                    child: const Icon(Icons.send),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    if (await speechToText.hasPermission &&
                        speechToText.isNotListening) {
                      await startListening();
                    } else if (speechToText.isListening) {
                      print("************** $lastWords");
                      setState(() {
                        messageController.text = lastWords;
                      });
                      await stopListening();
                    } else {
                      initSpeechToText();
                    }
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    // color: Theme.of(context).primaryColor,
                    child:
                        Icon(speechToText.isListening ? Icons.stop : Icons.mic),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Theme.of(context).primaryColor),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessage = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now()
      };
      DatabaseService().sendMessage(widget.groupId, chatMessage);
      setState(() {
        messageController.clear();
      });
    }
  }

  chatMessage() {
    return Expanded(
      child: StreamBuilder(
          stream: chats,
          builder: (context, AsyncSnapshot snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      print("herere");
                      // print(snapshot.data.[index]['time']);
                      // print(DateTime.parse(
                      //     snapshot.data.docs[index]['time'].toDate().toString()));
                      DateTime myDateTime =
                          (snapshot.data.docs[index]['time']).toDate();
                      // String t = DateFor.yMMMd().add_jm().format(myDateTime);
                      String formattedDateTime =
                          DateFormat('yyyy-MM-dd – kk:mm').format(myDateTime);

                      print(myDateTime);

                      return MessageTile(
                        message: snapshot.data.docs[index]['message'],
                        sender: snapshot.data.docs[index]['sender'],
                        sendByMe: widget.userName ==
                            snapshot.data.docs[index]['sender'],
                        dateTime: formattedDateTime,
                      );
                    })
                : Container();
          }),
    );
  }
}
