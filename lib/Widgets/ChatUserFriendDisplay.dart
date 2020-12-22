
import 'package:chat_app/Screens/ChatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatFileTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  final String userStatus;
  final int lastMessageTime;


  ChatFileTile({this.userName,@required this.chatRoomId,this.userStatus,this.lastMessageTime});

  // Conversion of Epoch format to Month and day
  String convertToDate(int time){
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(time);
    String dateFormatter = DateFormat('MMMd').format(date);
    return dateFormatter;
  }

  // Conversion of Epoch format Hours and minutes
  String convertToHour(int time){
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(time);
    String hourFormatter = DateFormat('Hm').format(date);
    return hourFormatter;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:FirebaseFirestore.instance.collection("users").where("userName",isEqualTo:userName).snapshots(),
        builder: (context, snapshot) {
          return snapshot.hasData ? GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Chat(
                    chatUser:userName,
                    chatRoomId: chatRoomId,
                  )
              ));
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black87,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children:<Widget> [
                  snapshot.data.documents[0]['userImage']=="-1" ?
                  Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(userName.substring(0, 1),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 44,
                            fontFamily: 'OverpassRegular',
                            fontWeight: FontWeight.w600)),
                  ): CircleAvatar(
                    backgroundImage:  NetworkImage(snapshot.data.documents[0]['userImage']),
                    maxRadius: 30,
                  ),
                  Expanded(
                    child: Text("   "+userName ,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontFamily: 'OverpassRegular',
                            fontWeight: FontWeight.w500)),
                  ),
                  // Displays the last time of a message or chat file creation
                  Expanded(
                    child:
                    Column(
                      children: <Widget>[
                        Text(convertToDate(lastMessageTime),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 18,
                                fontFamily: 'OverpassRegular',
                                fontWeight: FontWeight.w500)
                        ),
                        SizedBox(height: 8,),
                        Text(convertToHour(lastMessageTime),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 18,
                                fontFamily: 'OverpassRegular',
                                fontWeight: FontWeight.w500)
                        )
                    ],
                    )
                  ),
                  // Shows the user Status
                  Text(snapshot.data.documents[0]['userStatus'],
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: snapshot.data.documents[0]['userStatus']=="online"
                              ? Colors.green: Colors.red.shade900,
                          fontSize: 16,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w500)
                  ),
                ],
              ),
            ),
          ): Container();
        }
    );
  }
}