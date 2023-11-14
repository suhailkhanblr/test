import 'package:flutter/material.dart';

import '../helpers/current_user.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool seen;
  final String userName;
  final bool isMe;
  final Key key;
  final String chatImageUrl;
  final bool isLast;

  MessageBubble({
    required this.message,
    required this.isMe,
    required this.key,
    required this.userName,
    required this.chatImageUrl,
    required this.seen,
    required this.time,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isMe)
          CircleAvatar(
            backgroundImage: NetworkImage(chatImageUrl),
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: !isMe ? Colors.grey[300] : Color(0xFF2E2E3D),
                  borderRadius: BorderRadius.circular(20)),
              constraints: BoxConstraints(maxWidth: 200),
              margin: EdgeInsets.symmetric(
                vertical: 4,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: Text(
                message,
                textAlign: isMe ? TextAlign.right : TextAlign.left,
                style: TextStyle(
                  color: !isMe ? Colors.black : Colors.white,
                ),
              ),
            ),
            Text(
              time,
              textAlign: isMe ? TextAlign.right : TextAlign.left,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
