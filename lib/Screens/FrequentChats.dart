import 'package:chat_app/Backend/DatabaseOperations.dart';
import 'package:chat_app/Backend/UserAuthentication.dart';
import 'package:chat_app/Model/LoggedInUser.dart';
import 'package:chat_app/Widgets/ChatUserFriendDisplay.dart';
import 'package:flutter/material.dart';

class FrequentChats extends StatefulWidget {
  @override
  FrequentChatsState createState() => FrequentChatsState();
}

class FrequentChatsState extends State<FrequentChats> {

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

  // User Frequent Friends List getter function
  getCurrentUserChats() async {
    DatabaseOperations().getFrequentUserChats(LoggedInUser().userName).then((
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
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "Frequently Contacted",
                      //textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Billabong',
                          fontSize: 30
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20,),
              ],
            ),
          ),
        ],
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
    );
  }
}



