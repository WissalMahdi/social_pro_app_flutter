// ignore_for_file: prefer_const_constructors,, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, unnecessary_new, unused_element, unused_local_variable, unused_label, deprecated_member_use, valid_regexps, avoid_print, unused_field

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_pro_app_flutter/config/palette.dart';

import '../acceuil.dart';
import '../services/registration.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({Key? key}) : super(key: key);

  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool isMale = true;
  bool isSignupScreen = true;
  bool isRememberMe = false;
  //final bool _isExpanded = false;
  //String? _dropDownValue;
  String? valueChoose;
  List listItems = ['Formateur', 'Apprenant', 'Employeur'];
  var fnameController = new TextEditingController();
  var emailController = new TextEditingController();
  var pwdController = new TextEditingController();
  bool _isObscure = true;
  final formKey = GlobalKey<FormState>(); //Key for Form

  final _auth = FirebaseAuth.instance;
  final RegistrationServices auth = RegistrationServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: Stack(
        children: [
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/background.png"),
                        fit: BoxFit.fill)),
                child: Container(
                  padding: EdgeInsets.only(top: 90, left: 20),
                  color: Color.fromARGB(255, 88, 114, 170).withOpacity(.85),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(
                                text: "WELCOME__",
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                children: [
                              TextSpan(
                                  text: isSignupScreen ? "__User," : "_Back,",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  )),
                            ])),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          isSignupScreen
                              ? "Signup To Continue"
                              : "Signin To Continue",
                          style: TextStyle(
                            letterSpacing: 5,
                            color: Colors.white,
                          ),
                        )
                      ]),
                ),
              )),
          //Trick to add the shadow for the submit button
          buildBottomHalfContainer(true),

          //Main container for box login and signup
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInCubic,
            top: isSignupScreen ? 200 : 230,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInCubic,
              height: isSignupScreen ? 450 : 300,
              padding: EdgeInsets.all(20),
              //width: _isExpanded ? -40 : 315,
              width: MediaQuery.of(context).size.width - 40,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5),
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = false;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "LOGIN",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: !isSignupScreen
                                        ? Palette.activeColor
                                        : Palette.textColor1),
                              ),
                              if (!isSignupScreen)
                                Container(
                                  margin: EdgeInsets.only(top: 3),
                                  height: 2,
                                  width: 55,
                                  color: Color.fromARGB(255, 6, 40, 230),
                                )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = true;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "SIGNUP",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSignupScreen
                                        ? Palette.activeColor
                                        : Palette.textColor1),
                              ),
                              if (isSignupScreen)
                                Container(
                                  margin: EdgeInsets.only(top: 3),
                                  height: 2,
                                  width: 55,
                                  color: Color.fromARGB(255, 10, 14, 223),
                                )
                            ],
                          ),
                        )
                      ],
                    ),
                    if (isSignupScreen) buildSignupSection(),
                    if (!isSignupScreen) buildSigninSection()
                  ],
                ),
              ),
            ),
          ),
          // Trick to add a submit buttom
          buildBottomHalfContainer(false)
        ],
      ),
    );
  }

// EL Box mta3 signIn (Login)
  Container buildSigninSection() {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Form(
          key: formKey,
          child: Column(children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                labelText: "Email",
                filled: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Palette.textColor1, width: 1),
                    borderRadius: BorderRadius.circular(30)),
              ),
              validator: (value) {
                if (value!.isEmpty || RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                  return "Enter correct email";
                } else {
                  return null;
                }
              },
              controller: emailController,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              obscureText: _isObscure,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                labelText: "Password",
                filled: true,
                suffixIcon: IconButton(
                    icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    }),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Palette.textColor1, width: 1),
                    borderRadius: BorderRadius.circular(30)),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
                        .hasMatch(value)) {
                  return "Enter correct Password \n at least : \n - 1 Upper case \n - 1 lowercase \n - 1 Numeric Number";
                } else {
                  return null;
                }
              },
              controller: pwdController,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: isRememberMe,
                      activeColor: Palette.textColor2,
                      onChanged: (value) {
                        setState(() {
                          isRememberMe = !isRememberMe;
                        });
                      },
                    ),
                    Text(
                      "Remember me",
                      style: TextStyle(fontSize: 12, color: Palette.textColor1),
                    )
                  ],
                ),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(fontSize: 12, color: Palette.textColor1),
                    ))
              ],
            )
          ]),
        ));
  }

// zone de texte of SIGNUP (user name, pwd and email)
  Container buildSignupSection() {
    //final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
    //  key:
    // _scaffoldkey;
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Form(
            key: formKey,
            child: Column(children: [
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.account_circle_outlined),
                  labelText: "Full Name",
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Palette.textColor1, width: 1),
                      borderRadius: BorderRadius.circular(50)),
                ),
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                    return "Enter correct name";
                  } else {
                    return null;
                  }
                },
                controller: fnameController,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  labelText: "Email",
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Palette.textColor1, width: 1),
                      borderRadius: BorderRadius.circular(30)),
                ),
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp('^([A-Za-z0-9_\\-\\.])+@').hasMatch(value)) {
                    return "Enter correct email";
                  } else {
                    return null;
                  }
                },
                controller: emailController,
              ),
              SizedBox(
                height: 10,
              ),

              TextFormField(
                obscureText: _isObscure,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  labelText: "Password",
                  filled: true,
                  suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      }),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Palette.textColor1, width: 1),
                      borderRadius: BorderRadius.circular(50)),
                ),
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
                          .hasMatch(value)) {
                    return "Enter correct Password \n at least : \n - 1 Upper case \n - 1 lowercase \n - 1 Numeric Number";
                  } else {
                    return null;
                  }
                },
                controller: pwdController,
              ),

              // liste de choix(DropDown list )

              /*  DropdownButtonFormField<String>(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide(color: Palette.textColor1, width: 1)),
              prefixIcon: Icon(
                Icons.person,
                color: Palette.textColor1,
              ),
            ),
            hint: Text(
              'Please choose account type',
              style: TextStyle(color: Palette.textColor1),
          ),
            items: <String>['A', 'B', 'C', 'D'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (_) {},
        ),*/

              /*  Container(
            decoration: BoxDecoration(
                border: Border.all(color: Palette.textColor1, width: 1),
                borderRadius: BorderRadius.circular(25)),
            child: DropdownButton(
              hint: Text(
                "Please choose your role :",
                style: TextStyle(
                  color: Palette.textColor1,
                ),
              ),
              dropdownColor: Colors.white,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 30,
              isExpanded: true,
              underline: SizedBox(),
              style: TextStyle(color: Colors.black, fontSize: 15),
              value: valueChoose,
              onChanged: (newValue) {
                setState(
                  () {
                    valueChoose = newValue as String;
                  },
                );
              },
              items: listItems.map((valueItem) {
                return DropdownMenuItem(
                  // child: Text(valueItem),
                  value: valueItem,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.person_pin),
                        color: Palette.textColor1,
                        onPressed: () {},
                      ),
                      Text(valueItem),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),*/

              // Male and Female Buttons
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isMale = true;
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                                color: isMale
                                    ? Palette.textColor2
                                    : Colors.transparent,
                                border: Border.all(
                                    width: 1,
                                    color: isMale
                                        ? Colors.transparent
                                        : Palette.textColor1),
                                borderRadius: BorderRadius.circular(15)),
                            child: Icon(
                              MaterialCommunityIcons.account_outline,
                              color: isMale ? Colors.white : Palette.iconColor,
                            ),
                          ),
                          Text(
                            "Male",
                            style: TextStyle(color: Palette.textColor1),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isMale = false;
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                                color: isMale
                                    ? Colors.transparent
                                    : Palette.textColor2,
                                border: Border.all(
                                    width: 1,
                                    color: isMale
                                        ? Palette.textColor1
                                        : Colors.transparent),
                                borderRadius: BorderRadius.circular(15)),
                            child: Icon(
                              MaterialCommunityIcons.account_outline,
                              color: isMale ? Palette.iconColor : Colors.white,
                            ),
                          ),
                          Text(
                            "Female",
                            style: TextStyle(color: Palette.textColor1),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              // Text by pressing 'Submit' you agree to our
              Container(
                width: 200,
                margin: EdgeInsets.only(top: 20),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "By pressing 'Submit' you agree to our ",
                      style: TextStyle(color: Palette.textColor2),
                      children: [
                        TextSpan(
                          text: "term & conditions",
                          style:
                              TextStyle(color: Color.fromARGB(255, 28, 8, 207)),
                        )
                      ]),
                ),
              )
            ])));
  }

// lfazet mta3 l'annimation wel circle l bidha elli m louta
  Widget buildBottomHalfContainer(bool showShadow) {
    final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

    key:
    _scaffoldkey;
    return AnimatedPositioned(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInCubic,
        top: isSignupScreen ? 600 : 483,
        right: 0,
        left: 0,
        child: Center(
          child: Container(
            height: 90,
            width: 90,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                if (showShadow)
                  BoxShadow(
                      color: Color.fromARGB(255, 4, 0, 243).withOpacity(.3),
                      spreadRadius: 1.5,
                      blurRadius: 10,
                      offset: Offset(0, 1))
              ],
            ),

            //el doura zar9a elli feha l fléche elli m louta
            child: !showShadow
                ? Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 164, 203, 231),
                              Color.fromARGB(255, 37, 104, 185)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(.3),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 1))
                        ]),
                    child: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (isSignupScreen) {
                              // _signUp();
                              createUser();

                              _insertData(fnameController.text,
                                  emailController.text, pwdController.text);
                            } else {
                              User? user = await loginUsingEmailPassword(
                                  email: emailController.text,
                                  password: pwdController.text,
                                  context: context);
                              print(user);
                              if (user != null) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Acceuil()));
                              }

                              // singIn(fnameController.text, pwdController.text);

                              /*Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Acceuil()));*/
                            }
                          }
                        }))
                : Center(),
          ),
        ));
  }

  Widget buildTextField(
      IconData icon, String hintText, bool isPassword, bool isEmail,
      {TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Palette.iconColor,
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 199, 167, 167)),
              borderRadius: BorderRadius.all(Radius.circular(35.0))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Palette.textColor1),
              borderRadius: BorderRadius.all(Radius.circular(35.0))),
          contentPadding: EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Palette.textColor1),
        ),
      ),
    );
  }

  // Firebase authentification LogIn
  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.code);
      /*if (e.code == "user_not_found") {
        Fluttertoast.showToast(msg: e.code);
        // print("No User found for that mail");
      }*/
    }
    return user;
  }

  Future<Void?> _insertData(String fName, String eml, String pwd) async {
    Map<String, dynamic> data = {
      "FirstName": fnameController.text,
      "Email": emailController.text,
      "Password": pwdController.text
    };
    FirebaseFirestore.instance.collection("Authentification").add(data);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Your registration has been successfully completed, PLEASE LOGIN NOW ")));
    _clearAll();
    return null;
  }

  void _clearAll() {
    fnameController.text = "";
    emailController.text = "";
    pwdController.text = "";
  }

  /* Future _signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: pwdController.text.trim());

      await FirebaseFirestore.instance.collection('users').add({
        'email': emailController.text.trim(),
        'password': pwdController.text.trim(),
        'FullName': fnameController.text.trim()
      });
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Sign up succeeded'),
                content: Text('You account was created, you can now log in'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('ok'))
                ],
              ));
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      _handleSignUpError(e);
    }
  }

  void _handleSignUpError(FirebaseAuthException e) {
    String messageToDisplay;
    switch (e.code) {
      case 'email-already-in-use':
        messageToDisplay = 'This email is already use';
        break;
      case 'invalid-email':
        messageToDisplay = 'the email you ented is invalid';
        break;
    }
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Sign up failed'),
              //content: Text(messageToDisplay),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('ok'))
              ],
            ));
  }*/

  // ------- 2éme méthode de registartion de données --------
  void createUser() async {
    dynamic result = await auth.createNewUser(
        emailController.text.trim(), pwdController.text.trim());
    if (result == null) {
      print('email is not valid');
    } else {
      print(result.toString());
    }
  }
}
