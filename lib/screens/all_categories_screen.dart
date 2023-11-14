import 'package:Duet_Classified/screens/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import './sub_categories_screen.dart';
import '../helpers/current_user.dart';
import '../models/category.dart';
import '../providers/languages.dart';
import '../providers/products.dart';

class AllCategoriesScreen extends StatelessWidget {
  Widget? catIcon;
  static const routeName = '/all-categories';

  @override
  Widget build(BuildContext context) {
    final langPack = Provider.of<Languages>(context).selected;
    final Map pushedArguments =
        ModalRoute.of(context)!.settings.arguments as Map;

    List<Category> allCategories =
        Provider.of<Products>(context).categoriesItems;
    return Scaffold(
      appBar: AppBar(
        leading: (CurrentUser.textDirection == TextDirection.ltr)
            ? IconButton(
                icon: Icon(Iconsax.arrow_left_2),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : SizedBox.shrink(),
        title: Text(
          langPack['Categories']!,
          textDirection: CurrentUser.textDirection,
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
      body: ListView.builder(
        itemCount: allCategories.length,
        itemBuilder: (ctx, i) {
          switch (allCategories[i].id) {
            case '4':
              catIcon = Image.asset('assets/images/house.png');
              break;
            case '1':
              catIcon = Image.asset('assets/images/suv.png');
              break;
            case '9':
              catIcon = Image.asset('assets/images/bycicle.png');
              break;
            case '14':
              catIcon = Image.asset('assets/images/sofa.png');
              break;
            case '2':
              catIcon = Image.asset('assets/images/phone-camera.png');
              break;
            case '3':
              catIcon = Image.asset('assets/images/tv.png');
              break;
            case '11':
              catIcon = Image.asset('assets/images/football.png');
              break;
            case '6':
              catIcon = Image.asset('assets/images/agreement.png');
              break;
            case '10':
              catIcon = Image.asset('assets/images/dog.png');
              break;
            case '7':
              catIcon = Image.asset('assets/images/consult.png');
              break;
            case '12':
              catIcon = Image.asset('assets/images/book.png');
              break;
            case '5':
              catIcon = Image.asset('assets/images/dress.png');
              break;
            default:
              catIcon = Image.asset('assets/images/category.png');
          }
          return Column(
            children: [
              ListTile(
                title: Text(allCategories[i].name),
                leading: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.network(allCategories[i].picture)),
                trailing: allCategories[i].subCategory.length >= 1
                    ? Icon(Icons.arrow_right, color: Colors.grey[800])
                    : null,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    SubCategoriesScreen.routeName,
                    arguments: {
                      'newAd': pushedArguments['newAd'],
                      'editAd': pushedArguments['editAd'],
                      'chosenCat': allCategories[i]
                    },
                  );
                },
              ),
              Divider(
                height: 0,
              ),
            ],
          );
        },
      ),
    );
  }
}
