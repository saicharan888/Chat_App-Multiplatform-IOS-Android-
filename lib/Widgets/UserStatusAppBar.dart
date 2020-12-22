

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserStatusAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(70);
  final String chatUser;

  UserStatusAppBar({ this.chatUser});
  // to display user header with status and image
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:FirebaseFirestore.instance.collection("users").where("userName",isEqualTo:chatUser).snapshots(),
        builder: (context, snapshot) {
          return snapshot.hasData ? AppBar(
            backgroundColor: Colors.purple.shade900 ,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                snapshot.data.documents[0]['userImage'] == "-1" ?
                Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text(snapshot.data.documents[0]['userName'].substring(0, 1),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 52,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w600)),
                ): CircleAvatar(
                  backgroundImage:  NetworkImage(snapshot.data.documents[0]['userImage']),
                  maxRadius: 30,
                ),
                Expanded(
                  child: Text("    "+chatUser ,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w500)
                  ),
                ),
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
          ): Container();
        }
    );
  }
}