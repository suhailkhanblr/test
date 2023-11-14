import 'package:Duet_Classified/screens/color_helper.dart';
import 'package:Duet_Classified/screens/search_ad_screen.dart';
import 'package:Duet_Classified/widgets/loadingpage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../helpers/api_helper.dart';
import '../helpers/current_user.dart';
import '../helpers/db_helper.dart';
import '../providers/languages.dart';
import '../providers/products.dart';
import '../screens/tabs_screen.dart';

class LocationSearchScreen extends StatefulWidget {
  static const routeName = '/location-search';

  @override
  _LocationSearchScreenState createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  bool _isState = false;
  bool _isCountry = true;
  String _keyword = '';
  String _chosenStateCode = '';
  String _chosenStateName = '';
  String _chosenCountryName = '';
  String _chosenCountryCode = '';
  String _chosenCityName = '';
  String _chosenCityCode = '';
  TextEditingController searchBoxTxtCtrl = new TextEditingController();

  // bool isCitySearch = false;
  @override
  Widget build(BuildContext context) {
    final langPack = Provider.of<Languages>(context).selected;
    final productsProvider = Provider.of<Products>(context);
    // List snapshot.data = [];
    return Scaffold(
      appBar: AppBar(
        shape: AppBarBottomShape(),
        title: Center(
          child: Text(
            langPack['Location']!,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        centerTitle: true,
        // leading: IconButton(
        //   icon: Icon(Iconsax.arrow_left_2, color: Colors.black),
        //   onPressed: () async {
        //     await DBHelper.update('user_info', {
        //       'id': CurrentUser.id,
        //       'locationName': CurrentUser.location.name,
        //       'locationCityId': CurrentUser.location.cityId,
        //       'locationCityName': CurrentUser.location.cityName,
        //       'locationStateId': CurrentUser.location.stateId,
        //       'locationStateName': CurrentUser.location.stateName,
        //       'locationCityState': CurrentUser.location.cityState,
        //     });
        //     final dataList = await DBHelper.read('user_info');

        //     print(
        //         "isUpload ${CurrentUser.uploadingAd} | isFromSearch ${CurrentUser.fromSearchScreen}");

        //     if (!CurrentUser.uploadingAd) {
        //       if (CurrentUser.fromSearchScreen) {
        //         // Navigator.of(context).pop();
        //         Navigator.of(context).pushNamed(SearchAdScreen.routeName);
        //       } else {
        //         Navigator.pushNamedAndRemoveUntil(context, TabsScreen.routeName,
        //             (Route<dynamic> route) => false);
        //       }
        //     } else {
        //       Navigator.of(context).pop();
        //     }
        //   },
        // ),
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
        //#region old code
        // flexibleSpace: Container(
        //   padding: EdgeInsets.only(
        //     top: 10,
        //     bottom: 10,
        //     left: 55,
        //     right: 10,
        //   ),
        //   child: TextField(
        //     cursorColor: Colors.grey[800],
        //     textDirection: CurrentUser.textDirection,
        //     decoration: InputDecoration(
        //       filled: true,
        //       fillColor: Colors.white,
        //       hintTextDirection: CurrentUser.textDirection,
        //       labelText: langPack[_isCountry
        //           ? 'Country'
        //           : _isState
        //               ? 'State'
        //               : 'City'],
        //       suffixIcon: Icon(Icons.search, color: Colors.grey),
        //     ),
        //     onChanged: (value) {
        //       setState(() {
        //         _keyword = value;
        //       });
        //     },
        //   ),
        // ),
        //#endregion old code

        //   //title: Text('Home Tab'),
        backgroundColor: HexColor(hexColor: "#FFFFFF"),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 10,
                right: 10,
              ),
              child: TextField(
                cursorColor: Colors.grey[800],
                textDirection: CurrentUser.textDirection,
                controller: searchBoxTxtCtrl,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFEEEDED),
                    hintTextDirection: CurrentUser.textDirection,
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                    hintText: langPack[_isCountry
                        ? 'Country'
                        : _isState
                            ? 'State'
                            : 'City'],
                    hintStyle: TextStyle(fontSize: 14),
                    prefixIcon: (CurrentUser.textDirection == TextDirection.ltr)
                        ? Icon(Iconsax.search_normal_1, color: Colors.grey)
                        : SizedBox.shrink(),
                    suffixIcon: (CurrentUser.textDirection == TextDirection.rtl)
                        ? Icon(Iconsax.search_normal_1, color: Colors.grey)
                        : SizedBox.shrink(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            strokeAlign: 0, color: Colors.transparent),
                        borderRadius: BorderRadius.circular(50)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            strokeAlign: 0, color: Colors.transparent),
                        borderRadius: BorderRadius.circular(50))),
                onChanged: (value) {
                  setState(() {
                    _keyword = value;
                  });
                },
              ),
            ),
            Expanded(
              child: ListView(children: [
                _isCountry
                    ? FutureBuilder(
                        future: Provider.of<APIHelper>(context, listen: false)
                            .fetchCountryDetails(),
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

                              return ListView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (content, i) {
                                    if (snapshot.data[i]['name']
                                            .toLowerCase()
                                            .contains(_keyword.toLowerCase()) ||
                                        _keyword.isEmpty) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            contentPadding:
                                                EdgeInsets.only(bottom: 0),
                                            trailing: CurrentUser.language ==
                                                    'Arabic'
                                                ? null
                                                : Icon(Iconsax.arrow_right_3),
                                            leading:
                                                CurrentUser.language == 'Arabic'
                                                    ? Icon(Iconsax.arrow_left_2)
                                                    : null,
                                            // trailing: Icon(Icons.arrow_right),
                                            title: Text(
                                              snapshot.data[i]['name'],
                                              textAlign: CurrentUser.language ==
                                                      'Arabic'
                                                  ? TextAlign.end
                                                  : TextAlign.start,
                                            ),
                                            onTap: () async {
                                              setState(() {
                                                _keyword = '';
                                              });
                                              searchBoxTxtCtrl.clear();
                                              _chosenCountryName =
                                                  snapshot.data[i]['name'];
                                              _chosenCountryCode =
                                                  snapshot.data[i]['code'];
                                              print(
                                                  "data out here $_chosenCountryName");
                                              if (!CurrentUser.uploadingAd) {
                                                CurrentUser.location.name =
                                                    '$_chosenCountryName';
                                                print(
                                                    "data in here ${CurrentUser.location.name} | $_chosenCountryCode");
                                                // , ${_chosenStateName}';
                                                CurrentUser.location.cityId =
                                                    '';
                                                CurrentUser.location.cityName =
                                                    '';
                                                CurrentUser.location.stateId =
                                                    _chosenStateCode;
                                                CurrentUser.location.stateName =
                                                    _chosenStateName;
                                                CurrentUser.location.cityState =
                                                    '';
                                                CurrentUser
                                                        .location.countryCode =
                                                    _chosenCountryCode;
                                                CurrentUser
                                                        .location.countryName =
                                                    _chosenCountryName;

                                                await DBHelper.update(
                                                    'user_info', {
                                                  'id': CurrentUser.id,
                                                  'locationName':
                                                      CurrentUser.location.name,
                                                  'locationCityId': CurrentUser
                                                      .location.cityId,
                                                  'locationCityName':
                                                      CurrentUser
                                                          .location.cityName,
                                                  'locationStateId': CurrentUser
                                                      .location.stateId,
                                                  'locationStateName':
                                                      CurrentUser
                                                          .location.stateName,
                                                  'locationCityState':
                                                      CurrentUser
                                                          .location.cityState,
                                                  'countryCode': CurrentUser
                                                      .location.countryCode
                                                });
                                                // Navigator.pushNamedAndRemoveUntil(
                                                //     context,
                                                //     TabsScreen.routeName,
                                                //     (Route<dynamic> route) => false);
                                                productsProvider
                                                    .clearProductsCache();
                                                setState(() {
                                                  _isCountry = false;
                                                  _isState = true;
                                                });
                                              } else {
                                                // CurrentUser.prodLocation.name =
                                                //     '${snapshot.data[i]['name']}';
                                                // // ${_chosenStateName}';
                                                // CurrentUser.prodLocation.cityId = '';
                                                // CurrentUser.prodLocation.cityName = '';
                                                // CurrentUser.prodLocation.stateId = _chosenStateCode;
                                                // CurrentUser.prodLocation.stateName =
                                                //     _chosenStateName;
                                                // CurrentUser.prodLocation.cityState = '';
                                                // // '${snapshot.data[i]['name']}, ${_chosenStateName}';
                                                // CurrentUser.prodLocation.longitude = '';
                                                // // snapshot.data[i]['longitude'];
                                                // CurrentUser.prodLocation.latitude = '';
                                                // // snapshot.data[i]['latitude'];
                                                // CurrentUser.prodLocation.countryCode =
                                                //     snapshot.data[i]['code'];
                                                // CurrentUser.prodLocation.countryName =
                                                //     snapshot.data[i]['name'];

                                                Provider.of<CurrentUser>(
                                                        context,
                                                        listen: false)
                                                    .setProductLocation(
                                                  prodCityId: '',
                                                  prodCityName: '',
                                                  prodCityState: '',
                                                  prodCountryCode:
                                                      _chosenCountryCode,
                                                  prodCountryName:
                                                      _chosenCountryName,
                                                  prodLatitude: '',
                                                  prodLocationName:
                                                      _chosenCountryName,
                                                  prodLongitude: '',
                                                  prodStateId: _chosenStateCode,
                                                  prodStateName:
                                                      _chosenStateName,
                                                );
                                                // CurrentUser.uploadingAd = false;
                                                // close(context, snapshot.data[i].name);
                                                // Navigator.of(context).pop();
                                                setState(() {
                                                  _isCountry = false;
                                                  _isState = true;
                                                });
                                              }
                                            },
                                          ),
                                          Divider(
                                              color: Colors.grey,
                                              thickness: 0.2)
                                        ],
                                      );
                                    } else
                                      return SizedBox.shrink();
                                  });
                          }
                        })
                    : _isState
                        ? FutureBuilder(
                            future:
                                Provider.of<APIHelper>(context, listen: false)
                                    .fetchStateDetailsByCountry(
                                        countryCode: _chosenCountryCode),
                            builder: (context, AsyncSnapshot snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  print('State Waiting !');
                                  return LoadingPage();
                                default:
                                  if (snapshot.hasError) {
                                    return Container(
                                      child: Text(snapshot.error.toString()),
                                    );
                                  }

                                  return ListView.builder(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (content, i) {
                                      print(
                                          'Fetched State ::::>>>> ${snapshot.data[i]}');
                                      if (snapshot.data[i].name
                                              .toLowerCase()
                                              .contains(
                                                  _keyword.toLowerCase()) ||
                                          _keyword.isEmpty) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListTile(
                                              // trailing: Icon(Icons.arrow_right),
                                              contentPadding:
                                                  EdgeInsets.only(bottom: 0),
                                              trailing: CurrentUser.language ==
                                                      'Arabic'
                                                  ? null
                                                  : Icon(Iconsax.arrow_right_3),
                                              leading: CurrentUser.language ==
                                                      'Arabic'
                                                  ? Icon(Iconsax.arrow_left_2)
                                                  : null,
                                              title: Text(
                                                snapshot.data[i].name,
                                                textAlign:
                                                    CurrentUser.language ==
                                                            'Arabic'
                                                        ? TextAlign.end
                                                        : TextAlign.start,
                                              ),
                                              onTap: () async {
                                                _chosenStateCode =
                                                    snapshot.data[i].code;
                                                _chosenStateName =
                                                    snapshot.data[i].name;
                                                // if (LocationProvider.cities
                                                //         .where((element) =>
                                                //             _chosenStateCode == element.stateId)
                                                //         .toList()
                                                //         .length ==
                                                //     0) {
                                                if (!CurrentUser.uploadingAd) {
                                                  CurrentUser.location.name =
                                                      _chosenStateName +
                                                          ', ' +
                                                          CurrentUser.location
                                                              .countryName;
                                                  CurrentUser.location.cityId =
                                                      '';
                                                  CurrentUser
                                                      .location.cityName = '';
                                                  CurrentUser.location.stateId =
                                                      _chosenStateCode;
                                                  CurrentUser
                                                          .location.stateName =
                                                      _chosenStateName;
                                                  CurrentUser
                                                      .location.cityState = '';

                                                  await DBHelper.update(
                                                      'user_info', {
                                                    'id': CurrentUser.id,
                                                    'locationName': CurrentUser
                                                        .location.name,
                                                    'locationCityId': '',
                                                    'locationCityName': '',
                                                    'locationStateId':
                                                        CurrentUser
                                                            .location.stateId,
                                                    'locationStateName':
                                                        CurrentUser
                                                            .location.stateName,
                                                    'locationCityState': '',
                                                    'countryCode': CurrentUser
                                                        .location.countryCode
                                                  });
                                                  productsProvider
                                                      .clearProductsCache();
                                                  // Navigator.pushNamedAndRemoveUntil(
                                                  //     context,
                                                  //     TabsScreen.routeName,
                                                  //     (Route<dynamic> route) => false);
                                                } else {
                                                  // CurrentUser.prodLocation.name =
                                                  //     snapshot.data[i].name +
                                                  //         ', ' +
                                                  //         CurrentUser.location.countryName;
                                                  // CurrentUser.prodLocation.cityId = '';
                                                  // CurrentUser.prodLocation.cityName = '';
                                                  // CurrentUser.prodLocation.stateId =
                                                  //     snapshot.data[i].code;
                                                  // CurrentUser.prodLocation.stateName =
                                                  //     snapshot.data[i].name;
                                                  // CurrentUser.prodLocation.cityState = '';

                                                  Provider.of<CurrentUser>(
                                                          context,
                                                          listen: false)
                                                      .setProductLocation(
                                                    prodCityId: '',
                                                    prodCityName: '',
                                                    prodCityState: '',
                                                    prodCountryCode:
                                                        _chosenCountryCode,
                                                    prodCountryName:
                                                        _chosenCountryName,
                                                    prodLatitude: '',
                                                    prodLocationName:
                                                        _chosenStateName +
                                                            ', ' +
                                                            _chosenCountryName,
                                                    prodLongitude: '',
                                                    prodStateId:
                                                        _chosenStateCode,
                                                    prodStateName:
                                                        _chosenStateName,
                                                  );

                                                  // CurrentUser.uploadingAd = false;
                                                  // close(context, snapshot.data[i].name);
                                                }
                                                // } else {
                                                setState(() {
                                                  _isState = false;
                                                  _keyword = '';
                                                });
                                                searchBoxTxtCtrl.clear();
                                                // }
                                                //snapshot.data = [];
                                              },
                                            ),
                                            Divider(
                                                color: Colors.grey,
                                                thickness: 0.2)
                                          ],
                                        );
                                      }
                                      return SizedBox.shrink();
                                    },
                                  );
                              }
                            })
                        : FutureBuilder(
                            future: Provider.of<APIHelper>(context)
                                .fetchCityDetailsByState(
                              stateCode: _chosenStateCode,
                              keywords: _keyword,
                            ),
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
                                  if (snapshot.data.length != 0) {
                                    return ListView.builder(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        shrinkWrap: true,
                                        physics: ScrollPhysics(),
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (content, i) {
                                          if (snapshot.data[i]['name']
                                                  .toLowerCase()
                                                  .contains(
                                                      _keyword.toLowerCase()) ||
                                              _keyword.isEmpty) {
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ListTile(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          bottom: 0),
                                                  trailing:
                                                      CurrentUser.language ==
                                                              'Arabic'
                                                          ? null
                                                          : Icon(Iconsax
                                                              .arrow_right_3),
                                                  leading: CurrentUser
                                                              .language ==
                                                          'Arabic'
                                                      ? Icon(
                                                          Iconsax.arrow_left_2)
                                                      : null,
                                                  // trailing: Icon(Icons.arrow_right),
                                                  title: Text(
                                                    snapshot.data[i]['name'],
                                                    textAlign:
                                                        CurrentUser.language ==
                                                                'Arabic'
                                                            ? TextAlign.end
                                                            : TextAlign.start,
                                                  ),
                                                  onTap: () async {
                                                    searchBoxTxtCtrl.clear();
                                                    setState(() {
                                                      _keyword = "";
                                                    });
                                                    _chosenCityName = snapshot
                                                        .data[i]['name'];
                                                    _chosenCityCode =
                                                        snapshot.data[i]['id'];
                                                    if (!CurrentUser
                                                        .uploadingAd) {
                                                      CurrentUser
                                                              .location.name =
                                                          '$_chosenCityName, $_chosenStateName, $_chosenCountryName';
                                                      CurrentUser
                                                              .location.cityId =
                                                          _chosenCityCode;
                                                      CurrentUser.location
                                                              .cityName =
                                                          _chosenCityName;
                                                      CurrentUser.location
                                                              .stateId =
                                                          _chosenStateCode;
                                                      CurrentUser.location
                                                              .stateName =
                                                          _chosenStateName;
                                                      CurrentUser.location
                                                              .cityState =
                                                          '$_chosenCityName, $_chosenStateName';
                                                      CurrentUser.location
                                                              .countryCode =
                                                          _chosenCountryCode;
                                                      CurrentUser.location
                                                              .countryName =
                                                          _chosenCountryName;

                                                      await DBHelper.update(
                                                          'user_info', {
                                                        'id': CurrentUser.id,
                                                        'locationName':
                                                            CurrentUser
                                                                .location.name,
                                                        'locationCityId':
                                                            CurrentUser.location
                                                                .cityId,
                                                        'locationCityName':
                                                            CurrentUser.location
                                                                .cityName,
                                                        'locationStateId':
                                                            CurrentUser.location
                                                                .stateId,
                                                        'locationStateName':
                                                            CurrentUser.location
                                                                .stateName,
                                                        'locationCityState':
                                                            CurrentUser.location
                                                                .cityState,
                                                        'countryCode':
                                                            CurrentUser.location
                                                                .countryCode
                                                      });
                                                      productsProvider
                                                          .clearProductsCache();

                                                      Navigator
                                                          .pushNamedAndRemoveUntil(
                                                              context,
                                                              TabsScreen
                                                                  .routeName,
                                                              (Route<dynamic>
                                                                      route) =>
                                                                  false);
                                                    } else {
                                                      // CurrentUser.prodLocation.name =
                                                      //     '$_chosenCityName, ${_chosenStateName}';
                                                      // CurrentUser.prodLocation.cityId =
                                                      //     _chosenCityCode;
                                                      // CurrentUser.prodLocation.cityName =
                                                      //     _chosenCityName;
                                                      // CurrentUser.prodLocation.stateId =
                                                      //     _chosenStateCode;
                                                      // CurrentUser.prodLocation.stateName =
                                                      //     _chosenStateName;
                                                      // CurrentUser.prodLocation.cityState =
                                                      //     '$_chosenCityName, $_chosenStateName';
                                                      // CurrentUser.prodLocation.longitude =
                                                      //     snapshot.data[i]['longitude'];
                                                      // CurrentUser.prodLocation.latitude =
                                                      //     snapshot.data[i]['latitude'];

                                                      Provider.of<CurrentUser>(
                                                              context,
                                                              listen: false)
                                                          .setProductLocation(
                                                        prodCityId:
                                                            _chosenCityCode,
                                                        prodCityName:
                                                            _chosenCityName,
                                                        prodCityState:
                                                            '$_chosenCityName, $_chosenStateName',
                                                        prodCountryCode:
                                                            _chosenCountryCode,
                                                        prodCountryName:
                                                            _chosenCountryName,
                                                        prodLatitude:
                                                            snapshot.data[i]
                                                                ['latitude'],
                                                        prodLocationName:
                                                            '${snapshot.data[i]['name']}, $_chosenStateName',
                                                        prodLongitude:
                                                            snapshot.data[i]
                                                                ['longitude'],
                                                        prodStateId:
                                                            _chosenStateCode,
                                                        prodStateName:
                                                            _chosenStateName,
                                                      );

                                                      CurrentUser.uploadingAd =
                                                          false;
                                                      // close(context, snapshot.data[i].name);
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  },
                                                ),
                                                Divider(
                                                    color: Colors.grey,
                                                    thickness: 0.2)
                                              ],
                                            );
                                          } else
                                            return SizedBox.shrink();
                                        });
                                  } else {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              padding:
                                                  MaterialStateProperty.all(
                                                      EdgeInsets.symmetric(
                                                          horizontal: 20,
                                                          vertical: 20)),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Theme.of(context)
                                                          .primaryColor)),
                                          onPressed: () => Navigator.of(context)
                                              .pushReplacementNamed(
                                                  TabsScreen.routeName),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  langPack[
                                                      "No Info about cities move to Home"]!,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                                ),
                                              ),
                                              const Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                              }
                            }),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
