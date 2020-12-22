
import 'package:chat_app/Backend/DatabaseOperations.dart';
import 'package:chat_app/Model/Dialogs.dart';
import 'package:chat_app/Model/LoggedInUser.dart';
import 'package:chat_app/Screens/ChatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  final int id;
  Search({Key key,@required this.id}): super (key:key);
  @override
  _SearchState createState() => _SearchState(id);
}

class _SearchState extends State<Search> {

  int id;
  _SearchState(this.id);
  DatabaseOperations db = new DatabaseOperations();
  QuerySnapshot searchResultSnapshot;
  TextEditingController searchController = new TextEditingController();
  String searchUserName;
  final formKey=GlobalKey<FormState>();
  bool isLoading = false;
  bool haveUserSearched = false;
  String appBarText;
  Dialogs dialogs=new Dialogs();

  // Search either by user name or email
  initiateSearch(int id) async {
    if(searchController.text.isNotEmpty){
      print("not empty");
      setState(() {
        print("true");
        isLoading = true;
      });
      if(id==1) {
        await db.searchByName(searchController.text)
            .then((snapshot) {
          searchResultSnapshot = snapshot;
          int len = searchResultSnapshot.docs.length;
          print(len);
          print("$searchResultSnapshot");
          setState(() {
            print("set false");
            isLoading = false;
            haveUserSearched = true;
          });
        });
      }else{
        await db.searchByEmail(searchController.text)
            .then((snapshot) {
          searchResultSnapshot = snapshot;
          int len = searchResultSnapshot.docs.length;
          print(len);
          print("$searchResultSnapshot");
          setState(() {
            print("set false");
            isLoading = false;
            haveUserSearched = true;
          });
        });
      }
    }else{
      setState(() {
        print("true");
        isLoading = true;
      });
      await db.searchAllUsers()
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        int len = searchResultSnapshot.docs.length;
        print(len);
        print("$searchResultSnapshot");
        setState(() {
          print("set false");
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  // Widget to display result users of search
  Widget userList(){
    return haveUserSearched ? searchResultSnapshot.docs.length!=0 ? ListView.builder(
        shrinkWrap: true,
        itemCount: searchResultSnapshot.docs.length,
        itemBuilder: (context, index){
          return userFile(
            searchResultSnapshot.docs[index].data()["userName"],
            searchResultSnapshot.docs[index].data()["userEmail"],
            searchResultSnapshot.docs[index].data()["userImage"],
          );
        }):Container(
          alignment: Alignment.center,
          child: Text(
              "No Users found",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold
              )
          ),
    ) :Container() ;

  }

  // sending message to one of selected users
  sendMessage(String userName){
    if(userName==LoggedInUser().userName){
      dialogs.information(context, "Failed to Create Message File","Selected User and Current User are same" );
    }else {
      List<String> users = [LoggedInUser().userName, userName];

      String chatFileId = getChatFileId(LoggedInUser().userName, userName);

      Map<String, dynamic> chatRoom = {
        "users": users,
        "chatRoomId": chatFileId,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
        "count":0
      };

      // adding chat file to database between login user and selected user from search
      db.addChatFile(chatRoom, chatFileId);
      print(chatFileId);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) =>
              Chat(
                chatRoomId: chatFileId,
                chatUser: userName,
              )
      ));
    }

  }

  // displaying each user from search results
  Widget userFile(String userName,String userEmail,String userImage){
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black87,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          userImage=="-1" ?
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
            backgroundImage:  NetworkImage(userImage),
            maxRadius: 30,
          ),
          SizedBox(width: 5,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16
                  ),
                ),
                Text(
                  userEmail,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: (){
             sendMessage(userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(24)
              ),
              child: Text("Message",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),),
            ),
          )
        ],
      ),
    );
  }


  // generate unique chat file id between users
  getChatFileId(String a, String b) {
    if(a.compareTo(b)>0){
      return "$b\_$a";
    }else{
      return "$a\_$b";
    }
  }

  // App bar for search screen
  Widget getAppBarSearch (int inputId){
    String headingAppend;
    if(inputId ==2){
      headingAppend =" Email" ;
    }else{
      headingAppend =" User Name" ;
    }
    return AppBar(
      backgroundColor: Colors.purple.shade900 ,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text("Search Users by" + headingAppend,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w500
                )
            ),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBarSearch(id),
      body: Container(
        // Form to enter input
        child: Stack(
          children: [
            SizedBox(width: 10,),
            userList(),
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
                          controller: searchController,
                          decoration: InputDecoration(
                              labelText:id==1 ? 'Type Username' : 'Type Email',
                              border: OutlineInputBorder()
                          ),
                          onSaved: (input) =>searchUserName=searchController.text,
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
                              initiateSearch(id);
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
     // bottomNavigationBar:
    );
  }
}


