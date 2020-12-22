
import 'dart:io';

import 'package:chat_app/Backend/DatabaseOperations.dart';
import 'package:chat_app/Backend/SharedPreferenceData.dart';
import 'package:chat_app/Backend/UserAuthentication.dart';
import 'package:chat_app/Model/Dialogs.dart';
import 'package:chat_app/Model/LoggedInUser.dart';
import 'package:chat_app/Screens/UserChatsHome.dart';
import 'package:chat_app/Model/Constants.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/Screens/SignInPage.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {


  Constants conObj=new Constants();
  bool isImageSelected=false;
  DatabaseOperations dbObj=new DatabaseOperations();
  Dialogs dialogs=new Dialogs();
  bool processing=false;
  File userSelectedImage;
  String imageUrlToUpload="-1";
  final formKey=GlobalKey<FormState>();
  UserAuthentication userAuth=new UserAuthentication();
  final ImagePicker picker = ImagePicker();
  PickedFile imageFile;
  File image;

  String firstName,lastName,email,password,userName;
  TextEditingController firstNameController = TextEditingController(text: '');
  TextEditingController lastNameController = TextEditingController(text: '');
  TextEditingController userNameController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');

  submit() async {
    if(formKey.currentState.validate()){
      setState(() {
        processing=true;
      });

      // Sign Up validation and storing
      String checkResult=await dbObj.checkUserDetails(userNameController.text, emailController.text);
      if(checkResult=="success") {
        userAuth.userSignUp(emailController.text, passwordController.text)
            .then((output) async {
          if (output != null) {
            Map<String, String> userData = {
              conObj.userFirstName: firstNameController.text,
              conObj.userLastName: lastNameController.text,
              conObj.userStatus: conObj.onlineStatus,
              conObj.userName: userNameController.text,
              conObj.userEmail: emailController.text,
              conObj.userImage: imageUrlToUpload
            };
            String result = await dbObj.addUserInfo(userData);
            if (result == "true") {

              // setting up user profile
              LoggedInUser().setUserProfile(emailController.text,
                  userNameController.text, firstNameController.text
                  , lastNameController.text, imageUrlToUpload
              );

              // Storing data in shared preferences
              SharedPreferenceData.saveUserLoggedInSharedPreference(true);
              SharedPreferenceData.saveUserPasswordSharedPreference(passwordController.text);
              SharedPreferenceData.saveUserNameSharedPreference(
                  userNameController.text);
              SharedPreferenceData.saveUserEmailSharedPreference(
                  emailController.text);

              // Navigation to user chats
              Navigator.pushReplacement(context, MaterialPageRoute
                (
                  builder: (context) => UserChatsHome()
              ),
              );
            } else {
              dialogs.information(context, "Failed to Add User", result);
            }
          }
          setState(() {
            processing=false;
          });
        });
      }else{
        setState(() {
          processing=false;
        });
        dialogs.information(context, "Failed to Add User", checkResult);
      }
    }
  }

  // Gallery Image Selection
  Future getUserImage() async {
    PickedFile pickedFile = await picker.getImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 400.0);
    // https://github.com/firebase/firebase-android-sdk/issues/1662
    if(pickedFile!=null){
      print("image selected");
      image = File(pickedFile.path);
      String imageRetrievedUrl=await DatabaseOperations().addImage(image,LoggedInUser().userName);
      setState(() {
        isImageSelected=true;
        userSelectedImage=image;
        imageUrlToUpload=imageRetrievedUrl;
      });
    }
  }

  // Camera Roll Image selection
  Future getCameraRoll() async {
    PickedFile pickedFile = await picker.getImage(
        source: ImageSource.camera, imageQuality: 50, maxWidth: 400.0);

    if(pickedFile!=null){
      print("image selected2");
      image = File(pickedFile.path);
      String imageRetrievedUrl=await DatabaseOperations().addImage(image,LoggedInUser().userName);
      setState(() {
        isImageSelected=true;
        userSelectedImage=image;
        imageUrlToUpload=imageRetrievedUrl;
      });
    }else{
      print("No image selected");
    }
  }

  // Image Selection pop up
  void showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        getUserImage();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Camera Roll'),
                      onTap: () {
                        getCameraRoll();
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          );
        }
    );
  }

  //email validation
  String validateEmailInput (String inputEmail) {
    if (inputEmail.length == 0) {
      return "Must not be empty";
    }
    RegExp regex = new RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
   if(!regex.hasMatch(inputEmail)){
      return "Enter valid email";
   }
    print("passed");
    return null;
  }

// Sign In navigation
  openSignIn(){
    Navigator.pushReplacement(context, MaterialPageRoute
      (
        builder: (context) => SignInScreen()
    ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center (
        child: processing ? Container(
          child: CircularProgressIndicator(),
        ) : SingleChildScrollView(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget>[
              Text(
                'Chat App',
                style: TextStyle(
                  fontFamily:'Billabong',
                  fontSize:50.0,
                ),
              ),
              // Form for SignUp
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
                          controller: firstNameController,
                          decoration: InputDecoration(labelText: 'First Name',border: OutlineInputBorder()),
                          validator:(input) =>input.isEmpty?'Please Enter Valid Text':null,
                          onSaved: (input) =>firstName=firstNameController.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 10.0
                        ),
                        child: TextFormField(
                          controller: lastNameController,
                          decoration: InputDecoration(labelText: 'Last Name',border: OutlineInputBorder()),
                          validator:(input) =>input.isEmpty?'Please Enter Valid Text':null,
                          onSaved: (input) =>lastName=lastNameController.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 10.0
                        ),
                        child: TextFormField(
                          controller: userNameController,
                          decoration: InputDecoration(labelText: 'User Name',border: OutlineInputBorder()),
                          validator:(input) =>(input.length < 4 || input.length > 15)
                              ?'Must be between 4 characters to 15 characters'
                              :null,
                          onSaved: (input) =>userName=userNameController.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 10.0
                        ),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(labelText: 'Email',border: OutlineInputBorder()),
                          validator:(input) =>validateEmailInput(input),
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
                          validator:(input) => (input.length < 5 )
                              ?'Must be atleast than 6 characters'
                              :null,
                          onSaved: (input) =>password=passwordController.text,
                          obscureText: true,
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Upload Image:",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 20,
                              fontWeight:FontWeight.bold,// 22
                              color: Colors.black87,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                showPicker(context);
                              });
                            },
                            icon: Icon(
                              Foundation.photo,
                              color: Colors.black87,
                              size: 50,
                            ),
                          ),
                          Text(isImageSelected ? "Image Selected" :"No Image Selected",
                              //textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: isImageSelected
                                      ? Colors.green : Colors.red.shade900 ,
                                  fontSize: 16,
                                  fontFamily: 'OverpassRegular',
                                  fontWeight: FontWeight.w500)
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0,),
                      // Buttons for Sign up and login navigation
                      Container(
                        width: 250.0,
                        child: FlatButton(
                          onPressed: submit,
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
                      SizedBox(height: 8.0,),
                      Container(
                        width: 250.0,
                        child: FlatButton(
                          onPressed: openSignIn,
                          color: Colors.indigoAccent.shade200,
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Back to Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
