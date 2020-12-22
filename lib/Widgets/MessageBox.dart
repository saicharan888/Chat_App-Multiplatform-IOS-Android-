

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBox extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final int lastMessageTime;

  MessageBox({@required this.message, @required this.sendByMe, this.lastMessageTime});

  // Conversion of Epoch format Date and month
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


  // Message box which decides alignment based on users
  @override
  Widget build(BuildContext context) {
    return Column(
      children:<Widget>[ Container(
        padding: EdgeInsets.only(
            top: 8,
            bottom: 0,
            left: sendByMe ? 0 : 24,
            right: sendByMe ? 24 : 0),
        child: Align(
          alignment: (!sendByMe?Alignment.topLeft:Alignment.topRight),
          child: Container(
            margin: sendByMe
                ? EdgeInsets.only(left: 20)
                : EdgeInsets.only(right: 20),
            padding: EdgeInsets.only(
                top: 17, bottom: 17, left: 20, right: 20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 2.0, color: Color(0xFFFF7F7F7F)),
                left: BorderSide(width: 2.0, color: Color(0xFFFF7F7F7F)),
                right: BorderSide(width: 2.0, color: Color(0xFFFF7F7F7F)),
                bottom: BorderSide(width: 2.0, color: Color(0xFFFF7F7F7F)),
              ),
              borderRadius: sendByMe ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23)
              ) :BorderRadius.only(
                  bottomRight: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23)
              ),
              color: (sendByMe?Colors.grey.shade100:Colors.grey.shade300),
            ),
            child : Text(
                      message,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          // fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w400
                      )
                  ),
            )
          ),
        ),
        Container(
          padding: EdgeInsets.only(
              top: 2,
              bottom: 2,
              left: sendByMe ? 0 : 24,
              right: sendByMe ? 24 : 0
          ),
          child: Align(
          alignment: (!sendByMe?Alignment.topLeft:Alignment.topRight),
            child: Container(

            child: Text(convertToDate(lastMessageTime)+" "+convertToHour(lastMessageTime),
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 15,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w500)
            ),
            ),
          ),
        ),
    ],
    );
  }
}