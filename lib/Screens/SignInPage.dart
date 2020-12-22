import 'package:chat_app/Backend/DatabaseOperations.dart';
import 'package:chat_app/Backend/SharedPreferenceData.dart';
import 'package:chat_app/Backend/UserAuthentication.dart';
import 'package:chat_app/Model/Constants.dart';
import 'package:chat_app/Model/Dialogs.dart';
import 'package:chat_app/Model/LoggedInUser.dart';
import 'package:chat_app/Screens/ForgotPassword.dart';
import 'package:chat_app/Widgets/LoginAnimation.dart';
import 'package:chat_app/Screens/SignUpPage.dart';
import 'package:chat_app/Screens/UserChatsHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  bool isLoading=false;
  final formKey=GlobalKey<FormState>();
  Dialogs dialogs=new Dialogs();
  UserAuthentication userAuth=new UserAuthentication();
  String email,password;
  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');
  Constants conObj=new Constants();

  submit() async {
    if(formKey.currentState.validate()){
      setState(() {
        isLoading=true;
      });
      String errorReason;
      await userAuth.userSignIn(emailController.text, passwordController.text).
      then((result) async {
        if(result.uid!=null){
          try {
            QuerySnapshot userInfo =
            await DatabaseOperations().getUserInfo(emailController.text);
            LoggedInUser().setUserProfile(userInfo.docs[0].data()[conObj.userEmail],
                userInfo.docs[0].data()[conObj.userName],
                userInfo.docs[0].data()[conObj.userFirstName]
                , userInfo.docs[0].data()[conObj.userLastName],
                userInfo.docs[0].data()[conObj.userImage]
            );
            SharedPreferenceData.saveUserLoggedInSharedPreference(true);
            SharedPreferenceData.saveUserPasswordSharedPreference(passwordController.text);
            SharedPreferenceData.saveUserNameSharedPreference(
                userInfo.docs[0].data()[conObj.userName]);
            SharedPreferenceData.saveUserEmailSharedPreference(
                userInfo.docs[0].data()[conObj.userEmail]);
            DatabaseOperations().updateUserStatusOnline(userInfo.docs[0].data()[conObj.userName]);
            Navigator.pushReplacement(context, MaterialPageRoute
              (
                builder: (context) => UserChatsHome()
            ),
            );
          }
          catch(e){
            print(e);
            dialogs.information(context, "Failed to Sign In ",e.toString());
          }
        }else{
          print("sign in error block ");
          errorReason=result.error;
          dialogs.information(context, "Failed to Sign In ",errorReason);
        }
      });
      setState(() {
        isLoading=false;
        emailController.text="";
        passwordController.text="";

      });

    }
  }



  // email validation
  String validateEmailInput (String inputEmail) {
    if (inputEmail.length == 0) {
      return "Must not be empty";
    }
    RegExp regex = new RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if(!regex.hasMatch(inputEmail)){
      return "Enter valid email";
    }
    print(inputEmail);
    return null;
  }

  // to open sin up page
  openSignUp(){
    Navigator.pushReplacement(context, MaterialPageRoute
      (
        builder: (context) => SignUpScreen()
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center (
        child:SingleChildScrollView(
          child: Column(
            children:<Widget>[
              // Sign In UI animation
            Container(
            height: 370,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.fill
                )
              ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 30,
                  width: 80,
                  height: 200,
                  child: FadeAnimation(1, Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/light-1.png')
                        )
                    ),
                  )),
                ),
                Positioned(
                  left: 140,
                  width: 80,
                  height: 150,
                  child: FadeAnimation(1.3, Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/light-2.png')
                        )
                    ),
                  )),
                ),
                Positioned(
                  right: 40,
                  top: 40,
                  width: 80,
                  height: 150,
                  child: FadeAnimation(1.5, Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/clock.png')
                        )
                    ),
                  )),
                ),
                Positioned(
                  child: FadeAnimation(1.6, Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Center(
                      child: Text(
                        "Chat App",
                        style: TextStyle(
                            color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  )),
                )
              ],
            ),
            ),
              // Form to enter Sign In details
              Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 10.0
                        ),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(labelText: 'Email',border: OutlineInputBorder()),
                          validator:(input){
                            return validateEmailInput(input);
                          },
                          onSaved: (input) =>email=emailController.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 10.0
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(labelText: 'Password',border: OutlineInputBorder()),
                          validator:(input) => input.length < 4
                              ?'Must be atleast 3 characters'
                              :null,
                          onSaved: (input) =>password=passwordController.text,
                          obscureText: true,
                        ),
                      ),
                      // Button for login and Sign Up
                      SizedBox(height: 20.0,),
                      Container(
                        width: 250.0,
                        child: FlatButton(
                          onPressed: submit,
                          color: Colors.indigoAccent.shade200,
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Container(
                        width: 250.0,
                        child: FlatButton(
                          onPressed: openSignUp,
                          color: Colors.indigoAccent.shade200,
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      // Forgot password linking
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgotPassword()));
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Text(
                                  "Forgot Password?",
                                  //style: simpleTextStyle(),
                                )),
                          )
                        ],
                      ),
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
