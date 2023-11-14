import 'dart:io';

import 'package:Duet_Classified/screens/color_helper.dart';
import 'package:Duet_Classified/widgets/loadingpage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import './offer_dialog.dart';
import '../helpers/api_helper.dart';
import '../helpers/app_config.dart';
import '../helpers/current_user.dart';
import '../models/location.dart';
import '../providers/languages.dart';
import '../screens/edit_ad_screen.dart';
import '../screens/payment_methods_screen.dart';
import '../screens/product_details_screen.dart';

class MyProductItem extends StatefulWidget {
  final String id;
  final String name;
  final String picture;
  final String createdAt;
  final String expireAt;
  final String price;
  final String currencySign;
  final String status;
  final String location;
  final String stateId;
  final String cityId;
  final parent;

  MyProductItem({
    required this.stateId,
    required this.cityId,
    required this.parent,
    required this.currencySign,
    required this.location,
    required this.picture,
    required this.id,
    required this.name,
    required this.createdAt,
    required this.expireAt,
    required this.price,
    required this.status,
  });

  @override
  _MyProductItemState createState() => _MyProductItemState();
}

class _MyProductItemState extends State<MyProductItem> {
  late Map<String, String> langPack;

  void onPaymentFailure(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar("Payment Failed"));
  }

  SnackBar snackBar(String text) {
    return SnackBar(
      content: Text(text),
      duration: Duration(seconds: 10),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
  }

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

  Widget continueButton(BuildContext ctx) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.grey[800]!),
      ),
      child: Text(
        langPack['Delete']!,
      ),
      onPressed: () async {
        final response = await Provider.of<APIHelper>(ctx, listen: false)
            .deleteProducts(userId: CurrentUser.id, itemId: widget.id);
        // setState(() {});
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(response['status'] == 'success'
              ? 'Product deleted successfully'
              : 'Some error occured'),
        ));
        widget.parent.setState(() {});
        Navigator.of(ctx).pop();
      },
    );
  }

  Widget _premiumDialog(BuildContext ctx) {
    bool isFeatured = false;
    bool isUrgent = false;
    bool isHighlighted = false;
    int price = 0;
    final apiHelper = Provider.of<APIHelper>(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      backgroundColor: Colors.transparent,
      child: StatefulBuilder(
        builder: (ctx, setState) => Container(
          padding: EdgeInsets.only(
              left: 10,
              top: Constants.padding,
              right: 10,
              bottom: Constants.padding),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            textDirection: CurrentUser.textDirection,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Image.asset(
                  "assets/images/premium.jpg",
                  fit: BoxFit.contain,
                  width: 200,
                  height: 150,
                ),
              ),
              Text(
                langPack['Awesome!! You are just one step away from Premium']!,
                textDirection: CurrentUser.textDirection,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20,
              ),
              //if (isFeatured || isUrgent || isHighlighted)
              Text(
                '${langPack['Total price']} ${AppConfig.currencySign}$price',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: Colors.green,
                ),
              ),
              Divider(
                color: Colors.grey[400],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    textDirection: CurrentUser.textDirection,
                    children: [
                      ListTile(
                        leading: Icon(
                          isFeatured
                              ? Icons.check_circle_outline
                              : Icons.circle_outlined,
                          size: 30,
                          color: Colors.green,
                        ),
                        title: Text(
                          langPack['Featured']!,
                          //+"   " +AppConfig.featuredFee.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                        onTap: () {
                          if (Platform.isIOS) {
                            setState(() {
                              isFeatured = !isFeatured;
                              isUrgent = false;
                              isHighlighted = false;
                              price = int.tryParse(
                                AppConfig.featuredFee!,
                              )!;
                            });
                          } else {
                            setState(() {
                              isFeatured = !isFeatured;
                              if (isFeatured) {
                                price += int.tryParse(AppConfig.featuredFee!)!;
                              } else {
                                price -= int.tryParse(AppConfig.featuredFee!)!;
                              }
                            });
                          }
                        },
                        subtitle: Text(
                          langPack[
                              'Featured ads attract higher-quality viewer and are displayed prominently in the Featured ads section home page']!,
                          textDirection: CurrentUser.textDirection,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          isUrgent
                              ? Icons.check_circle_outline
                              : Icons.circle_outlined,
                          size: 30,
                          color: Colors.green,
                        ),
                        title: Text(
                          langPack['Urgent']!,
                          // langPack['Urgent']! +
                          //     "   " +
                          //     AppConfig.urgentFee.toString(),
                          textDirection: CurrentUser.textDirection,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                        onTap: () {
                          if (Platform.isIOS) {
                            setState(() {
                              isFeatured = false;
                              isUrgent = !isUrgent;
                              isHighlighted = false;
                              price = int.tryParse(AppConfig.urgentFee!)!;
                            });
                          } else {
                            setState(() {
                              isUrgent = !isUrgent;
                              if (isUrgent) {
                                price += int.tryParse(AppConfig.urgentFee!)!;
                              } else {
                                price -= int.tryParse(AppConfig.urgentFee!)!;
                              }
                            });
                          }
                        },
                        subtitle: Text(
                          langPack[
                              'Make your ad stand out and let viewer know that your advertise is time sensitive']!,
                          textDirection: CurrentUser.textDirection,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          isHighlighted
                              ? Icons.check_circle_outline
                              : Icons.circle_outlined,
                          size: 30,
                          color: Colors.green,
                          //color: isHighlighted ? Colors.lightGreen : Colors.amber,
                        ),
                        title: Text(
                          langPack['Highlighted']!,
                          //+"   " + AppConfig.highlightFee.toString(),
                          textDirection: CurrentUser.textDirection,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                        onTap: () {
                          if (Platform.isIOS) {
                            setState(() {
                              isFeatured = false;
                              isUrgent = false;
                              isHighlighted = !isHighlighted;
                              price = int.tryParse(AppConfig.highlightFee!)!;
                            });
                          } else {
                            setState(() {
                              isHighlighted = !isHighlighted;
                              if (isHighlighted) {
                                price += int.tryParse(AppConfig.highlightFee!)!;
                              } else {
                                price -= int.tryParse(AppConfig.highlightFee!)!;
                              }
                            });
                          }
                        },
                        subtitle: Text(
                          langPack[
                              'Make your ad highlighted with border in listing search result page. Easy to focus']!,
                          textDirection: CurrentUser.textDirection,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.grey[400],
              ),
              Row(
                textDirection: CurrentUser.textDirection,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.white,
                      ),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey[800]!),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text(
                      langPack['Cancel']!,
                      textDirection: CurrentUser.textDirection,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF2E2E3D)),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: () async {
                      if (Platform.isIOS) {
                        Navigator.of(ctx).pop();
                        if (isFeatured)
                          await Purchases.purchaseProduct(
                            AppConfig.addFeaturedToAd,
                          ).then((value) async {
                            final entitlements = value
                                .entitlements.active[AppConfig.addFeaturedToAd];
                            if (entitlements != null) {
                              final apiHelper = APIHelper();
                              await apiHelper.postUpgradeAd(
                                widget.name,
                                price,
                                CurrentUser.id,
                                widget.id,
                                isFeatured ? "1" : "0",
                                isUrgent ? "1" : "0",
                                isHighlighted ? "1" : "0",
                                'in-app purchases',
                                "premium",
                                "Premium Ad",
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar("Payment Successful"));
                            } else if (entitlements == null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar("Payment Cancelled"));
                            } else {
                              onPaymentFailure(context);
                            }
                          });
                        if (isUrgent)
                          await Purchases.purchaseProduct(
                            AppConfig.addUrgentToAd,
                          ).then((value) async {
                            final entitlements = value
                                .entitlements.active[AppConfig.addUrgentToAd];
                            if (entitlements != null) {
                              final apiHelper = APIHelper();
                              await apiHelper.postUpgradeAd(
                                widget.name,
                                price,
                                CurrentUser.id,
                                widget.id,
                                isFeatured ? "1" : "0",
                                isUrgent ? "1" : "0",
                                isHighlighted ? "1" : "0",
                                'in-app purchases',
                                "premium",
                                "Premium Ad",
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar("Payment Successful"));
                            } else if (entitlements == null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar("Payment Cancelled"));
                            } else {
                              onPaymentFailure(context);
                            }
                          });
                        if (isHighlighted)
                          await Purchases.purchaseProduct(
                            AppConfig.addHighlightedToAd,
                          ).then((value) async {
                            final entitlements = value.entitlements
                                .active[AppConfig.addHighlightedToAd];
                            if (entitlements != null) {
                              final apiHelper = APIHelper();
                              await apiHelper.postUpgradeAd(
                                widget.name,
                                price,
                                CurrentUser.id,
                                widget.id,
                                isFeatured ? "1" : "0",
                                isUrgent ? "1" : "0",
                                isHighlighted ? "1" : "0",
                                'in-app purchases',
                                "premium",
                                "Premium Ad",
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar("Payment Successful"));
                            } else if (entitlements == null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar("Payment Cancelled"));
                            } else {
                              onPaymentFailure(context);
                            }
                          });
                      } else {
                        Navigator.of(ctx).pop();
                        Navigator.of(context).pushNamed(
                            PaymentMethodsScreen.routeName,
                            arguments: {
                              'id': widget.id,
                              'title': widget.name,
                              'price': price.toString(),
                              'isFeatured': isFeatured,
                              'isUrgent': isUrgent,
                              'isHighlighted': isHighlighted,
                              'isSubscription': false,
                            });
                      }
                    },
                    child: Text(
                      langPack['Confirm']!,
                      textDirection: CurrentUser.textDirection,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    langPack = Provider.of<Languages>(context).selected;
    final unescape = HtmlUnescape();
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetailsScreen.routeName, arguments: {
              'productId': widget.id,
              'productName': widget.name,
              'imageUrl': widget.picture,
              'myAd': true,
            });
          },
          child: Stack(children: [
            AspectRatio(
              aspectRatio: 1.3,
              child: Card(
                elevation: 8,
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.picture,
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
                  errorWidget: (context, url, error) => Center(
                    child: Image.asset(
                      "assets/images/classified_logo.png",
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 3,
                        ),
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.green),
                        child: Text(
                          widget.status.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          // Delete the Ad
                          await showDialog(
                            context: context,
                            builder: (BuildContext ctx) {
                              return AlertDialog(
                                title: Text(langPack['Delete Ad']!),
                                content: Text(langPack[
                                    'Are you sure you want to delete this Ad?']!),
                                actions: [
                                  cancelButton(ctx),
                                  continueButton(ctx),
                                ],
                              );
                            },
                          );
                          // setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(Icons.delete, color: Color(0xFF2E2E3D)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          // Push edit screen
                          await Navigator.of(context)
                              .pushNamed(EditAdScreen.routeName, arguments: {
                            'cityId': widget.cityId,
                            'stateId': widget.stateId,
                            'productData': await Provider.of<APIHelper>(
                              context,
                              listen: false,
                            ).fetchProductsDetails(itemId: widget.id),
                          });
                          CurrentUser.prodLocation = Location();
                          widget.parent.setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(Icons.edit, color: Color(0xFF2E2E3D)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (widget.status == 'active') {
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return _premiumDialog(ctx);
                                });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(Iconsax.crown_1, color: Color(0xFF2E2E3D)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 30, right: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Text(
                            widget.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                        Row(
                          textDirection: CurrentUser.textDirection,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: Colors.white,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width -
                                  MediaQuery.of(context).size.width / 3.5 -
                                  75,
                              child: Text(widget.location,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      widget.createdAt,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 30, bottom: 20),
            child: Text(
              "${langPack['Expires in']!} ${widget.expireAt}",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        )

        // Container(
        //   color: Colors.transparent,
        //   padding: EdgeInsets.only(
        //     top: 15,
        //     left: 15,
        //     right: 15,
        //     bottom: 0,
        //   ),
        //   child: Material(
        //     borderRadius: BorderRadius.circular(5),
        //     elevation: 8,
        //     child: Container(
        //       padding: EdgeInsets.only(
        //         top: 0,
        //         left: 0,
        //         right: 0,
        //         bottom: 0,
        //       ),
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.all(
        //           Radius.circular(5),
        //         ),
        //         gradient: LinearGradient(
        //           stops: [0.02, 0.02],
        //           colors: [
        //             // widget.status == 'active'
        //             ////    ? Color(0xFF2E2E3D)
        //             //    : Colors.grey[800],
        //             HexColor(),
        //             Colors.white
        //           ],
        //         ),
        //         // border: Border(
        //         //   left: BorderSide(
        //         //     width: 4,
        //         //     color: status == 'active' ? Color(0xFF2E2E3D) : Colors.grey[800],
        //         //   ),
        //         // ),
        //       ),
        //       child: Column(
        //         textDirection: CurrentUser.textDirection,
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Container(
        //             padding: EdgeInsets.only(left: 10),
        //             decoration: BoxDecoration(
        //               borderRadius: BorderRadius.all(
        //                 Radius.circular(5),
        //               ),
        //               gradient: LinearGradient(
        //                 stops: [0.02, 0.02],
        //                 colors: [
        //                   // widget.status == 'active'
        //                   //     ? Color(0xFF2E2E3D)
        //                   //     : Colors.grey[800],
        //                   HexColor(),
        //                   Colors.grey[200]!
        //                 ],
        //               ),
        //               // border: Border(
        //               //   left: BorderSide(
        //               //     width: 4,
        //               //     color: status == 'active' ? Color(0xFF2E2E3D) : Colors.grey[800],
        //               //   ),
        //               // ),
        //             ),
        //             // margin: EdgeInsets.only(left: 5),
        //             child: Row(
        //               textDirection: CurrentUser.textDirection,
        //               children: [
        //                 Expanded(
        //                   child: RichText(
        //                     maxLines: 1,
        //                     softWrap: true,
        //                     text: new TextSpan(
        //                       // Note: Styles for TextSpans must be explicitly defined.
        //                       // Child text spans will inherit styles from parent
        //                       style: new TextStyle(
        //                         fontSize: 12.0,
        //                         color: Colors.black,
        //                       ),
        //                       children: <TextSpan>[
        //                         TextSpan(text: 'created: '.toUpperCase()),
        //                         TextSpan(
        //                             text:
        //                                 '${widget.createdAt} - '.toUpperCase(),
        //                             style: new TextStyle(
        //                                 fontWeight: FontWeight.bold)),
        //                         TextSpan(text: 'expire at: '.toUpperCase()),
        //                         TextSpan(
        //                             text: '${widget.expireAt}'.toUpperCase(),
        //                             style: new TextStyle(
        //                                 fontWeight: FontWeight.bold)),
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //                 // Text(
        //                 //     'created: $createdAt - expire at: $expireAt'.toUpperCase()),
        //                 PopupMenuButton(
        //                   itemBuilder: (ctx) {
        //                     final popUpItems = [
        //                       PopupMenuItem(
        //                         child: Text('Edit Ad'),
        //                         value: 0,
        //                       ),
        //                       PopupMenuItem(
        //                         child: Text('Delete Ad'),
        //                         value: 1,
        //                       ),
        //                     ];
        //                     return popUpItems;
        //                   },
        //                   onSelected: (value) async {
        //                     if (value == 0) {
        //                       // Push edit screen
        //                       await Navigator.of(context).pushNamed(
        //                           EditAdScreen.routeName,
        //                           arguments: {
        //                             'cityId': widget.cityId,
        //                             'stateId': widget.stateId,
        //                             'productData': await Provider.of<APIHelper>(
        //                               context,
        //                               listen: false,
        //                             ).fetchProductsDetails(itemId: widget.id),
        //                           });
        //                       CurrentUser.prodLocation = Location();
        //                       widget.parent.setState(() {});
        //                     } else if (value == 1) {
        //                       // Delete the Ad
        //                       await showDialog(
        //                         context: context,
        //                         builder: (BuildContext ctx) {
        //                           return AlertDialog(
        //                             title: Text('Delete Ad'),
        //                             content: Text(
        //                                 'Are you sure you want to delete this Ad ?'),
        //                             actions: [
        //                               cancelButton(ctx),
        //                               continueButton(ctx),
        //                             ],
        //                           );
        //                         },
        //                       );
        //                       // setState(() {});
        //                     }
        //                   },
        //                 ),
        //               ],
        //             ),
        //           ),
        //           Container(
        //             padding: EdgeInsets.only(
        //               left: 10,
        //             ),
        //             child: Column(
        //               textDirection: CurrentUser.textDirection,
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Row(
        //                   textDirection: CurrentUser.textDirection,
        //                   children: [
        //                     Container(
        //                       width: MediaQuery.of(context).size.width / 3.5,
        //                       child: AspectRatio(
        //                         aspectRatio: 1,
        //                         child: Image.network(
        //                           widget.picture,
        //                           fit: BoxFit.cover,
        //                         ),
        //                       ),
        //                     ),
        //                     Container(
        //                       height: MediaQuery.of(context).size.width / 3.5,
        //                       padding: EdgeInsets.all(5),
        //                       child: Column(
        //                         textDirection: CurrentUser.textDirection,
        //                         crossAxisAlignment: CrossAxisAlignment.start,
        //                         children: [
        //                           Container(
        //                             width: MediaQuery.of(context).size.width -
        //                                 MediaQuery.of(context).size.width /
        //                                     3.5 -
        //                                 75,
        //                             child: Text(
        //                               widget.name,
        //                               softWrap: true,
        //                               maxLines: 2,
        //                               style: TextStyle(
        //                                 fontWeight: FontWeight.bold,
        //                                 fontSize: 16,
        //                               ),
        //                             ),
        //                           ),
        //                           Text(
        //                               '${unescape.convert(widget.currencySign)}${widget.price}'),
        //                           Spacer(),
        //                           Row(
        //                             textDirection: CurrentUser.textDirection,
        //                             children: [
        //                               Icon(Icons.location_on_outlined),
        //                               Container(
        //                                 width: MediaQuery.of(context)
        //                                         .size
        //                                         .width -
        //                                     MediaQuery.of(context).size.width /
        //                                         3.5 -
        //                                     75,
        //                                 child: Text(
        //                                   'Location: ${widget.location}',
        //                                   softWrap: false,
        //                                   overflow: TextOverflow.ellipsis,
        //                                   maxLines: 1,
        //                                 ),
        //                               ),
        //                             ],
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //                 Divider(),
        //                 Container(
        //                   padding: EdgeInsets.symmetric(
        //                     horizontal: 20,
        //                     vertical: 3,
        //                   ),
        //                   decoration: BoxDecoration(
        //                       borderRadius:
        //                           BorderRadius.all(Radius.circular(15)),
        //                       //color: widget.status == 'active'
        //                       ////   ? Color(0xFF2E2E3D)
        //                       //  : Colors.grey[800],
        //                       color: HexColor()),
        //                   child: Text(
        //                     widget.status.toUpperCase(),
        //                     style: TextStyle(
        //                       color: Colors.white,
        //                     ),
        //                   ),
        //                 ),
        //                 SizedBox(
        //                   height: 10,
        //                 ),
        //                 Text(
        //                   widget.status == 'active'
        //                       ? 'This ad is currently live'
        //                       : 'This ad was expired. If you sold it, please mark it as sold',
        //                 ),
        //                 Align(
        //                   alignment: Alignment.centerRight,
        //                   child: Padding(
        //                     padding:
        //                         const EdgeInsets.symmetric(horizontal: 8.0),
        //                     child: TextButton(
        //                       style: ButtonStyle(
        //                         shape: MaterialStateProperty.all(
        //                           RoundedRectangleBorder(
        //                             borderRadius: BorderRadius.circular(5),
        //                             side: BorderSide(
        //                               color: Colors.grey[800]!,
        //                               width: 2,
        //                             ),
        //                           ),
        //                         ),
        //                       ),
        //                       child: Text(
        //                         widget.status == 'active'
        //                             ? 'Upgrade as Premium'
        //                             : 'Mark as sold',
        //                         style: TextStyle(color: Colors.grey[800]),
        //                       ),
        //                       onPressed: () {
        //                         if (widget.status == 'active') {
        //                           showDialog(
        //                               context: context,
        //                               builder: (ctx) {
        //                                 return _premiumDialog(ctx);
        //                               });
        //                         }
        //                       },
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
