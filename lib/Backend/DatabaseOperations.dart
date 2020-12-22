
import 'dart:io';
import 'package:chat_app/Model/LoggedInUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseOperations {

  final db = FirebaseFirestore.instance;

  // To add user to Firebase
  Future<String> addUserInfo(userData) async {
    db.collection("users")
        .doc(userData["userName"])
        .set(userData).catchError((e) {
      return e.toString();
    });
    return "true";
  }

  // To update user first name and last name in Firebase
  setUserFirstAndLastName(String userName,String firstName,String lastName){
    db.collection("users")
        .doc(userName)
        .update({
      "userFirstName":firstName,
      "userLastName":lastName
    });

  }

  // to check if user already exists in firebase before signup
  Future<String> checkUserDetails(String userName,String userEmail) async {
    try {

      QuerySnapshot qSnapName = await db.collection('users')
          .where("userName", isEqualTo: userName)
          .get();
      int userDocs = qSnapName.docs.length;
      print("user Docs"+ "$userDocs");
      if (userDocs > 0) {
        return "User Name already exits";
      } else {
        QuerySnapshot qSnapEmail = await db.collection('users')
            .where("userEmail", isEqualTo: userEmail)
            .get();
        int emailDocs = qSnapEmail.docs.length;
        print("email Docs"+ "$emailDocs");
        if (emailDocs > 0) {
          return "Email already exits";
        } else {
          return "success";
        }
      }
    }
    catch(e){
      return e.toString();
    }
  }

  // to get network url for the given image
  Future<String> uploadFile(File _image) async {
    var time=DateTime
          .now()
          .millisecondsSinceEpoch;
    Reference storageReference = FirebaseStorage.instance
        .ref().child('userImages/$time');
    UploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.whenComplete(() => {print("complete")});
    print('File Uploaded');
    String returnURL;
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL =  fileURL;
    });
    return returnURL;
  }

  //add get image url
  Future<String> addImage(File image,String userName) async {
    String imageURL = await uploadFile(image);
    return imageURL;
  }

  // update user status offline
  updateUserStatusOffline(String userName) async {
    print("sign out offline");
    await db.collection("users")
        .doc(userName)
        .update({
      "userStatus":"offline"
    });
  }

  // update user status online
  updateUserStatusOnline(String userName){
    db.collection("users")
        .doc(userName)
        .update({
      "userStatus":"online"
    });
  }

  //  update user image to firebase
  updateImage(String userName,String imageURL){
    db.collection("users")
        .doc(userName)
        .update({
      "userImage":imageURL
    });

  }

  // get user details by email
  getUserInfo(String email) async {
    return db
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  // get user details by user name
  getUserProfile(String userName) async {
    return db
        .collection("users")
        .where('userName', isEqualTo: userName )
        .snapshots();
  }

  // search by name
  searchByName(String searchField) {
    return db
        .collection("users")
        .where('userName', isEqualTo: searchField)
        .get();
  }


  // retrieve all users
  searchAllUsers() {
    return db
        .collection("users")
        .get();
  }

  // search by email
  searchByEmail(String searchField) {
    return db
        .collection("users")
        .where('userEmail', isEqualTo: searchField)
        .get();
  }

  // create chat file between users
  Future<void> addChatFile(chatRoom, chatFileId) async {
    var chatRooms = db.collection("chatRoom").doc(chatFileId);
    var doc=await chatRooms.get();
    if(!doc.exists){
      db.collection("chatRoom")
          .doc(chatFileId)
          .set(chatRoom)
          .catchError((e) {
        print(e);
      });
      print("new room created ");
    }else{
      print("Room already exists ");
    }
  }

  // get chats of a chat file between users
  getChats(String chatFileId) async{
    return db
        .collection("chatRoom")
        .doc(chatFileId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  // update time of last message sent
  updateTime(String chatRoomId){
    CollectionReference chatRooms = db.collection("chatRoom");
    chatRooms.doc(chatRoomId).update({
      'time': DateTime
          .now()
          .millisecondsSinceEpoch
    }).then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));

  }

  // update count of messages
  updateCount(String chatRoomId){
    CollectionReference chatRooms = db.collection("chatRoom");
    chatRooms.doc(chatRoomId).update({
      'count': FieldValue.increment(1)
    }).then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  // add message to chat file between users
  addMessage(String chatRoomId, chatMessageData){
    db.collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
      print(e.toString());
    });
    updateTime(chatRoomId);
    updateCount(chatRoomId);

  }

  // set stored  user profile
  Future<void> setCurrentUserProfile(String inputEmail) async {
    print("entered db");
    await db.collection("users").where('userEmail', isEqualTo: inputEmail)
        .get()
        .then((QuerySnapshot querySnapshot)=> {
          querySnapshot.docs.forEach((doc){
            LoggedInUser().setUserProfile(doc["userEmail"],
                doc["userName"], doc["userFirstName"]
                ,doc["userLastName"],doc["userImage"]
            );
            print("from db");
            print(doc["userName"]);
            print(doc["userFirstName"]);
            print(doc["userLastName"]);
            print(doc["userStatus"]);
            print(doc["userEmail"]);
          })
        });
    print("exit db");
  }

  // get user chats by time
  getUserChats(String itIsMyName) async {
    return db
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .orderBy('time', descending: true)
        .snapshots();
  }

  getFrequentUserChats(String itIsMyName) async {
    return db
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .orderBy('count', descending: true)
        .snapshots();
  }



}
