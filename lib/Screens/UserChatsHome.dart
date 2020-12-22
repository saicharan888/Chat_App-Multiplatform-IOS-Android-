import 'package:chat_app/Backend/DatabaseOperations.dart';
import 'package:chat_app/Backend/SharedPreferenceData.dart';
import 'package:chat_app/Backend/UserAuthentication.dart';
import 'package:chat_app/Model/LoggedInUser.dart';
import 'package:chat_app/Screens/FrequentChats.dart';
import 'package:chat_app/Screens/SearchSelection.dart';
import 'package:chat_app/Screens/SignInPage.dart';
import 'package:chat_app/Screens/UserProfile.dart';
import 'package:chat_app/Widgets/ChatUserFriendDisplay.dart';
import 'package:flutter/material.dart';

class UserChatsHome extends StatefulWidget {
  @override
  UserChatsHomeState createState() => UserChatsHomeState();
}

class UserChatsHomeState extends State<UserChatsHome> {

   Stream userChatRooms;
   UserAuthentication userObj=new UserAuthentication();


   // User Chats Display
    Widget currentUserChatList() {
    return StreamBuilder(
        stream: userChatRooms,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? snapshot.data.documents.length!=0 ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // View of each friends of User
                return ChatFileTile(
                  userName: snapshot.data.documents[index].data()['chatRoomId']
                      .toString()
                      .replaceAll("_", "")
                      .replaceAll(LoggedInUser().userName, ""),
                  chatRoomId: snapshot.data.documents[index]
                      .data()["chatRoomId"],
                  lastMessageTime:snapshot.data.documents[index]
                      .data()["time"]
                );
                }
               ):Container(
                  alignment: Alignment.center,
                  child: Text(
                      "No chats to display",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                      )
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  child: Text(
                  "Loading..",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  )
                ),
          ) ;
        }
    );
  }

  void initState() {
    getCurrentUserChats();
    super.initState();
  }

  // User Friends List getter function
  getCurrentUserChats() async {
    DatabaseOperations().getUserChats(LoggedInUser().userName).then((
        snapshots) {
      setState(() {
        userChatRooms = snapshots;
        print(
            "Data Loaded + ${userChatRooms
                .toString()}  name : ${LoggedInUser().userName}"
        );
      });
    });
  }

  // Logout of current User
  logoutUser(){
    userObj.userSignOut();
    DatabaseOperations().updateUserStatusOffline(LoggedInUser().userName);
    SharedPreferenceData.saveUserLoggedInSharedPreference(false);
    Navigator.pushReplacement(context, MaterialPageRoute
      (
        builder: (context) => SignInScreen()
    ),
    );
  }

  // App Bar contains Logout icon
  Widget getAppBar() {
    return AppBar(
      toolbarHeight: 75,
      backgroundColor: Colors.purple.shade900 ,
      title:
      Column(
        children:<Widget> [
          SizedBox(height: 1,),
          Padding(
            padding:  EdgeInsets.only(left: 20, right:5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(width: 20,),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "Chats",
                      //textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Billabong',
                          fontSize: 50
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 180,),
                Column(
                  children:<Widget> [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: EdgeInsets.only(right: 5),
                        child: FloatingActionButton(
                          onPressed: (){
                            logoutUser();
                          },
                          child: Icon(
                            Icons.exit_to_app,
                            color: Colors.white,
                            size: 40,
                          ),
                          backgroundColor: Colors.black87,
                          elevation: 0,
                        ),
                      ),
                    ),
                    Text("Sign Out",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Footer with search and profile icons
  Widget getFooter() {
    return Container(
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(color: Colors.purple.shade900),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Padding(
              padding:
              const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => FrequentChats()
                      ));
                    },
                    icon: Icon(
                      Icons.message,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SearchSelectionPage()
                      ));
                    },
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => UserProfile()
                      ));
                    },
                    icon: Icon(
                      Icons.account_circle,
                      semanticLabel: "hi",
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:<Widget> [
                  Text("Frequent",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        //fontSize: 14
                      ),
                  ),
                  Text("Search ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                  Text("Profile",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  )
                ],
              ),
            ),
          ]
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: Scaffold(
        body: currentUserChatList(),
      ),
      bottomNavigationBar: getFooter(),
    );
  }
}



