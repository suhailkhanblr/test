import 'package:Duet_Classified/helpers/current_user.dart';
import 'package:Duet_Classified/providers/languages.dart';
import 'package:Duet_Classified/widgets/loadingpage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../helpers/api_helper.dart';
import '../widgets/grid_products.dart';

class SellerDetailsScreen extends StatelessWidget {
  static const routeName = '/seller-details';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> pushedMap =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final langPack = Provider.of<Languages>(context).selected;

    return Scaffold(
      appBar: AppBar(
        leading: (CurrentUser.textDirection == TextDirection.ltr)
            ? IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.chevron_left,
                  size: 28,
                ))
            : IconButton(
                onPressed: () async {
                  if (CurrentUser.username.isNotEmpty)
                    await Share.share(
                        APIHelper.PROFILE_URL + CurrentUser.username);
                  else
                    Fluttertoast.showToast(
                        msg: "Link Not Found",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.white,
                        backgroundColor: Colors.red,
                        fontSize: 16.0);
                },
                icon: Icon(
                  Icons.share,
                  size: 28,
                )),
        title: Text(
          langPack['Seller Details']!,
          style: TextStyle(
            color: Colors.grey[800],
          ),
        ),
        actions: [
          (CurrentUser.textDirection == TextDirection.rtl)
              ? IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  iconSize: 32,
                  icon: Icon(
                    Icons.chevron_left_rounded,
                  ))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: IconButton(
                      onPressed: () async {
                        if (CurrentUser.username.isNotEmpty)
                          await Share.share(
                              APIHelper.PROFILE_URL + CurrentUser.username);
                        else
                          Fluttertoast.showToast(
                              msg: "Link Not Found",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.white,
                              backgroundColor: Colors.red,
                              fontSize: 16.0);
                      },
                      icon: Icon(
                        Icons.share,
                        size: 26,
                      )),
                ),
        ],
        elevation: 1,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3,
                child: CachedNetworkImage(
                  imageUrl: pushedMap['seller_image'],
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fitWidth,
                        filterQuality: FilterQuality.high,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => LoadingPage(),
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/images/place_holder_image.jpg",
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                pushedMap['seller_name'],
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Joined: ${pushedMap['seller_createdat']}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              Divider(
                height: 20,
              ),
              Text(
                langPack['Posted Products']!,
                style: TextStyle(
                  fontSize: 19,
                ),
              ),
              FutureBuilder(
                  future: Provider.of<APIHelper>(context).fetchProductsForUser(
                    userId: pushedMap['seller_id'],
                    limit: 100,
                    page: 1,
                  ),
                  builder: (ctx, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (snapshot.data.length > 0) {
                      return GridProducts(productsList: snapshot.data);
                    }
                    return Expanded(
                      child: Center(
                        child: Text(langPack[
                            'There are no posted products from this user']!),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
