import 'dart:async';

import 'package:Duet_Classified/screens/color_helper.dart';
import 'package:Duet_Classified/widgets/loadingpage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:iconsax/iconsax.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

import './chat_screen.dart';
import './payment_methods_screen.dart';
import './seller_details_screen.dart';
import './start_screen.dart';
import '../helpers/ad_manager.dart';
import '../helpers/api_helper.dart';
import '../helpers/app_config.dart';
import '../helpers/current_user.dart';
import '../helpers/db_helper.dart';
import '../providers/languages.dart';
import '../widgets/offer_dialog.dart';
import '../widgets/product_item.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const routeName = '/item-details';

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final unescape = HtmlUnescape();

  late StreamSubscription _subscription;
  double _height = 0;

  // final _adUnitId = 'ca-app-pub-9259101471660565/8555196884';
  final _adUnitId = 'ca-app-pub-3940256099942544/8135179316';
  int _pickedImageIndex = 0;
  Completer<GoogleMapController> _controller = Completer();
  final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  bool isLoaded = false;
  bool hidePhone = true;
  String phoneNumber = '';

  String adUserId = '';

  String adUserFullName = '';
  bool isFavorite = false;

  List<String> imagesList = [];

  bool myAd = false;
  String id = '';
  String title = '';
  String pageLink = '';

  var langPack;

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body?.text).documentElement!.text;

    return parsedString;
  }

  Widget _getAdContainer() {
    //! # native_admob_flutter: ^1.5.0+1 deprecated
    // return AppConfig.googleBannerOn
    //     ? Container(
    //   child: controller.isLoaded
    //       ? AdManager.nativeAdsView()
    //       : Container(
    //     child: Text("Banner"),
    //   ),
    // )
    return AppConfig.googleBannerOn
        ? Container(
            child: Text("Banner"),
          )
        : Container(
            alignment: Alignment(0.5, 1),
            child: FacebookNativeAd(
              //need a new placement id for advanced native ads
              placementId: AdManager.fbNativePlacementId,
              adType: NativeAdType.NATIVE_AD,
              listener: (result, value) {
                print("Native Banner Ad: $result --> $value");
              },
            ),
          );
  }

  Widget _premiumDialog(BuildContext ctx) {
    bool isFeatured = false;
    bool isUrgent = false;
    bool isHighlighted = false;
    int price = 0;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
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
            mainAxisSize: MainAxisSize.min,
            textDirection: CurrentUser.textDirection,
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
              if (isFeatured || isUrgent || isHighlighted)
                Text(
                  '${langPack['Total price']} ${AppConfig.currencySign}$price',
                  textDirection: CurrentUser.textDirection,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
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
                          langPack['Featured'],
                          textDirection: CurrentUser.textDirection,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            isFeatured = !isFeatured;
                            if (isFeatured) {
                              price += 5;
                            } else {
                              price -= 5;
                            }
                          });
                        },
                        subtitle: Text(
                          langPack[
                              'Featured ads attract higher-quality viewer and are displayed prominently in the Featured ads section home page'],
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
                          langPack['Urgent'],
                          textDirection: CurrentUser.textDirection,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            isUrgent = !isUrgent;
                            if (isUrgent) {
                              price += 5;
                            } else {
                              price -= 5;
                            }
                          });
                        },
                        subtitle: Text(
                          langPack[
                              'Make your ad stand out and let viewer know that your advertise is time sensitive'],
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
                        ),
                        title: Text(
                          langPack['Highlighted'],
                          textDirection: CurrentUser.textDirection,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            isHighlighted = !isHighlighted;
                            if (isHighlighted) {
                              price += 5;
                            } else {
                              price -= 5;
                            }
                          });
                        },
                        subtitle: Text(
                          langPack[
                              'Make your ad highlighted with border in listing search result page. Easy to focus'],
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
              SizedBox(
                height: 22,
              ),
              Row(
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
                      langPack['Cancel'],
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
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pushNamed(
                          PaymentMethodsScreen.routeName,
                          arguments: {
                            'id': id,
                            'title': title,
                            'price': price.toString(),
                            'isFeatured': isFeatured,
                            'isUrgent': isUrgent,
                            'isHighlighted': isHighlighted,
                            'isSubscription': false,
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        langPack['Confirm'],
                        textDirection: CurrentUser.textDirection,
                        style: TextStyle(fontSize: 18),
                      ),
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

  // set up the buttons
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
        langPack['Login'],
        textDirection: CurrentUser.textDirection,
      ),
      onPressed: () async {
        Navigator.of(context).pushNamed(StartScreen.routeName);
      },
    );
  }

  //! # native_admob_flutter: ^1.5.0+1 deprecated
  // final controller = NativeAdController();

  // @override
  // void dispose() {
  //   if (AppConfig.googleBannerOn) controller.dispose();
  //   super.dispose();
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   if (AppConfig.googleBannerOn) {
  //     controller.load(keywords: ['valorant', 'games', 'fortnite']);
  //     controller.onEvent.listen((event) {
  //       // if (event.keys.first == NativeAdEvent.loaded) {
  //       //   setState(() {});
  //       // }

  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    langPack = Provider.of<Languages>(context).selected;
    final Map<String, dynamic> pushedMap =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    myAd = pushedMap['myAd'] == true ? true : false;

    id = pushedMap['productId'];
    title = pushedMap['productName'];

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: Provider.of<APIHelper>(context).fetchProductsDetails(
                itemId: pushedMap['productId'],
              ),
              builder: (ctx, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return LoadingPage();
                  default:
                    if (snapshot.hasError) {
                      return Container(
                        child: Center(
                          child: Text(snapshot.error.toString()),
                        ),
                      );
                    }
                    if (snapshot.data.length > 0) {
                      print("ProductDetails snapshot: ${snapshot.data}");
                      myAd = snapshot.data['seller_id'] == CurrentUser.id;
                      adUserFullName = snapshot.data['seller_name'];
                      adUserId = snapshot.data['seller_id'];
                      isLoaded = true;
                      hidePhone =
                          snapshot.data['hide_phone'] == 'yes' ? true : false;
                      pageLink = snapshot.data['page_link'];
                      phoneNumber = snapshot.data['phone'];
                      print(snapshot.data);
                      print(snapshot.data['images'].runtimeType);
                      print(snapshot.data['original_images_path'].runtimeType);
                      return Scaffold(
                          body: ListView(
                            shrinkWrap: true,
                            children: [
                              CarouselSlider(
                                items: snapshot.data['images']
                                    .toList()
                                    .map<Widget>((imageUrl) {
                                  imagesList.add(snapshot
                                          .data['original_images_path']
                                          .toString() +
                                      imageUrl.toString());
                                  return GestureDetector(
                                    onTap: () {
                                      final _pageController = PageController(
                                          initialPage: imagesList.indexOf(
                                              snapshot.data[
                                                          'original_images_path']
                                                      .toString() +
                                                  imageUrl.toString()));
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) => Scaffold(
                                            body: Container(
                                              child: PhotoViewGallery.builder(
                                                scrollPhysics:
                                                    const BouncingScrollPhysics(),
                                                builder: (BuildContext context,
                                                    int index) {
                                                  _pickedImageIndex = index;
                                                  return PhotoViewGalleryPageOptions(
                                                    imageProvider: NetworkImage(
                                                        imagesList[index]),
                                                    initialScale:
                                                        PhotoViewComputedScale
                                                                .contained *
                                                            0.8,
                                                    heroAttributes:
                                                        PhotoViewHeroAttributes(
                                                            tag: index),
                                                  );
                                                },
                                                itemCount: imagesList.length,
                                                loadingBuilder: (_, event) =>
                                                    Center(
                                                  child: Container(
                                                    width: 20.0,
                                                    height: 20.0,
                                                    child: Container(
                                                      width: 100,
                                                      child:
                                                          LinearProgressIndicator(
                                                        backgroundColor:
                                                            Colors.grey,
                                                        // color: Colors.black,
                                                        value: event == null
                                                            ? 0
                                                            : event.cumulativeBytesLoaded /
                                                                event
                                                                    .expectedTotalBytes!,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                backgroundDecoration:
                                                    BoxDecoration(
                                                  color: Colors.black,
                                                ),
                                                pageController: _pageController,
                                                onPageChanged: (index) {},
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Card(
                                            elevation: 8,
                                            semanticContainer: true,
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            shadowColor: Colors.black12,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: snapshot.data[
                                                          'original_images_path']
                                                      .toString() +
                                                  imageUrl.toString(),
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                    filterQuality:
                                                        FilterQuality.high,
                                                    alignment: Alignment.center,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  LoadingPage(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Image.asset(
                                                "assets/images/place_holder_image.jpg",
                                                fit: BoxFit.cover,
                                                filterQuality:
                                                    FilterQuality.high,
                                                alignment: Alignment.center,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                    vertical: 10),
                                                child: Row(
                                                  textDirection:
                                                      CurrentUser.textDirection,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5),
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                              spreadRadius: 1,
                                                              blurRadius: 2,
                                                              offset:
                                                                  Offset(0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Icon(
                                                            Icons
                                                                .chevron_left_rounded,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      style: ButtonStyle(
                                                          padding:
                                                              MaterialStateProperty.all(
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 20,
                                                                      right:
                                                                          20)),
                                                          shape: MaterialStateProperty
                                                              .all<
                                                                  RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .white)),
                                                      onPressed: () {},
                                                      child: Text(
                                                        unescape.convert(
                                                              snapshot.data[
                                                                      'currency'] ??
                                                                  "₹",
                                                            ) +
                                                            snapshot
                                                                .data['price'],
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    (!myAd)
                                                        ? FutureBuilder(
                                                            future: DBHelper
                                                                .queryFavProduct(
                                                                    'favourite_products',
                                                                    pushedMap[
                                                                        'productId']),
                                                            builder: (ctx,
                                                                AsyncSnapshot
                                                                    snapshot) {
                                                              if (snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .waiting) {}
                                                              if (snapshot.data !=
                                                                      null &&
                                                                  snapshot.data
                                                                          .length >
                                                                      0) {
                                                                isFavorite =
                                                                    true;
                                                              }
                                                              return StatefulBuilder(
                                                                  builder: (_,
                                                                      setSt) {
                                                                return GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    if (!isFavorite) {
                                                                      await DBHelper.insertFavProduct(
                                                                          DBHelper
                                                                              .favTableName,
                                                                          {
                                                                            'id':
                                                                                pushedMap['productId'],
                                                                            'prodId':
                                                                                pushedMap['productId'],
                                                                          });
                                                                    } else {
                                                                      await DBHelper.deleteFavProduct(
                                                                          'favourite_products',
                                                                          pushedMap[
                                                                              'productId']);
                                                                    }
                                                                    setSt(() {
                                                                      isFavorite =
                                                                          !isFavorite;
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(5),
                                                                    margin: EdgeInsets
                                                                        .symmetric(
                                                                            horizontal:
                                                                                5),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Colors
                                                                          .white,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.5),
                                                                          spreadRadius:
                                                                              1,
                                                                          blurRadius:
                                                                              2,
                                                                          offset: Offset(
                                                                              0,
                                                                              2),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    child: Icon(
                                                                        isFavorite
                                                                            ? Icons
                                                                                .favorite
                                                                            : Icons
                                                                                .favorite_border,
                                                                        color: isFavorite
                                                                            ? Colors.red
                                                                            : Colors.grey[800]),
                                                                  ),
                                                                );
                                                              });
                                                            },
                                                          )
                                                        : SizedBox(
                                                            width: 10,
                                                          )
                                                  ],
                                                )),
                                          ),
                                          Align(
                                            alignment:
                                                (CurrentUser.textDirection ==
                                                        TextDirection.ltr)
                                                    ? Alignment.bottomRight
                                                    : Alignment.bottomLeft,
                                            child: Padding(
                                              padding:
                                                  (CurrentUser.textDirection ==
                                                          TextDirection.ltr)
                                                      ? const EdgeInsets.only(
                                                          bottom: 20, right: 40)
                                                      : const EdgeInsets.only(
                                                          bottom: 20, left: 20),
                                              child: Text(
                                                snapshot.data['created_at'],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          )
                                        ]),
                                  );
                                }).toList(),
                                options: CarouselOptions(
                                    viewportFraction: 1,
                                    enlargeCenterPage: true),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      textDirection: CurrentUser.textDirection,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data['title'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 19,
                                                ),
                                              ),
                                              Row(
                                                textDirection:
                                                    CurrentUser.textDirection,
                                                children: [
                                                  Icon(
                                                    Icons.location_on_outlined,
                                                    color: Colors.grey[700],
                                                  ),
                                                  Text(
                                                      "${snapshot.data['city']},${snapshot.data['state']},${snapshot.data['country']}",
                                                      softWrap: false,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: Colors.grey[700],
                                                      )),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: GestureDetector(
                                            onTap: () async {
                                              if (pageLink.isNotEmpty)
                                                await Share.share(pageLink);
                                              else
                                                Fluttertoast.showToast(
                                                    msg: "Link Not Found",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 1,
                                                    textColor: Colors.white,
                                                    backgroundColor: Colors.red,
                                                    fontSize: 16.0);
                                            },
                                            child: Icon(
                                              Icons.share,
                                              size: 30,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            SellerDetailsScreen.routeName,
                                            arguments: {
                                              'seller_id':
                                                  snapshot.data['seller_id'],
                                              'seller_name':
                                                  snapshot.data['seller_name'],
                                              'seller_image':
                                              APIHelper.BASE_URL + '/media_storage/profile/' +
                                                      snapshot
                                                          .data['seller_image'],
                                              'seller_createdat': snapshot
                                                  .data['seller_createdat'],
                                              'product_url':
                                                  snapshot.data['product_url']
                                            });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 20),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.grey[400]!)),
                                        child: ListTile(
                                            leading:
                                                (CurrentUser.textDirection ==
                                                        TextDirection.ltr)
                                                    ? CircleAvatar(
                                                        radius: 35,
                                                        foregroundImage: NetworkImage(
                                                            APIHelper.BASE_URL + '/media_storage/profile/' +
                                                                snapshot.data[
                                                                    'seller_image']),
                                                      )
                                                    : Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              langPack[
                                                                  "View Profile"],
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      HexColor())),
                                                        ],
                                                      ),
                                            trailing:
                                                (CurrentUser.textDirection ==
                                                        TextDirection.ltr)
                                                    ? Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              langPack[
                                                                  "View Profile"],
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      HexColor())),
                                                        ],
                                                      )
                                                    : CircleAvatar(
                                                        radius: 35,
                                                        foregroundImage: NetworkImage(
                                                            APIHelper.BASE_URL + '/media_storage/profile/' +
                                                                snapshot.data[
                                                                    'seller_image']),
                                                      ),
                                            title: Text(
                                              snapshot.data['seller_name'],
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF2E2E3D)),
                                            ),
                                            // subtitle: Text('Member since: ' +
                                            //     "${snapshot.data['seller_createdat']}"),
                                            subtitle: (snapshot
                                                        .data['hide_phone'] !=
                                                    'yes')
                                                ? Text(
                                                    "${snapshot.data['phone']}")
                                                : Text(
                                                    "Phone number unavailable")),
                                      ),
                                    ),
                                    Text(
                                      langPack['Description'],
                                      textDirection: CurrentUser.textDirection,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        _parseHtmlString(
                                            snapshot.data['description']),
                                        style:
                                            TextStyle(color: Colors.grey[500])),
                                    Divider(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          langPack['Property status'],
                                          textDirection:
                                              CurrentUser.textDirection,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[500]),
                                        ),
                                        Spacer(),
                                        Text("${snapshot.data['status']}"),
                                      ],
                                    ),
                                    Divider(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          langPack['Email'],
                                          textDirection:
                                              CurrentUser.textDirection,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[500]),
                                        ),
                                        Spacer(),
                                        Text(
                                            "${snapshot.data['seller_email']}"),
                                      ],
                                    ),
                                    Divider(
                                      height: 20,
                                    ),
                                    ListView.builder(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2),
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      itemCount:
                                          snapshot.data['custom_data'].length,
                                      itemBuilder: (ctx, i) {
                                        final exp = RegExp('\\*');
                                        return Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  snapshot.data['custom_data']
                                                          [i]['title']
                                                      .replaceAll(exp, ''),
                                                  textDirection:
                                                      CurrentUser.textDirection,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[500]),
                                                ),
                                                Spacer(),
                                                Text(
                                                    snapshot.data['custom_data']
                                                            [i]['value'] ??
                                                        'Has no value'),
                                              ],
                                            ),
                                            Divider(
                                              height: 20,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    _getAdContainer(),

                                    //currency and created date
                                    // Row(
                                    //   children: [
                                    //     Column(
                                    //       children: [
                                    //         Text(
                                    //           snapshot.data['price'] +
                                    //               unescape.convert(
                                    //                 snapshot.data['currency'] ?? "₹",
                                    //               ),
                                    //           style: TextStyle(
                                    //             fontWeight: FontWeight.bold,
                                    //             fontSize: 19,
                                    //           ),
                                    //         ),
                                    //         SizedBox(
                                    //           height: 8,
                                    //         ),
                                    //         Text(
                                    //           'Ad Views - ' + snapshot.data['view'],
                                    //           style: TextStyle(
                                    //             fontWeight: FontWeight.bold,
                                    //             fontSize: 14,
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //     Spacer(),
                                    //     Text(
                                    //       snapshot.data['created_at'],
                                    //       style: TextStyle(
                                    //         color: Colors.grey,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),

                                    // remove code
                                    // Divider(
                                    //   height: 20,
                                    // ),
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       langPack['Posted By'],
                                    //       style: TextStyle(
                                    //         fontSize: 18,
                                    //       ),
                                    //     ),
                                    //     Spacer(),
                                    //     TextButton(
                                    //         style: ButtonStyle(
                                    //             foregroundColor:
                                    //                 MaterialStateProperty.all<Color>(
                                    //                     Colors.grey[800])),
                                    //         onPressed: () {
                                    //           Navigator.of(context).pushNamed(
                                    //               SellerDetailsScreen.routeName,
                                    //               arguments: {
                                    //                 'seller_name':
                                    //                     snapshot.data['seller_name'],
                                    //                 'seller_image':
                                    //                     APIHelper.BASE_URL + '/media_storage/profile/' +
                                    //                         snapshot.data['seller_image'],
                                    //                 'seller_createdat':
                                    //                     snapshot.data['seller_createdat'],
                                    //               });
                                    //         },
                                    //         child: Text(snapshot.data['seller_name'])),
                                    //   ],
                                    // ),

                                    Divider(
                                      height: 20,
                                    ),
                                    Text(
                                      langPack['Location'],
                                      textDirection: CurrentUser.textDirection,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    AspectRatio(
                                      aspectRatio: 3 / 2,
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: GoogleMap(
                                              initialCameraPosition:
                                                  CameraPosition(
                                                // bearing: 192.8334901395799,
                                                // tilt: 59.440717697143555,
                                                zoom: 15,
                                                target: LatLng(
                                                  double.parse(snapshot.data[
                                                              'map_latitude'] !=
                                                          ''
                                                      ? snapshot
                                                          .data['map_latitude']
                                                      : '0'),
                                                  double.parse(snapshot.data[
                                                              'map_longitude'] !=
                                                          ''
                                                      ? snapshot
                                                          .data['map_longitude']
                                                      : '0'),
                                                ),
                                              ),
                                              onMapCreated: (GoogleMapController
                                                  controller) {
                                                if (!_controller.isCompleted)
                                                  _controller
                                                      .complete(controller);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      langPack['Recommended Ads for You'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              FutureBuilder(
                                future: Provider.of<APIHelper>(context,
                                        listen: false)
                                    .fetchRelatedProducts(
                                  categoryId: snapshot.data['category_id'],
                                  subCategoryId:
                                      snapshot.data['sub_category_id'],
                                ),
                                builder: (ctx, AsyncSnapshot relatedSnapshot) {
                                  if (relatedSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return LoadingPage();
                                  }
                                  if (relatedSnapshot.hasData &&
                                      relatedSnapshot.data.length > 0) {
                                    return Container(
                                      padding: const EdgeInsets.only(
                                        top: 5,
                                        bottom: 15,
                                        left: 5,
                                        right: 0,
                                      ),
                                      height:
                                          MediaQuery.of(context).size.width *
                                              3.3 /
                                              5,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              relatedSnapshot.data.length,
                                          itemBuilder: (ctx, i) {
                                            return Row(children: [
                                              ProductItem(
                                                id: relatedSnapshot.data[i].id,
                                                isFeatured: relatedSnapshot
                                                    .data[i].isFeatured,
                                                isUrgent: relatedSnapshot
                                                    .data[i].isUrgent,
                                                name: relatedSnapshot
                                                    .data[i].name,
                                                imageUrl: relatedSnapshot
                                                    .data[i].picture,
                                                price: relatedSnapshot
                                                    .data[i].price,
                                                location: relatedSnapshot
                                                    .data[i].location,
                                                currency: relatedSnapshot
                                                    .data[i].currency,
                                              ),
                                              SizedBox(width: 5),
                                            ]);
                                          }),
                                    );
                                  }
                                  return Center(
                                    child: Text('There are not related Ads'),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 100,
                              )
                            ],
                          ),
                          bottomNavigationBar: !myAd
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Ink(
                                        decoration: ShapeDecoration(
                                            color: HexColor(),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.messenger_outline,
                                            ),
                                            iconSize: 25,
                                            color: Colors.white,
                                            onPressed: () {
                                              if (isLoaded &&
                                                  CurrentUser.isLoggedIn) {
                                                if (adUserId !=
                                                    CurrentUser.id) {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          ChatScreen.routeName,
                                                          arguments: {
                                                        'from_user_id':
                                                            adUserId,
                                                        'from_user_fullname':
                                                            adUserFullName,
                                                      });
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'This is your ad'),
                                                    ),
                                                  );
                                                }
                                              } else if (!CurrentUser
                                                  .isLoggedIn) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      langPack[
                                                          'You must be logged in to use this feature'],
                                                      textDirection: CurrentUser
                                                          .textDirection,
                                                    ),
                                                    action: SnackBarAction(
                                                      label: langPack['LOG IN'],
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                StartScreen
                                                                    .routeName);
                                                      },
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Ink(
                                        decoration: const ShapeDecoration(
                                            color: Color(0xFF2E2E3D),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.call,
                                            ),
                                            iconSize: 25,
                                            color: Colors.white,
                                            onPressed: () async {
                                              if (isLoaded && !hidePhone) {
                                                if (adUserId !=
                                                    CurrentUser.id) {
                                                  final Uri _emailLaunchUri =
                                                      Uri(
                                                    scheme: 'tel',
                                                    path: phoneNumber,
                                                  );
                                                  await urlLauncher.canLaunch(
                                                          _emailLaunchUri
                                                              .toString())
                                                      ? await urlLauncher
                                                          .launch(
                                                              _emailLaunchUri
                                                                  .toString())
                                                      : throw 'Could not launch ${_emailLaunchUri.toString()}';
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'This is your ad'),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'The phone number is hidden'),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            if (!CurrentUser.isLoggedIn) {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext ctx) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      langPack['Login'],
                                                      textDirection: CurrentUser
                                                          .textDirection,
                                                    ),
                                                    content: Text(
                                                      langPack[
                                                          'You must be logged in to use this feature'],
                                                      textDirection: CurrentUser
                                                          .textDirection,
                                                    ),
                                                    actions: [
                                                      cancelButton(ctx),
                                                      continueButton(ctx),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else if (CurrentUser.isLoggedIn) {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) {
                                                    return OfferDialogBox(
                                                      title: langPack[
                                                          'Make an Offer'],
                                                      descriptions: langPack[
                                                              'Seller asking price is'] +
                                                          ' \"${snapshot.data['price'] + unescape.convert(snapshot.data['currency'] ?? "₹")}\"',
                                                    );
                                                  });
                                            }
                                          },
                                          child: Container(
                                            height: 60,
                                            decoration: BoxDecoration(
                                                color: Colors.black87,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                shape: BoxShape.rectangle),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Center(
                                              child: Text(
                                                langPack['MAKE AN OFFER'],
                                                textDirection:
                                                    CurrentUser.textDirection,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : (!AppConfig.isPremium!)
                                  ? GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return _premiumDialog(ctx);
                                            });
                                      },
                                      child: Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                            color: Color(0xFF2E2E3D),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            shape: BoxShape.rectangle),
                                        margin:
                                            EdgeInsets.fromLTRB(20, 0, 20, 20),
                                        child: Row(
                                          textDirection:
                                              CurrentUser.textDirection,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Iconsax.crown_1,
                                              size: 25,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              langPack['Upgrade To Premium'],
                                              textDirection:
                                                  CurrentUser.textDirection,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : SizedBox.shrink());
                    }
                }
                return Center(
                  child: Text('There is no data about this product'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
