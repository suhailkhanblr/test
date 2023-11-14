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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);
  static const routeName = '/forgotpassword';

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool isLoading = false;
  final TextEditingController emailTxtCtrl = new TextEditingController();

  final FocusNode emailTxtFocus = new FocusNode();
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final langPack = Provider.of<Languages>(context).selected;
    double dividerSize = 16.0;
    return Scaffold(
        body: Stack(children: [
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(top: 40),
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
            ),
            SizedBox(height: dividerSize * 2),
            SvgPicture.asset("assets/images/forgotpassword.svg",
                height: MediaQuery.of(context).size.width / 2.5,
                semanticsLabel: 'Forget Password'),
            SizedBox(height: dividerSize),
            Text(
              langPack['mobilenumber']!,
              style: TextStyle(color: Colors.black, fontSize: 28),
            ),
            Text(
              langPack[
                  'Enter your email and we\'ll send you a link to create a new password']!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: dividerSize),
            TextField(
              controller: emailTxtCtrl,
              focusNode: emailTxtFocus,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email_outlined,
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
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: langPack["Email"],
                hintStyle: TextStyle(color: Colors.grey),
                alignLabelWithHint: false,
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              cursorColor: Colors.grey,
            ),
            SizedBox(
              height: dividerSize + dividerSize,
            ),
            ElevatedButton(
              onPressed: () {
                sendPasswordViaByEmail(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  langPack["Confirm"]!,
                  style: TextStyle(
                      color: (emailTxtFocus.hasFocus)
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
                minimumSize: const Size.fromHeight(50),
                backgroundColor:
                    (emailTxtFocus.hasFocus) ? HexColor() : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
      if (isLoading)
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black.withOpacity(0.5),
          child: LoadingPage(),
        )
    ]));
  }

  void sendPasswordViaByEmail(BuildContext context) {
    final _langPack = Provider.of<Languages>(context, listen: false).selected;
    final apiHelper = Provider.of<APIHelper>(context, listen: false);

    //check email
    if (emailTxtCtrl.text.isEmpty) {
      emailTxtFocus.requestFocus();
      return;
    } else {
      final emailValidator = new RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
      if (!emailValidator.hasMatch(emailTxtCtrl.text)) {
        showMessage(
            context, _langPack['Please enter correct Email id'].toString(),
            isWarning: true);
        return;
      }
    }
    setState(() {
      isLoading = true;
    });

    FocusScope.of(context).unfocus();
    apiHelper.forgetPassword(email: emailTxtCtrl.text.trim()).then((isFound) {
      if (isFound) {
        showMessage(context,
            "Please check your email account for the forgot password details",
            isSuccess: true);
        emailTxtCtrl.clear();
        Navigator.pushNamedAndRemoveUntil(context, LoginScreenScreen.routeName,
            (Route<dynamic> route) => false);
      } else {
        showMessage(context, "Email address does not exist", isError: true);
        emailTxtCtrl.clear();
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
