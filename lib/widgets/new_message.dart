import 'package:Duet_Classified/screens/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/api_helper.dart';
import '../helpers/current_user.dart';
import '../providers/languages.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  final String fromUserId;

  NewMessage({required this.fromUserId});

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _messageController = TextEditingController();
  bool messageSending = false;

  void _sendMessage(BuildContext ctx) async {
    final apiHelper = Provider.of<APIHelper>(ctx, listen: false);

    // Closes the screen keyboard
    FocusScope.of(context).unfocus();
    // final _userId = FirebaseAuth.instance.currentUser.uid;
    // final _userData =
    //     await FirebaseFirestore.instance.collection('users').doc(_userId).get();
    _messageController.clear();
    // FirebaseFirestore.instance.collection('chat').add({
    //   'text': _enteredMessage,
    //   'createdAt': Timestamp.now(),
    //   'userId': _userId,
    //   // We are getting username and userImage to avoid sending a lot of requests
    //   // to Firebase
    //   'username': _userData['username'],
    //   'userImage': _userData['image_url'],
    // });
    print(_enteredMessage);
    await apiHelper
        .sendChatMessage(
          fromId: CurrentUser.id,
          message: _enteredMessage,
          toId: widget.fromUserId,
        )
        .then((value) => setState(() {
              messageSending = false;
            }))
        .onError((error, stackTrace) => setState(() {
              messageSending = false;
            }));
  }

  // Future builder is like a simple builder, but it needs a future
  // And it's running its builder function after future function is executed

  @override
  Widget build(BuildContext context) {
    final langPack = Provider.of<Languages>(context).selected;
    final hashTags = Provider.of<Languages>(context).messageHashTag;

    return Container(
      padding: EdgeInsets.only(top: 25, bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        color: HexColor(hexColor: "#DDE6ED"),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 80,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                textDirection: CurrentUser.textDirection,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: hashTags.entries.map((entry) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _messageController.text = hashTags[entry.key]!;
                        _enteredMessage = hashTags[entry.key]!;
                        messageSending = true;
                      });
                      if (hashTags[entry.key] != null) _sendMessage(context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                          color: (messageSending == false)
                              ? Colors.white
                              : Colors.grey[400],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 0.6),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        hashTags[entry.key]!,
                        style: TextStyle(
                            fontSize: 14,
                            color: (messageSending == true)
                                ? Colors.black26
                                : Colors.black),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            color: Colors.grey,
            height: 1,
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    autocorrect: true,
                    enableSuggestions: true,
                    enabled: (messageSending) ? false : true,
                    controller: _messageController,
                    cursorColor: Colors.grey[800],
                    textDirection: CurrentUser.textDirection,
                    decoration: InputDecoration(
                      hintTextDirection: CurrentUser.textDirection,
                      hintText: langPack['Enter message'],
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _enteredMessage = value;
                      });
                    },
                  ),
                ),
                (messageSending)
                    ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: HexColor(),
                        ),
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Color(0xFF2E2E3D),
                        ),
                        onPressed: _enteredMessage.trim().isEmpty
                            ? null
                            : () {
                                _sendMessage(context);
                              },
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
