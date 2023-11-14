import 'package:Duet_Classified/screens/color_helper.dart';
import 'package:Duet_Classified/widgets/loadingpage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import './edit_ad_screen.dart';
import './new_ad_screen.dart';
import './products_by_category_screen.dart';
import '../helpers/current_user.dart';
import '../providers/languages.dart';

class SubCategoriesScreen extends StatelessWidget {
  static const routeName = '/subcategories';

  @override
  Widget build(BuildContext context) {
    final langPack = Provider.of<Languages>(context).selected;
    Map pushedArguments = ModalRoute.of(context)!.settings.arguments as Map;
    //print(pushedArguments);
    //print(subCategories);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          langPack['Select sub category']!,
          textDirection: CurrentUser.textDirection,
          // pushedArguments['chosenCat'].name,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: HexColor(),
        foregroundColor: Colors.grey[800],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        leading: (CurrentUser.textDirection == TextDirection.ltr)
            ? IconButton(
                icon: Icon(Iconsax.arrow_left_2),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : SizedBox.shrink(),
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
      body: Column(
        children: [
          if (!pushedArguments['newAd'])
            ListTile(
              title: Text(
                langPack['Show']! + ' ' + langPack['All']!,
                textDirection: CurrentUser.textDirection,
              ),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(ProductsByCategoryScreen.routeName, arguments: {
                  'chosenCat': pushedArguments['chosenCat'],
                  'chosenSubCat': '',
                });
              },
            ),
          Expanded(
              child: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            padding: EdgeInsets.all(10),
            shrinkWrap: true,
            itemBuilder: (_, i) => GestureDetector(
              onTap: () {
                if (pushedArguments['newAd']) {
                  Navigator.of(context)
                      .pushNamed(NewAdScreen.routeName, arguments: {
                    'chosenCat': pushedArguments['chosenCat'],
                    'chosenSubCat': pushedArguments['chosenCat'].subCategory[i],
                  });
                } else if (pushedArguments['editAd']) {
                  Navigator.of(context)
                      .pushNamed(EditAdScreen.routeName, arguments: {
                    'chosenCat': pushedArguments['chosenCat'],
                    'chosenSubCat': pushedArguments['chosenCat'].subCategory[i],
                  });
                } else {
                  Navigator.of(context).pushNamed(
                      ProductsByCategoryScreen.routeName,
                      arguments: {
                        'chosenCat': pushedArguments['chosenCat'],
                        'chosenSubCat':
                            pushedArguments['chosenCat'].subCategory[i],
                      });
                }
              },
              child: Container(
                margin: EdgeInsets.only(left: 5, bottom: 20, right: 5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 0.4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (pushedArguments['chosenCat'].subCategory[i].picture ==
                            null)
                        ? Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/classified_logo.png"),
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high,
                                alignment: Alignment.center,
                              ),
                            ),
                          )
                        : CachedNetworkImage(
                            width: 50,
                            height: 50,
                            imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.high,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                            placeholder: (context, url) => LoadingPage(),
                            errorWidget: (context, url, error) => Image.asset(
                                  "assets/images/classified_logo.png",
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.high,
                                  alignment: Alignment.center,
                                ),
                            imageUrl: pushedArguments['chosenCat']
                                .subCategory[i]
                                .picture),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          pushedArguments['chosenCat'].subCategory[i].name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )),
                  ],
                ),
              ),
            ),
            itemCount: pushedArguments['chosenCat'].subCategory.length,
          )

              // ListView.builder(
              //   itemCount: pushedArguments['chosenCat'].subCategory.length,
              //   itemBuilder: (ctx, i) {
              //     return ListTile(
              //       onTap: () {
              //         if (pushedArguments['newAd']) {
              //           Navigator.of(context)
              //               .pushNamed(NewAdScreen.routeName, arguments: {
              //             'chosenCat': pushedArguments['chosenCat'],
              //             'chosenSubCat':
              //                 pushedArguments['chosenCat'].subCategory[i],
              //           });
              //         } else if (pushedArguments['editAd']) {
              //           Navigator.of(context)
              //               .pushNamed(EditAdScreen.routeName, arguments: {
              //             'chosenCat': pushedArguments['chosenCat'],
              //             'chosenSubCat':
              //                 pushedArguments['chosenCat'].subCategory[i],
              //           });
              //         } else {
              //           Navigator.of(context).pushNamed(
              //               ProductsByCategoryScreen.routeName,
              //               arguments: {
              //                 'chosenCat': pushedArguments['chosenCat'],
              //                 'chosenSubCat':
              //                     pushedArguments['chosenCat'].subCategory[i],
              //               });
              //         }
              //       },
              //       leading:
              //           pushedArguments['chosenCat'].subCategory[i].picture !=
              //                   null
              //               ? Padding(
              //                   padding: const EdgeInsets.all(5.0),
              //                   child: Image.network(pushedArguments['chosenCat']
              //                       .subCategory[i]
              //                       .picture),
              //                 )
              //               : null,
              //       title: Text(pushedArguments['chosenCat'].subCategory[i].name),
              //     );
              //   },
              // ),

              ),
        ],
      ),
    );
  }
}
