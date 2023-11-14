import 'package:Duet_Classified/helpers/api_helper.dart';
import 'package:Duet_Classified/models/userdto.dart';
import 'package:Duet_Classified/providers/languages.dart';
import 'package:Duet_Classified/providers/showmessage.dart';
import 'package:Duet_Classified/screens/color_helper.dart';
import 'package:Duet_Classified/screens/login_screen.dart';
import 'package:Duet_Classified/widgets/loadingpage.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateAccountWithPhoneScreen extends StatefulWidget {
  const CreateAccountWithPhoneScreen({Key? key}) : super(key: key);
  static const routeName = '/createaccountwithmobile';

  @override
  _CreateAccountWithPhoneScreenState createState() =>
      _CreateAccountWithPhoneScreenState();
}

class _CreateAccountWithPhoneScreenState
    extends State<CreateAccountWithPhoneScreen> {
  bool passwordVisible = false, showLoading = false, textFieldComplete = false;
  CountryCode? selectedCountryCode;

  final TextEditingController firstNameTxtCtrl = new TextEditingController();
  final TextEditingController userNameTxtCtrl = new TextEditingController();
  final TextEditingController mobileNumberTxtCtrl = new TextEditingController();
  final TextEditingController emailTxtCtrl = new TextEditingController();
  final TextEditingController passwordTxtCtrl = new TextEditingController();

  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();

  final FocusNode firstNameTxtFocus = new FocusNode();
  final FocusNode userNameTxtFocus = new FocusNode();
  final FocusNode mobileTxtFocus = new FocusNode();
  final FocusNode emailTxtFocus = new FocusNode();
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
                Container(
                  margin: const EdgeInsets.only(top: 90, left: 15, bottom: 10),
                  child: Text(
                    langPack['createaccount']!,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white, fontSize: 32.5),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50))),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(
                          height: dividerSize + dividerSize,
                        ),
                        TextField(
                            controller: firstNameTxtCtrl,
                            focusNode: firstNameTxtFocus,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.face,
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
                              hintText: langPack["First name"],
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            onChanged: (_) => changeSignUpBtnColor(),
                            cursorColor: Colors.grey),
                        SizedBox(height: dividerSize),
                        TextField(
                            controller: userNameTxtCtrl,
                            focusNode: userNameTxtFocus,
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
                              hintText: langPack["Username"],
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            onChanged: (_) => changeSignUpBtnColor(),
                            cursorColor: Colors.grey),
                        SizedBox(height: dividerSize),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: mobileTxtFocus.hasFocus
                                    ? Color(0xFF2E2E3D)
                                    : Colors.grey),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      hintText: langPack["mobilenumber"],
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                    onChanged: (_) => changeSignUpBtnColor(),
                                    keyboardType: TextInputType.phone,
                                    cursorColor: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: dividerSize),
                        TextField(
                            controller: emailTxtCtrl,
                            focusNode: emailTxtFocus,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.mail,
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
                              hintText: langPack["Email"],
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            cursorColor: Colors.grey,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (_) => changeSignUpBtnColor()),
                        SizedBox(height: dividerSize),
                        TextField(
                            controller: passwordTxtCtrl,
                            focusNode: passwordTxtFocus,
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
                            onChanged: (_) => changeSignUpBtnColor()),
                        SizedBox(
                          height: dividerSize + dividerSize,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            createAccountWithMobile(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              langPack["SIGN UP"]!,
                              style: TextStyle(
                                  color: (textFieldComplete)
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
                            backgroundColor: (textFieldComplete)
                                ? HexColor()
                                : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showLoading)
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black.withOpacity(0.6),
              child: LoadingPage(),
            )
        ],
      ),
    );
  }

  Future verifyPhoneNumber(UserDTO userDTO) async {
    final _langPack = Provider.of<Languages>(context, listen: false).selected;
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
      phoneNumber: userDTO.countryCode + userDTO.mobileNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: (_) {},
      verificationFailed: (authException) {
        showMessage(context, authException.message.toString(), isError: true);
      },
      codeSent: (String verificationId, [int? forceResendingToken]) {
        double dividerSize = 20.0;
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 15),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                alignment: Alignment.center,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _langPack['verifymobile']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: dividerSize,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: _langPack['wesentaverificationcode'],
                        style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.none,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: Colors.black54),
                        children: <TextSpan>[
                          TextSpan(
                              text: " " +
                                  userDTO.countryCode +
                                  userDTO.mobileNumber,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          TextSpan(
                            text: " " + _langPack['entercodebelow']!,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: dividerSize,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 40,
                          child: TextField(
                            controller: _fieldOne,
                            autofocus: false,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            cursorColor: Color(0xFF2E2E3D),
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                counterText: '',
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 20.0)),
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 40,
                          child: TextField(
                            controller: _fieldTwo,
                            autofocus: false,
                            textAlign: TextAlign.center,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            cursorColor: Color(0xFF2E2E3D),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                counterText: '',
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 20.0)),
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 40,
                          child: TextField(
                            controller: _fieldThree,
                            autofocus: false,
                            textAlign: TextAlign.center,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            cursorColor: Color(0xFF2E2E3D),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                counterText: '',
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 20.0)),
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 40,
                          child: TextField(
                            controller: _fieldFour,
                            autofocus: false,
                            textAlign: TextAlign.center,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            cursorColor: Color(0xFF2E2E3D),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                counterText: '',
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 20.0)),
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 40,
                          child: TextField(
                            controller: _fieldFive,
                            autofocus: false,
                            textAlign: TextAlign.center,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            cursorColor: Color(0xFF2E2E3D),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                counterText: '',
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 20.0)),
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 40,
                          child: TextField(
                            controller: _fieldSix,
                            autofocus: false,
                            textAlign: TextAlign.center,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            cursorColor: Color(0xFF2E2E3D),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                counterText: '',
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 20.0)),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: dividerSize,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_fieldOne.text.isEmpty ||
                                  _fieldTwo.text.isEmpty ||
                                  _fieldThree.text.isEmpty ||
                                  _fieldFour.text.isEmpty ||
                                  _fieldFive.text.isEmpty) {
                                showMessage(
                                    context,
                                    _langPack['Please enter your full name']
                                        .toString(),
                                    isWarning: true);
                                return;
                              }

                              PhoneAuthCredential credential =
                                  PhoneAuthProvider.credential(
                                      verificationId: verificationId,
                                      smsCode: _fieldOne.text +
                                          _fieldTwo.text +
                                          _fieldThree.text +
                                          _fieldFour.text +
                                          _fieldFive.text +
                                          _fieldSix.text);

                              await _auth
                                  .signInWithCredential(credential)
                                  .then((result) {
                                _fieldOne.clear();
                                _fieldTwo.clear();
                                _fieldThree.clear();
                                _fieldFour.clear();
                                _fieldFive.clear();
                                _fieldSix.clear();
                                Navigator.pop(context);
                                registerUserData(userDTO);
                              }).catchError((e) {
                                showMessage(
                                    context, _langPack["Wrong OTP"].toString(),
                                    isError: true);
                                _fieldOne.clear();
                                _fieldTwo.clear();
                                _fieldThree.clear();
                                _fieldFour.clear();
                                _fieldSix.clear();
                                _fieldFive.clear();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                _langPack["verifyproceed"]!,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.all(5),
                              backgroundColor: Color(0xFF2E2E3D),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: dividerSize,
                    ),
                    GestureDetector(
                      onTap: () {
                        verifyPhoneNumber(userDTO);
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: _langPack['dontreceivecode'],
                          style: TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.none,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              color: Colors.black54),
                          children: <TextSpan>[
                            TextSpan(
                                text: " " + _langPack['resendcode']!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E2E3D))),
                          ],
                        ),
                      ),
                    )
                  ],
                )));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> createAccountWithMobile(BuildContext ctx) async {
    final _langPack = Provider.of<Languages>(ctx, listen: false).selected;
    final apiHelper = Provider.of<APIHelper>(context, listen: false);

    //check first name
    if (firstNameTxtCtrl.text.isEmpty) {
      firstNameTxtFocus.requestFocus();
      return;
    } else {
      if (firstNameTxtCtrl.text.length < 2) {
        showMessage(
            context, _langPack['Please enter your full name'].toString(),
            isWarning: true);
        return;
      }
    }

    //check user name
    if (userNameTxtCtrl.text.isEmpty) {
      userNameTxtFocus.requestFocus();
      return;
    } else {
      if (userNameTxtCtrl.text.length < 6) {
        showMessage(
            context,
            _langPack['Please enter minimum 6 characters of Username']
                .toString(),
            isWarning: true);
        return;
      }

      final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
      if (!validCharacters.hasMatch(userNameTxtCtrl.text)) {
        showMessage(
            context,
            _langPack['Username can contain only Alphanumeric characters']
                .toString(),
            isWarning: true);
        return;
      }
    }

    //check mobile number
    if (mobileNumberTxtCtrl.text.isEmpty) {
      mobileTxtFocus.requestFocus();
      return;
    } else {
      final phoneValidator = new RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
      if (!phoneValidator.hasMatch(mobileNumberTxtCtrl.text)) {
        showMessage(context, _langPack['Invalid mobile number'].toString(),
            isWarning: true);
        return;
      }
    }

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

    //check password
    if (passwordTxtCtrl.text.isEmpty) {
      passwordTxtFocus.requestFocus();
      return;
    } else {
      if (passwordTxtCtrl.text.length < 6) {
        showMessage(
            context,
            _langPack['Please enter minimum 6 characters of Password']
                .toString(),
            isWarning: true);
        return;
      }
    }

    setState(() {
      showLoading = true;
    });

    UserDTO _userDto = new UserDTO(
        username: userNameTxtCtrl.text,
        name: firstNameTxtCtrl.text,
        email: emailTxtCtrl.text,
        countryCode: selectedCountryCode!.dialCode.toString(),
        mobileNumber: mobileNumberTxtCtrl.text,
        password: passwordTxtCtrl.text,
        fbLogin: '');
    bool isValidUser = await apiHelper.checkUser(_userDto);

    if (isValidUser) {
      setState(() {
        showLoading = false;
      });
      verifyPhoneNumber(_userDto);
    } else {
      setState(() {
        showLoading = false;
      });
      showMessage(context,
          _langPack['Username or email is already occupied'].toString(),
          isError: true);
    }
  }

  Future<void> registerUserData(UserDTO userDto) async {
    final apiHelper = Provider.of<APIHelper>(context, listen: false);
    setState(() {
      showLoading = true;
    });

    apiHelper.registerValidUser(userDto).then((isSuccess) {
      if (isSuccess) {
        Navigator.of(context).pushReplacementNamed(LoginScreenScreen.routeName);
      } else {
        showMessage(context, "Registration Failed!", isError: true);
      }
      setState(() {
        showLoading = false;
      });
    }).catchError((e) {
      showMessage(context, e.toString(), isError: true);
      setState(() {
        showLoading = false;
      });
    });
  }

  void changeSignUpBtnColor() {
    if (firstNameTxtCtrl.text.isNotEmpty &&
        userNameTxtCtrl.text.isNotEmpty &&
        mobileNumberTxtCtrl.text.isNotEmpty &&
        emailTxtCtrl.text.isNotEmpty &&
        passwordTxtCtrl.text.isNotEmpty)
      setState(() {
        textFieldComplete = true;
      });
    else
      setState(() {
        textFieldComplete = false;
      });
  }
}
