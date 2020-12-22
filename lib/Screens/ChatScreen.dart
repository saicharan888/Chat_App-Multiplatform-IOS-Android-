


import 'package:chat_app/Backend/DatabaseOperations.dart';
import 'package:chat_app/Model/LoggedInUser.dart';
import 'package:chat_app/Widgets/MessageBox.dart';
import 'package:chat_app/Widgets/UserStatusAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;
  final String chatUser;

  Chat({this.chatRoomId,this.chatUser});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final formKey=GlobalKey<FormState>();
  String message;
  TextEditingController messageController = TextEditingController(text: '');
  Stream<QuerySnapshot> chats;
  DatabaseOperations dbObj=new DatabaseOperations();
  ScrollController scrollController = new ScrollController();

  submit(){
    addMessage();
    setState(() {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }


  Widget appBar(){
    // Displaying app bar which consists of user Status
    return UserStatusAppBar(chatUser: widget.chatUser);
  }


  // display chat messages between users
  Widget chatMessages(){
    return SingleChildScrollView(
      child: Column(
        children:<Widget>[
         StreamBuilder(
          stream: chats,
          builder: (context, snapshot){
            return snapshot.hasData ?  ListView.builder(
                controller: scrollController,
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index){
                  return MessageBox(
                    message: snapshot.data.documents[index].data()["message"],
                    sendByMe: LoggedInUser().userName == snapshot.data.documents[index].data()["sendBy"],
                    lastMessageTime: snapshot.data.documents[index].data()["time"],
                  );
                }) : Container();
          },
        ),
          SizedBox(height: 80,)
      ]
      ),
    );
  }

  // Add message to database in chat file between users
  addMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": LoggedInUser().userName,
        "message": messageController.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      };

      dbObj.addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageController.text = "";
      });
    }
  }

  @override
  void initState() {
    DatabaseOperations().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Container(
        child: Stack(
          children:<Widget> [
            chatMessages(),
            // From to send messages
            Form(
              key: formKey,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 16,bottom: 10),
                  height: 75,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 2,),
                      Expanded(
                        child : TextFormField(
                          controller: messageController,
                          decoration: InputDecoration(
                              labelText: 'Type message',
                              border: OutlineInputBorder()
                          ),
                          onSaved: (input) =>message=messageController.text,
                          //obscureText: true,
                        ),
                      ),
                      SizedBox(width: 8,),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: EdgeInsets.only(right: 5,bottom: 5),
                          child: FloatingActionButton(
                            onPressed: (){
                              submit();
                            },
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.black87,
                            elevation: 0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      //bottomNavigationBar: getFooter(),
    );
  }

}



