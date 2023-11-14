import 'package:Duet_Classified/helpers/api_helper.dart';
import 'package:Duet_Classified/widgets/loadingpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../helpers/current_user.dart';
import '../providers/languages.dart';

class SelectLanguageScreen extends StatelessWidget {
  static const routeName = '/select-language';

  @override
  Widget build(BuildContext context) {
    final langPack = Provider.of<Languages>(context).selected;
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey[800],
          leading: (CurrentUser.textDirection == TextDirection.ltr)
              ? IconButton(
                  icon: Icon(Iconsax.arrow_left_2),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              : SizedBox.shrink(),
          iconTheme: IconThemeData(
            color: Colors.grey[800],
          ),
          title: Text(
            langPack['Choose your language']!,
            textDirection: CurrentUser.textDirection,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
          actions: [
            (CurrentUser.textDirection == TextDirection.rtl)
                ? IconButton(
                    icon: Icon(Iconsax.arrow_right_3),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                : SizedBox.shrink(),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: FutureBuilder(
                future: Provider.of<APIHelper>(context, listen: false)
                    .fetchLanguagePack(),
                builder: (context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return LoadingPage();
                    default:
                      if (snapshot.hasError) {
                        return Container(
                          child: Text(snapshot.error.toString()),
                        );
                      }
                      print(snapshot.data);
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.689),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) =>
                            GestureDetector(
                          onTap: () {
                            CurrentUser.language =
                                snapshot.data[index].language;
                            //Navigator.of(context).pop();
                            Phoenix.rebirth(context);
                          },
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(45),
                                  child: Image.asset(
                                      (snapshot.data[index].language
                                                  .toString()
                                                  .toLowerCase() ==
                                              "english")
                                          ? 'assets/images/americanflag.png'
                                          : (snapshot.data[index].language
                                                      .toString()
                                                      .toLowerCase() ==
                                                  "french")
                                              ? 'assets/images/franceflag.png'
                                          : (snapshot.data[index].language
                                          .toString()
                                          .toLowerCase() ==
                                          "hindi")
                                          ? 'assets/images/flag-of-india.png'
                                          : 'assets/images/united-arab-emiratesflag.png',
                                      fit: BoxFit.fill),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(snapshot.data[index].language ??
                                  snapshot.data[index].language),
                            ],
                          ),
                        ),
                      );
                  }
                })));
  }
}


//                           GestureDetector(
//                             onTap: () {
//                               CurrentUser.language = 'French';
//                               Navigator.of(context).pop();
//                             },
//                             child: Column(
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(15),
//                                   child: SizedBox.fromSize(
//                                     size: Size.fromRadius(45),
//                                     child: Image.asset(
//                                         'assets/images/franceflag.png',
//                                         fit: BoxFit.fill),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Text('French'),
//                               ],
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               CurrentUser.language = 'Arabic';
//                               Navigator.of(context).pop();
//                             },
//                             child: Column(
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(15),
//                                   child: SizedBox.fromSize(
//                                     size: Size.fromRadius(45),
//                                     child: Image.asset(
//                                         'assets/images/united-arab-emiratesflag.png',
//                                         fit: BoxFit.fill),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Text('Arabic'),
//                               ],
//                             ),
//                           ),
