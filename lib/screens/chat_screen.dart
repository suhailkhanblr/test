import 'package:Duet_Classified/screens/color_helper.dart';
import 'package:flutter/material.dart';

// import 'package:intl/intl.dart' as intl;

import '../widgets/messages.dart';
import '../widgets/new_message.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String fromUserId;

  @override
  Widget build(BuildContext context) {
    final Map pushedMap =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;

    fromUserId = pushedMap['from_user_id'];
    final fromUserName = pushedMap['from_user_fullname'];
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.grey[800], //change your color here
        ),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Colors.black,
            size: 35,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: ListTile(
          leading: (pushedMap['from_user_picture'] == null)
              ? Container(
                  decoration:
                      BoxDecoration(color: Color(0xFF2E2E3D), shape: BoxShape.circle),
                  width: 45,
                  height: 45,
                  child: Center(
                    child: Text(
                        (fromUserName.toString().split('')[0]).toUpperCase(),
                        style: TextStyle(fontSize: 24, color: Colors.white)),
                  ),
                )
              : CircleAvatar(
                  foregroundImage: NetworkImage(pushedMap['from_user_picture']),
                ),
          title: Text(
            fromUserName,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            // textDirection: CurrentUser.textDirection,
          ),
          subtitle: Text(
            (pushedMap['status'] == null) ? "Online" : pushedMap['status'],
            style: TextStyle(fontSize: 12),
          ),
        ),
        backgroundColor: HexColor(hexColor: "#FFFFFF"),
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Messages(
                fromUserId: fromUserId,
              ),
            ),
          ),
          NewMessage(fromUserId: fromUserId),
        ],
      ),
    );
  }
}
