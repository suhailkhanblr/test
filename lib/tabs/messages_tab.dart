import 'package:Duet_Classified/screens/color_helper.dart';
import 'package:Duet_Classified/widgets/loadingpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/api_helper.dart';
import '../helpers/current_user.dart';
import '../providers/languages.dart';
import '../widgets/chat_tile.dart';

class MessagesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("this page");
    final langPack = Provider.of<Languages>(context).selected;
    return Scaffold(
      appBar: AppBar(
        shape: AppBarBottomShape(),
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
        elevation: 1,
        // leading: IconButton(
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //     },
        //     icon: Icon(
        //       Icons.chevron_left_rounded,
        //       size: 40,
        //     )),
        backgroundColor: HexColor(hexColor: "#FFFFFF"),
        title: Text(
          langPack['Chat']!,
          textDirection: CurrentUser.textDirection,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: CurrentUser.isLoggedIn
          ? FutureBuilder(
              future: Provider.of<APIHelper>(context, listen: false)
                  .fetchGroupChatMessage(sessionUserId: CurrentUser.id),
              builder: (ctx, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  //showing a linear progress indicator in case the data is still loading
                  return LoadingPage();

                if (snapshot.hasError)
                  //showing an error message in case an error occured while fetching the data
                  return Center(
                    child: Text("An error has occured please try again later!"),
                  );
                if (snapshot.hasData) {
                  try {
                    var count = snapshot.data.length;
                    print("count $count");
                    if (count > 0 && snapshot.data[0]['from_user_id'] != null)
                      //showing the available chats
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (ctx, i) {
                          return ChatTile(
                            sellerId:
                                "${snapshot.data[i]['from_user_id'] ?? ''}",
                            //sellerId: "",
                            sellerName: "${snapshot.data[i]['from_fullname']}",
                            pictureUrl:
                                'https://${APIHelper.IMAGE_URL}${snapshot.data[i]['from_user_image']}',
                            status: snapshot.data[i]['status'] == ''
                                ? 'Offline'
                                : 'Online',
                          );
                        },
                      );
                  } catch (e) {
                    return Center(child: Text("No chat available"));
                  }
                }

                //showing a message in case no conversation available
                return Center(child: Text("No chat available"));
              },
            )
          : Center(
              child: Text(
                langPack['You must be logged in to use this feature']!,
                textDirection: CurrentUser.textDirection,
              ),
            ),
    );
  }
}
