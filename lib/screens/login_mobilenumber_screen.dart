import 'package:Duet_Classified/helpers/api_helper.dart';
import 'package:Duet_Classified/providers/languages.dart';
import 'package:Duet_Classified/providers/showmessage.dart';
import 'package:Duet_Classified/screens/color_helper.dart';
import 'package:Duet_Classified/screens/login_screen.dart';
import 'package:Duet_Classified/screens/tabs_screen.dart';
import 'package:Duet_Classified/widgets/loadingpage.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginWithMobileNumberScreen extends StatefulWidget {
  const LoginWithMobileNumberScreen({Key? key}) : super(key: key);
  static const routeName = '/mobilenumberlogin';

  @override
  _LoginWithMobileNumberScreenState createState() =>
      _LoginWithMobileNumberScreenState();
}

class _LoginWithMobileNumberScreenState
    extends State<LoginWithMobileNumberScreen> {
  bool passwordVisible = false, isLoading = false, isTextBoxComplet = false;
  CountryCode? selectedCountryCode;
  final TextEditingController mobileNumberTxtCtrl = new TextEditingController();
  final TextEditingController passwordTxtCtrl = new TextEditingController();

  final FocusNode mobileTxtFocus = new FocusNode();
  final FocusNode passwordTxtFocus = new FocusNode();
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final langPack = Provider.of<Languages>(context).selected;
    double dividerSize = 16.0;
    return Scaffold(
        backgroundColor: HexColor(),
        body: Stack(
          children: [
            // Image.asset(
            //   "assets/images/triangle_pattern.png",
            //   height: MediaQuery.of(context).size.height,
            //   width: MediaQuery.of(context).size.width,
            //   fit: BoxFit.contain,
            // ),
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 40, left: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(
                              LoginScreenScreen.routeName,
                              arguments: false);
                        },
                        child: Icon(Icons.chevron_left_rounded,
                            size: 32, color: Colors.black),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(5),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      margin:
                          const EdgeInsets.only(top: 40, left: 15, bottom: 10),
                      child: Text(
                        langPack['mobilenumber']!,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white, fontSize: 32.5),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.7,
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50))),
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: dividerSize + dividerSize,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: mobileTxtFocus.hasFocus
                                      ? Color(0xFF2E2E3D)
                                      : Colors.grey),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CountryCodePicker(
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCountryCode = value;
                                    });
                                  },
                                  onInit: (value) {
                                    selectedCountryCode = value;
                                  },
                                  initialSelection: 'IN',
                                  showCountryOnly: true,
                                  showOnlyCountryWhenClosed: false,
                                  alignLeft: false,
                                  hideMainText: true,
                                  showDropDownButton: true,
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                ),
                                Expanded(
                                  child: TextField(
                                      focusNode: mobileTxtFocus,
                                      controller: mobileNumberTxtCtrl,
                                      decoration: InputDecoration(
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 15),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        hintText: langPack["mobilenumber"],
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                      onChanged: (_) => setState(() {
                                            isTextBoxComplet = (passwordTxtCtrl
                                                    .text.isNotEmpty)
                                                ? true
                                                : false;
                                          }),
                                      keyboardType: TextInputType.phone,
                                      cursorColor: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: dividerSize),
                          TextField(
                            controller: passwordTxtCtrl,
                            focusNode: passwordTxtFocus,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,
                                color: HexColor(),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: HexColor()),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: langPack["Password"],
                              hintStyle: TextStyle(color: Colors.grey),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: passwordVisible
                                        ? HexColor()
                                        : Colors.grey),
                                onPressed: () {
                                  setState(
                                    () {
                                      passwordVisible = !passwordVisible;
                                    },
                                  );
                                },
                              ),
                              alignLabelWithHint: false,
                            ),
                            onChanged: (value) {
                              setState(() {
                                isTextBoxComplet =
                                    (mobileNumberTxtCtrl.text.isNotEmpty)
                                        ? true
                                        : false;
                              });
                            },
                            obscureText: !passwordVisible,
                            textInputAction: TextInputAction.done,
                            cursorColor: Colors.grey,
                          ),
                          SizedBox(
                            height: dividerSize + dividerSize,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              loginWithMobileNumber(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                langPack["LOG IN"]!,
                                style: TextStyle(
                                    color: (isTextBoxComplet)
                                        ? Colors.white
                                        : Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.all(5),
                              backgroundColor: isTextBoxComplet
                                  ? HexColor()
                                  : Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black.withOpacity(0.5),
                child: LoadingPage(),
              )
          ],
        ));
  }

  void loginWithMobileNumber(BuildContext context) {
    if (mobileNumberTxtCtrl.text.isEmpty) {
      mobileTxtFocus.requestFocus();
      return;
    }

    if (passwordTxtCtrl.text.isEmpty) {
      passwordTxtFocus.requestFocus();
      return;
    }
    setState(() {
      isLoading = true;
    });

    final apiHelper = Provider.of<APIHelper>(context, listen: false);
    apiHelper
        .loginUserUsingMobileNumber(
            mobileNumber: '${mobileNumberTxtCtrl.text}',
            countryCode: selectedCountryCode!.dialCode,
            password: passwordTxtCtrl.text)
        .then((value) {
      switch ((value.isEmpty || value == null) ? "" : value) {
        case "success":
          {
            showMessage(context, "Successfully Login!", isSuccess: true);
            mobileNumberTxtCtrl.clear();
            passwordTxtCtrl.clear();

            Navigator.pushNamedAndRemoveUntil(
                context, TabsScreen.routeName, (Route<dynamic> route) => false);
          }
          break;
        case "fail":
        case "error":
          showMessage(context, "Login Failed!", isError: true);
          break;
      }
      setState(() {
        isLoading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      showMessage(context, error.toString(), isError: true);
    });
  }
}
