import 'dart:io';

import 'package:chat_app/Backend/DatabaseOperations.dart';
import 'package:chat_app/Model/LoggedInUser.dart';
import 'package:chat_app/Widgets/UserView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Stream userProfile;
  File image;
  bool imageUploaded=false;
  String imageUrlToUpload;
  File userSelectedImage;
  bool isImageSelected=false;
  final formKey=GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController(text: '');
  TextEditingController lastNameController = TextEditingController(text: '');
  String firstName,lastName;
  final ImagePicker picker = ImagePicker();
  PickedFile imageFile;

  void initState() {
    loadUserProfile();
    super.initState();
  }


  loadUserProfile() async {
    DatabaseOperations().getUserProfile(LoggedInUser().userName).then((
        snapshots) {
      setState(() {
        userProfile = snapshots;
        print(
            "Data Loaded + ${userProfile
                .toString()} this is name  ${LoggedInUser().userName}"
        );
      });
    });
  }

  // uploading profile details to firebase
  updateDetails(){
    if(formKey.currentState.validate()){
      DatabaseOperations().setUserFirstAndLastName(LoggedInUser().userName,firstNameController.text,lastNameController.text);
      setState(() {
        firstNameController.text="";
        lastNameController.text="";
      });
    }
    if(isImageSelected){
      DatabaseOperations().updateImage(LoggedInUser().userName, imageUrlToUpload);
      setState(() {
        isImageSelected=false;
      });
    }
  }

  // Image selection from Gallery
  Future getUserImage() async {
    PickedFile pickedFile = await picker.getImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 400.0);
    if(pickedFile!=null){
      print("image selected from gallery");
      image = File(pickedFile.path);
      String imageRetrievedUrl=await DatabaseOperations().addImage(image,LoggedInUser().userName);
      setState(() {
        isImageSelected=true;
        userSelectedImage=image;
        imageUrlToUpload=imageRetrievedUrl;
      });
    }
  }

  // Image selection from Camera Roll
  Future getCameraRoll() async {
    PickedFile pickedFile = await picker.getImage(
        source: ImageSource.camera, imageQuality: 50, maxWidth: 400.0);

    if(pickedFile!=null){
      print("image selected from camera roll");
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

  // Options pop up for Image Selection either camera Roll or Gallery
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

  // App bar of User Profile
  Widget getAppBar() {
    return AppBar(
      toolbarHeight: 75,
      backgroundColor: Colors.purple.shade900 ,
      title:
      Column(
        children:<Widget> [
          SizedBox(height: 1,),
          Padding(
            padding:  EdgeInsets.only(left: 20, right:30),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "User Profile",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Billabong',
                          fontSize: 50
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // User Profile widget contains details and forms to update
  Widget currentUserProfile() {
    return StreamBuilder(
        stream: userProfile,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? SingleChildScrollView(
                child: Column(
                  children:<Widget> [
                    // profile view from stream builder
                    Info(
                      image: snapshot.data.documents[0].data()['userImage'],
                      name: snapshot.data.documents[0].data()['userName'],
                      email:snapshot.data.documents[0].data()['userEmail'] ,
                      firstName:snapshot.data.documents[0].data()['userFirstName'],
                      lastName:snapshot.data.documents[0].data()['userLastName']
                    ),
                    // Form to update user details
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
                                decoration: InputDecoration(
                                  labelText: 'Edit First Name',border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                ),
                                validator:(input) => input.length == 0
                                    ?'Please enter valid first name'
                                    :null,
                                onSaved: (input) =>firstName=firstNameController.text,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0,
                                  vertical: 2.0
                              ),
                              child: TextFormField(
                                controller: lastNameController,
                                decoration: InputDecoration(
                                  labelText: 'Edit Last Name',border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                ),
                                validator:(input) => input.length == 0
                                    ?'Please enter valid last name'
                                    :null,
                                onSaved: (input) =>lastName=lastNameController.text,
                              ),
                            ),
                          ],
                        )
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Icon to upload Image
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text("Update Image:",
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
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      color: Colors.blue,
                      width: 250.0,
                      child: FlatButton(
                        onPressed:updateDetails ,
                        //color: Colors.red,
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Update Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            // Loading text
              : Container(
                child:  Text(
                    "Loading...",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    )
                ),
          );
        }
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: Scaffold(
        //backgroundColor: Colors.purpleAccent,
        body: currentUserProfile(),
      ),
    );
  }
}
