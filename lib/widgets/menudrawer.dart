import 'package:Duet_Classified/helpers/api_helper.dart';
import 'package:Duet_Classified/helpers/app_config.dart';
import 'package:Duet_Classified/helpers/current_user.dart';
import 'package:Duet_Classified/helpers/db_helper.dart';
import 'package:Duet_Classified/models/menuitem.dart';
import 'package:Duet_Classified/providers/languages.dart';
import 'package:Duet_Classified/screens/expire_ads_screen.dart';
import 'package:Duet_Classified/screens/login_screen.dart';
import 'package:Duet_Classified/screens/membership_plan_screen.dart';
import 'package:Duet_Classified/screens/select_language_screen.dart';
import 'package:Duet_Classified/screens/tabs_screen.dart';
import 'package:Duet_Classified/screens/transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:launch_review/launch_review.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'package:provider/provider.dart';

class MenuDrawer extends StatefulWidget {
  MenuDrawer({Key? key}) : super(key: key);

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  var langPack;

  @override
  Widget build(BuildContext context) {
    langPack = Provider.of<Languages>(context, listen: false).selected;
    List<MenuItem> menuItLst = [
      if (!AppConfig.isPremium!)
        MenuItem(
          name: langPack["Upgrade To Premium"],
          icon: Icon(
            Iconsax.crown_1,
            color: Colors.black,
          ),
          routeName: MembershipPlanScreen.routeName,
        ),
      MenuItem(
          name: langPack["Language"],
          icon: Icon(
            Iconsax.global,
            color: Colors.black,
          ),
          routeName: SelectLanguageScreen.routeName),
      MenuItem(
          name: langPack["Rate Us"],
          icon: Icon(
            Iconsax.heart,
            color: Colors.black,
          ),
          routeName: "rateus"),
      MenuItem(
          name: langPack["Share"],
          icon: Icon(
            Icons.share,
            color: Colors.black,
          ),
          routeName: "share"),
      MenuItem(
          name: langPack["Support"],
          icon: Icon(
            Iconsax.message_question,
            color: Colors.black,
          ),
          routeName: "support"),
      MenuItem(
          name: langPack["Terms & Condition"],
          icon: Icon(
            Iconsax.clipboard_tick,
            color: Colors.black,
          ),
          routeName: "termsconditions"),
      if (CurrentUser.isLoggedIn) ...[
        MenuItem(
            name: langPack["Expired Ads"],
            icon: Icon(
              Iconsax.calendar_remove,
              color: Colors.black,
            ),
            routeName: ExpireAdsScreen.routeName),
        MenuItem(
          name: langPack["Transaction"],
          icon: Icon(
            Iconsax.dollar_circle,
            color: Colors.black,
          ),
          routeName: TransactionsScreen.routeName,
        ),
      ],
      (CurrentUser.isLoggedIn)
          ? MenuItem(
              name: langPack["Log out"],
              icon: Icon(
                Iconsax.logout_1,
                color: Colors.black,
              ),
              routeName: "logout")
          : MenuItem(
              name: langPack["Login"],
              icon: Icon(
                Iconsax.login_1,
                color: Colors.black,
              ),
              routeName: "login"),
    ];
    return Drawer(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: AppBar().preferredSize.height,
          ),
          Center(
              child: (!CurrentUser.isLoggedIn)
                  ? Image.asset(
                      'assets/images/classified_logo.png',
                      width: 100,
                      height: 100,
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        textDirection: CurrentUser.textDirection,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (CurrentUser.isLoggedIn) {
                                final picker = ImagePicker();
                                final imageFile = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (imageFile != null) {
                                  final response = await Provider.of<APIHelper>(
                                          context,
                                          listen: false)
                                      .updateProfilePic(
                                          userId: CurrentUser.id,
                                          imageFile: imageFile);
                                  CurrentUser.picture = response != null
                                      ? response['url']
                                      : CurrentUser.picture;
                                  await DBHelper.insert('user_info', {
                                    'picture': CurrentUser.picture,
                                  });
                                  final picSnackBar = SnackBar(
                                    content: Text(
                                        response['status'] == 'success'
                                            ? 'Image updated successfully'
                                            : 'Some error occurred'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(picSnackBar);
                                  if (response != null &&
                                      response['status'] == 'success') {
                                    setState(() {});
                                  }
                                }
                              }
                            },
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: CurrentUser.picture == ''
                                  ? Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                      size: 70,
                                    )
                                  : CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          NetworkImage(CurrentUser.picture),
                                    ),
                            ),
                          ),
                          Text(
                            CurrentUser.name,
                            textAlign: TextAlign.center,
                            textDirection: CurrentUser.textDirection,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            CurrentUser.email,
                            textAlign: TextAlign.center,
                            textDirection: CurrentUser.textDirection,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )),
          SizedBox(
            height: 10,
          ),
          Divider(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
                children: menuItLst
                    .map((item) => ListTile(
                          leading:
                              (CurrentUser.textDirection == TextDirection.ltr)
                                  ? item.icon
                                  : SizedBox.shrink(),
                          trailing:
                              (CurrentUser.textDirection == TextDirection.rtl)
                                  ? item.icon
                                  : SizedBox.shrink(),
                          title: Text(item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 16)),
                          onTap: () async {
                            switch (item.routeName) {
                              case "logout":
                                showDialog(
                                  context: context,
                                  builder: (BuildContext ctx) {
                                    return AlertDialog(
                                      title: Text(langPack['Log out']!),
                                      content: Text(
                                        langPack[
                                            'Are you sure you want to log out']!,
                                        textDirection:
                                            CurrentUser.textDirection,
                                      ),
                                      actions: [
                                        cancelButton(ctx),
                                        continueButton(ctx),
                                      ],
                                    );
                                  },
                                );
                                break;
                              case "login":
                                {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LoginScreenScreen()),
                                  );
                                }
                                break;
                              case "termsconditions":
                                {
                                  await urlLauncher
                                          .canLaunch(AppConfig.termsPageLink!)
                                      ? await urlLauncher
                                          .launch(AppConfig.termsPageLink!)
                                      : throw 'Could not launch ${AppConfig.termsPageLink}';
                                }
                                break;
                              case "rateus":
                                {
                                  await LaunchReview.launch();
                                }
                                break;
                              case "share":
                                {
                                  await Share.share(
                                      'Download this Amazing application: https://play.google.com/store/apps/details?id=com.duet.classified.androidapp'); // Put Your App Url here.
                                }
                                break;
                              case "support":
                                {
                                  final Uri _emailLaunchUri = Uri(
                                    scheme: 'mailto',
                                    path:
                                        'support@' + APIHelper.BASE_URL, // Put your Support Email Here
                                    queryParameters: {'subject': 'Support'},
                                  );
                                  await urlLauncher
                                          .canLaunch(_emailLaunchUri.toString())
                                      ? await urlLauncher
                                          .launch(_emailLaunchUri.toString())
                                      : throw 'Could not launch ${_emailLaunchUri.toString()}';
                                }
                                break;
                              case SelectLanguageScreen.routeName:
                                {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SelectLanguageScreen()),
                                  );
                                }
                                break;
                              case MembershipPlanScreen.routeName:
                                {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MembershipPlanScreen()),
                                  );
                                }
                                break;
                              case ExpireAdsScreen.routeName:
                                {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ExpireAdsScreen()),
                                  );
                                }
                                break;
                              case TransactionsScreen.routeName:
                                {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TransactionsScreen()),
                                  );
                                }
                                break;
                            }
                          },
                        ))
                    .toList()),
          ),
        ],
      ),
    );
  }

  // set up the buttons
  Widget cancelButton(BuildContext ctx) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.grey[800]!),
      ),
      child: Text(
        langPack['Cancel']!,
        textDirection: CurrentUser.textDirection,
      ),
      onPressed: () {
        Navigator.of(ctx).pop();
      },
    );
  }

  //! this don't delete user it reset password do it until apple approving app
  Widget continueButton(BuildContext ctx) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.red[800]!),
      ),
      child: Text(
        'delete',
        textDirection: CurrentUser.textDirection,
      ),
      onPressed: () async {
        await Provider.of<APIHelper>(ctx, listen: false).logout();
        await FacebookAuth.instance.logOut();
        Phoenix.rebirth(context);
        Navigator.pushNamedAndRemoveUntil(
            ctx, TabsScreen.routeName, (Route<dynamic> route) => false);
      },
    );
  }
}
