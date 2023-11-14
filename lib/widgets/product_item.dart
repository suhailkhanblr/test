import 'package:Duet_Classified/widgets/loadingpage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../helpers/ad_manager.dart';
import '../helpers/api_helper.dart';
import '../helpers/current_user.dart';
import '../helpers/db_helper.dart';
import '../providers/languages.dart';
import '../screens/edit_ad_screen.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatefulWidget {
  final bool isUrgent;
  final bool isFeatured;
  final bool isHighlighted;
  final String imageUrl;
  final String name;
  final double price;
  final String location;
  final String currency;
  final String id;
  final String? status;
  final bool isOnMyAdsScreen;
  final double padding;

  ProductItem({
    this.status,
    this.isFeatured = false,
    this.isUrgent = false,
    this.isHighlighted = false,
    this.isOnMyAdsScreen = false,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.location,
    required this.currency,
    required this.id,
    this.padding = 20,
  });

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool isFavorite = false;

  var langPack;

  Widget cancelButton(BuildContext ctx) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.grey[800]!),
      ),
      child: Text(
        langPack['Cancel'],
        textDirection: CurrentUser.textDirection,
      ),
      onPressed: () {
        Navigator.of(ctx).pop();
      },
    );
  }

  Widget continueButton(BuildContext ctx) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.grey[800]!),
      ),
      child: Text(
        langPack['Delete']!,
      ),
      onPressed: () async {
        await Provider.of<APIHelper>(ctx, listen: false)
            .deleteProducts(userId: CurrentUser.id, itemId: widget.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    langPack = Provider.of<Languages>(context, listen: false).selected;
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: GestureDetector(
        onTap: () {
          print("item id ::: ${widget.id}");
          AdManager.showInterstitialAd();
          Navigator.of(context)
              .pushNamed(ProductDetailsScreen.routeName, arguments: {
            'productId': widget.id,
            'productName': widget.name,
            'imageUrl': widget.imageUrl,
            'myAd': widget.isOnMyAdsScreen,
          });
        },
        child: Stack(children: [
          Card(
            elevation: 8,
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.yellow.shade600,
                  width: widget.isHighlighted ? 3 : 0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: (widget.isFeatured)
                ? Banner(
                    location: BannerLocation.topStart,
                    color: Color(0xFF2E2E3D),
                    textStyle: TextStyle(
                        fontSize: 10,
                        fontFamily: GoogleFonts.poppins().fontFamily),
                    message: 'Featured',
                    child: Container(
                      child: CachedNetworkImage(
                        key: ValueKey(widget.imageUrl),
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
                        placeholder: (context, url) => Image.asset(
                          "assets/images/classified_logo.png",
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/images/place_holder_image.jpg",
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          alignment: Alignment.center,
                        ),
                        imageUrl: widget.imageUrl,
                      ),
                    ),
                  )
                : CachedNetworkImage(
                    key: ValueKey(widget.imageUrl),
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
                    placeholder: (context, url) => Image.asset(
                      "assets/images/classified_logo.png",
                      fit: BoxFit.contain,
                      width: 40,
                      height: 40,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/images/place_holder_image.jpg",
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      alignment: Alignment.center,
                    ),
                    imageUrl: widget.imageUrl,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              textDirection: CurrentUser.textDirection,
              crossAxisAlignment: CurrentUser.language == 'Arabic'
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Row(
                  textDirection: CurrentUser.textDirection,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.only(
                                  top: 0, bottom: 0, left: 10, right: 10)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      onPressed: () {},
                      child: Text(
                        '${widget.currency}${widget.price}',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    FutureBuilder(
                      future: DBHelper.queryFavProduct(
                          DBHelper.favTableName, widget.id),
                      builder: (ctx, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {}
                        if (snapshot.data != null && snapshot.data.length > 0) {
                          isFavorite = true;
                        }
                        return GestureDetector(
                          onTap: () async {
                            if (!isFavorite) {
                              await DBHelper.insertFavProduct(
                                  DBHelper.favTableName, {
                                'id': widget.id,
                                'prodId': widget.id,
                              });
                            } else {
                              await DBHelper.deleteFavProduct(
                                  DBHelper.favTableName, widget.id);
                            }
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite
                                      ? Colors.red
                                      : Colors.grey[800]),
                            ),
                          ),
                        );
                      },
                    ),
                    if (widget.isOnMyAdsScreen)
                      PopupMenuButton(
                        itemBuilder: (ctx) {
                          final popUpItems = [
                            PopupMenuItem(
                              child: Text(langPack['Edit Ad']),
                              value: 0,
                            ),
                            PopupMenuItem(
                              child: Text(langPack['Delete Ad']),
                              value: 1,
                            ),
                          ];
                          return popUpItems;
                        },
                        onSelected: (value) async {
                          if (value == 0) {
                            // Push edit screen
                            Navigator.of(context)
                                .pushNamed(EditAdScreen.routeName, arguments: {
                              'productData': await Provider.of<APIHelper>(
                                context,
                                listen: false,
                              ).fetchProductsDetails(itemId: widget.id),
                            });
                          } else if (value == 1) {
                            // Delete the Ad
                            showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: Text(langPack['Delete Ad']),
                                  content: Text(langPack[
                                      'Are you sure you want to delete this Ad?']),
                                  actions: [
                                    cancelButton(ctx),
                                    continueButton(ctx),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                  ],
                ),

                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.isUrgent)
                      Text('Urgent'.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.yellow.shade600,
                          )),
                    if (widget.isFeatured)
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(!widget.isUrgent ? 7 : 0)),
                        child: Container(
                          padding: EdgeInsets.all(3),
                          color: Colors.yellow.shade600,
                          child: Text('Featured',
                              style: TextStyle(color: Colors.grey[800])),
                        ),
                      ),
                  ],
                ),

                Text(
                  widget.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: new TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                ///location icon and text
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    textDirection: CurrentUser.textDirection,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                      ),
                      Expanded(
                        child: Text(
                          widget.location,
                          textAlign:
                              (CurrentUser.textDirection == TextDirection.ltr)
                                  ? TextAlign.left
                                  : TextAlign.right,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (widget.isOnMyAdsScreen)
            Positioned(
              right: 0,
              top: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.only(topRight: Radius.circular(7)),
                child: Container(
                  padding: EdgeInsets.all(3),
                  color: widget.status == 'active'
                      ? Colors.lightGreen[400]
                      : Colors.red[600],
                  child: Text(widget.status!.toUpperCase(),
                      style: TextStyle(color: Colors.grey[800])),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}
