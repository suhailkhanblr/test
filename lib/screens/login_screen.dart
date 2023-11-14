import 'dart:math';

import 'package:Duet_Classified/helpers/api_helper.dart';
import 'package:Duet_Classified/helpers/app_config.dart';
import 'package:Duet_Classified/helpers/current_user.dart';
import 'package:Duet_Classified/providers/languages.dart';
import 'package:Duet_Classified/providers/showmessage.dart';
import 'package:Duet_Classified/screens/color_helper.dart';
import 'package:Duet_Classified/screens/create_account_phone_screen.dart';
import 'package:Duet_Classified/screens/forgetpassword.dart';
import 'package:Duet_Classified/screens/location_search_screen.dart';
import 'package:Duet_Classified/screens/login_mobilenumber_screen.dart';
import 'package:Duet_Classified/screens/tabs_screen.dart';
import 'package:Duet_Classified/widgets/loadingpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

class LoginScreenScreen extends StatefulWidget {
  const LoginScreenScreen({Key? key}) : super(key: key);
  static const routeName = '/login';

  @override
  _LoginScreenScreenState createState() => _LoginScreenScreenState();
}

class _LoginScreenScreenState extends State<LoginScreenScreen> {
  bool passwordVisible = false, isLoading = false, textCompleted = false;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
    'email',
    'profile',
  ]);

  final TextEditingController user_emailTxtCtrl = new TextEditingController();
  final TextEditingController passwordTxtCtrl = new TextEditingController();

  final FocusNode user_emailTxtFocus = new FocusNode();
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
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40, left: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context,
                        TabsScreen.routeName, (Route<dynamic> route) => false);
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
              Container(
                margin: const EdgeInsets.only(top: 20, left: 15, bottom: 10),
                child: Text(
                  langPack['Welcomeback']!,
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 32.5),
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: dividerSize,
                      ),
                      TextField(
                        focusNode: user_emailTxtFocus,
                        controller: user_emailTxtCtrl,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color(0xFF2E2E3D),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xFF2E2E3D)),
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
                          hintText: langPack["Email/Username"],
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        cursorColor: Colors.grey,
                        onChanged: (_) {
                          if (passwordTxtCtrl.text.isNotEmpty)
                            setState(() {
                              textCompleted = true;
                            });
                        },
                      ),
                      SizedBox(height: dividerSize),
                      TextField(
                        focusNode: passwordTxtFocus,
                        controller: passwordTxtCtrl,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xFF2E2E3D),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xFF2E2E3D)),
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
                                    ? Color(0xFF2E2E3D)
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
                        obscureText: !passwordVisible,
                        textInputAction: TextInputAction.done,
                        cursorColor: Colors.grey,
                        onChanged: (_) {
                          if (user_emailTxtCtrl.text.isNotEmpty)
                            setState(() {
                              textCompleted = true;
                            });
                        },
                      ),
                      SizedBox(
                        height: dividerSize,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          loginWithUserName(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            langPack["LOG IN"]!,
                            style: TextStyle(
                                color: (textCompleted)
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
                          backgroundColor:
                          (textCompleted) ? HexColor() : Colors.grey[400],
                        ),
                      ),
                      SizedBox(height: dividerSize),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(
                                  CreateAccountWithPhoneScreen.routeName,
                                  arguments: false);
                            },
                            child: Text(
                              langPack["createaccount"]!,
                              style: TextStyle(
                                  color: HexColor(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(
                                  ForgotPasswordScreen.routeName);
                            },
                            child: Text(
                              langPack["Forget your password?"]!,
                              style: TextStyle(
                                  color: HexColor(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: dividerSize + 5),
                      if ((!AppConfig.disableMobileNumberLogin!) &&
                          (!AppConfig.disableAdSocial!) &&
                          (!AppConfig.disableFbSocial!))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 25),
                              child: Text("Or"),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      else
                        Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),

                      SizedBox(
                        height: dividerSize + 5,
                      ),

                      //signin with phone
                      if (!AppConfig.disableMobileNumberLogin!) ...[
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed(
                                "/mobilenumberlogin");
                          },
                          child: Row(
                            children: [
                              Container(
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                width: 45,
                                margin: EdgeInsets.only(right: 0.2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10.0),
                                        topLeft: Radius.circular(10.0)),
                                    color: HexColor()),
                                child: Icon(
                                  Icons.phone_iphone,
                                  color: Colors.white,
                                  size: 29,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0)),
                                        color: HexColor()),
                                    child: Center(
                                      child: Text(
                                        langPack["signinwithmobilenumber"]!,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: dividerSize,
                        ),
                      ],
                      if (!AppConfig.disableAdSocial!) ...[
                        //signin with google
                        GestureDetector(
                          onTap: () async {
                            User? response =
                            await signInWithGoogle();
                            print(response);

                            await Provider.of<APIHelper>(context, listen: false)
                                .autoLoginUser(
                                name: response?.displayName,
                                email: response?.email,
                                fbLogin: true,
                                username:
                                "${response?.displayName!.replaceAll(" ", "")}${generateRandomString(2)}",
                                fbPicture: response?.photoURL,
                                password: response?.uid);

                            Phoenix.rebirth(context);
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                TabsScreen.routeName,
                                    (Route<dynamic> route) => false);
                          },
                          child: Row(
                            children: [
                              Container(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                                  width: 45,
                                  margin: EdgeInsets.only(right: 0.2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10.0),
                                          topLeft: Radius.circular(10.0)),
                                      color: HexColor()),
                                  child: SvgPicture.asset(
                                      "assets/images/google.svg",
                                      height: 29,
                                      semanticsLabel: 'Label')),
                              Expanded(
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0)),
                                        color: HexColor()),
                                    child: Center(
                                      child: Text(
                                        langPack["signinwithgoogle"]!,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: dividerSize,
                        ),
                      ],
                      if (!AppConfig.disableFbSocial!) ...[
                        //signin with facebook
                        GestureDetector(
                          onTap: () async {
                            final userData = await initiateFacebookLogin();
                            print(userData['email']);
                            print(userData['id']);
                            await Provider.of<APIHelper>(context, listen: false)
                                .autoLoginUser(
                              name: userData['name'],
                              email: userData['email'],
                              fbLogin: true,
                              username: userData['id'].toString(),
                              password: userData['id'].toString(),
                              fbPicture: userData['picture']['data']['url'],
                            );

                            Phoenix.rebirth(context);
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                TabsScreen.routeName,
                                    (Route<dynamic> route) => false);
                          },
                          child: Row(
                            children: [
                              Container(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                                  width: 45,
                                  margin: EdgeInsets.only(right: 0.2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10.0),
                                          topLeft: Radius.circular(10.0)),
                                      color: HexColor()),
                                  child: SvgPicture.asset(
                                      "assets/images/facebook.svg",
                                      height: 29,
                                      semanticsLabel: 'Label')),
                              Expanded(
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0)),
                                        color: Color(0xFF2E2E3D)),
                                    child: Center(
                                      child: Text(
                                        langPack["signinwithfacebook"]!,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: dividerSize,
                        ),
                      ],
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: langPack['By signing up you agree to our']!,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontFamily: GoogleFonts.poppins().fontFamily),
                            children: <TextSpan>[
                              TextSpan(
                                text: langPack['Terms & Conditions']!,
                                style: TextStyle(
                                  color: Color(0xFF2E2E3D),
                                  decoration: TextDecoration.underline,
                                  fontSize: 14,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async => await urlLauncher
                                      .canLaunch(AppConfig.termsPageLink!)
                                      ? await urlLauncher
                                      .launch(AppConfig.termsPageLink!)
                                      : throw 'Could not launch ${AppConfig.termsPageLink}',
                              ),
                              TextSpan(
                                  text: langPack['and'],
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  )),
                              TextSpan(
                                text: langPack['Privacy Policy'],
                                style: TextStyle(
                                  color: Color(0xFF2E2E3D),
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async => await urlLauncher
                                      .canLaunch(AppConfig.policyPageLink!)
                                      ? await urlLauncher
                                      .launch(AppConfig.policyPageLink!)
                                      : throw 'Could not launch ${AppConfig.policyPageLink}',
                              )
                            ]),
                      ),
                      SizedBox(
                        height: dividerSize,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isLoading)
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black.withOpacity(0.5),
            child: LoadingPage(),
          )
      ]),
    );
  }

  Future<void> loginWithUserName(BuildContext ctx) async {
    if (user_emailTxtCtrl.text.isEmpty) {
      user_emailTxtFocus.requestFocus();
      return;
    }
    if (passwordTxtCtrl.text.isEmpty) {
      passwordTxtFocus.requestFocus();
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      isLoading = true;
    });
    final apiHelper = Provider.of<APIHelper>(ctx, listen: false);
    if (false) {
      await apiHelper
          .loginUserUsingEmail(
          email: user_emailTxtCtrl.text, password: passwordTxtCtrl.text)
          .then((value) {
        switch ((value.isEmpty || value == null) ? "" : value) {
          case "success":
            {
              showMessage(context, "Successfully Login!", isSuccess: true);
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  LocationSearchScreen.routeName,
                      (Route<dynamic> route) => false);
              user_emailTxtCtrl.clear();
              passwordTxtCtrl.clear();
              Phoenix.rebirth(context);
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
    } else {
      await apiHelper
          .loginUserUsingUsername(
          username: user_emailTxtCtrl.text.trim(),
          password: passwordTxtCtrl.text)
          .then((value) {
        if (CurrentUser.isLoggedIn) {
          showMessage(context, "Successfully Login!", isSuccess: true);
          user_emailTxtCtrl.clear();
          passwordTxtCtrl.clear();
          Navigator.pushNamedAndRemoveUntil(context,
              LocationSearchScreen.routeName, (Route<dynamic> route) => false);
        } else
          showMessage(context, "Login Failed!", isError: true);

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

  late Map<String, String> langPack;

  /*
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    print(googleUser);
    print(googleUser.displayName);
    print(googleUser.email);
    return googleUser;

    // // Create a new credential
    // final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    //   loginResult: googleAuth.loginResult,
    //   idToken: googleAuth.idToken,
    // );

    // // Once signed in, return the UserCredential
    // final UserCredential authResult =
    //     await FirebaseAuth.instance.signInWithCredential(credential);
    // final User user = authResult.user;
    // if (user != null) {
    //   assert(!user.isAnonymous);
    //   assert(await user.getIdToken() != null);
    //   final User currentUser = _auth.currentUser;
    //   assert(user.uid == currentUser.uid);

    //   print('signInWithGoogle succeeded: $user');
    //   return '$user';
    // }
    // return null;
  }

   */

  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) return null;

      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future initiateFacebookLogin() async {
    await FacebookAuth.instance.logOut();
    try {
      final loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
        //   loginBehavior: LoginBehavior.WEB_ONLY,
      );

      if (loginResult.status == LoginStatus.success) {
        // you are logged
        final AccessToken accessToken = loginResult.accessToken!;
        print('Pre-cred authToken' + accessToken.toString());

        print(loginResult);

        // get the user data
        final userData = await FacebookAuth.instance.getUserData();
        print(userData);

        return userData;
      }

      // // Create a credential from the access token
      // final FacebookAuthCredential credential = FacebookAuthProvider.credential(
      //   loginResult.token,
      // );
      // print(loginResult.token);
      // print('credentials >>>' + credential.toString());
      // // Once signed in, return the UserCredential
      // return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      // handle the FacebookAuthException
      // switch (e.errorCode) {
      //   case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
      //     print("You have a previous login operation in progress");
      //     break;
      //   case FacebookAuthErrorCode.CANCELLED:
      //     print("login cancelled");
      //     break;
      //   case FacebookAuthErrorCode.FAILED:
      //     print("login failed");
      //     break;
      // }
    } finally {}
    return null;
    // final facebookLogin = FacebookLogin();
    // facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    // final result = await facebookLogin.logIn(['email']);

    // // Create a credential from the access token
    // final FacebookAuthCredential facebookAuthCredential =
    //     FacebookAuthProvider.credential(result.loginResult.token);

    // // Once signed in, return the UserCredential
    // await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

    // switch (result.status) {
    //   case FacebookLoginStatus.loggedIn:
    //     // _sendTokenToServer(result.loginResult.token);
    //     // _showLoggedInUI();
    //     print('Logged in with facebook successfuly');
    //     break;
    //   case FacebookLoginStatus.cancelledByUser:
    //     // _showCancelledMessage();
    //     print('Facebook login canceled by user');
    //     break;
    //   case FacebookLoginStatus.error:
    //     // _showErrorOnUI(result.errorMessage);
    //     print('Facebook login throwed some error');
    //     break;
    // }
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Signed Out");
  }

  String generateRandomString(int length) {
    final random = Random();
    const chars = '0123456789';
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }
}
