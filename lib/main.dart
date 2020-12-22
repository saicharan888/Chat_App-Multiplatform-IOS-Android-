import 'package:chat_app/Backend/DatabaseOperations.dart';
import 'package:chat_app/Backend/SharedPreferenceData.dart';
import 'package:chat_app/Backend/UserAuthentication.dart';
import 'package:chat_app/Screens/SignInPage.dart';
import 'package:chat_app/Screens/UserChatsHome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //SharedPreferences.setMockInitialValues({});
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userStatus;
  bool isLoading=true;

  @override
  void initState() {
    getUserLoggedInState();
    super.initState();
  }

  Future<Null> getUserLoggedInState() async {
    try{
      bool correctPasswordIndicator=false;
      await SharedPreferenceData.getUserLoggedInSharedPreference().then((value)  async {
        if(value==true){
          print(value);
          String inputEmail=await SharedPreferenceData.getUserEmailSharedPreference();
          String inputPassword=await SharedPreferenceData.getUserPasswordSharedPreference();
          print(inputEmail);
          DatabaseOperations dbObj=new DatabaseOperations();
          UserAuthentication userAuth=new UserAuthentication();
          await userAuth.userSignIn(inputEmail, inputPassword).
          then((result) async {
            if(result.uid!=null){
              correctPasswordIndicator=true;
              await dbObj.setCurrentUserProfile(inputEmail);
            }
          });

        }
        print(value);
        setState(() {
          isLoading=false;
          userStatus  = (value == null ? false : value) && correctPasswordIndicator;
        });
      });
    }catch(e){
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      home: isLoading ? Container(
        alignment: Alignment.center,
        child: Text(
            "Loading..",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            )
              ),
      )  : userStatus != null ?  userStatus ? UserChatsHome() : SignInScreen()
          : Container(
        child: Center(
          child: SignInScreen(),
        ),
      ),
    );
  }
}



