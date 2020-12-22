
import 'package:chat_app/Screens/Search.dart';
import 'package:flutter/material.dart';

class SearchSelectionPage extends StatefulWidget {
  @override
  _SearchSelectionPageState createState() => _SearchSelectionPageState();
}

class _SearchSelectionPageState extends State<SearchSelectionPage> {
  int id=1;
  bool isSelected=false;
  String selectType;
  bool buttonEmail=true;
  bool buttonUserName=true;


  // App Bar for search selection screen
  Widget getAppBar() {
    return AppBar(
      toolbarHeight: 75,
      backgroundColor: Colors.purple.shade900 ,
      title:
      Column(
        children:<Widget> [
          Padding(
            padding:  EdgeInsets.only(left: 20, right:5),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "Find Users",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          //fontFamily: 'Billabong',
                          fontWeight: FontWeight.bold,
                          fontSize: 30
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 50,),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // Button widget for both User Name and email selection
  Widget selectionButton(String buttonInput){
    return Container(
      alignment: Alignment.center,
      child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          child: MaterialButton(
            onPressed: (){
              setState(() {
                if(buttonInput=="Email"){
                  buttonEmail=false;
                  buttonUserName=true;
                  id=2;
                }else{
                  buttonEmail=true;
                  buttonUserName=false;
                  id=1;
                }
                isSelected=true;
              });
            },
            child: Text(
              buttonInput,
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Alike",
                fontSize: 16.0,
              ),
            ),
            color: buttonInput== "Email" ? (buttonEmail ? Colors.indigo : Colors.green):
            (buttonUserName ? Colors.indigo : Colors.green) ,
            splashColor: Colors.indigoAccent,
            minWidth: 200.0,
            height: 45.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          )
      ),
    );
  }

  // Body of Search selection displays options for search
  Widget getBody(){
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height:60,),
          Padding(
            padding: const EdgeInsets.only(left:10.0,top:8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Search Users by :",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 28,
                        fontWeight: FontWeight.w900
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height:90,),
          selectionButton("User Name"),
          selectionButton("Email"),
          SizedBox(height:90,),
          // submit button to progress after selection
          isSelected ? Container(
            alignment: Alignment.center,
            child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                child: MaterialButton(
                  onPressed: (){
                   print(id);
                      setState(() {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                          Search(id : id)));
                    });
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "Alike",
                      fontSize: 16.0,
                    ),
                  ),
                  color: Colors.amberAccent,
                  splashColor: Colors.orange,
                  minWidth: 120.0,
                  height: 45.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                )
            ),
          ):Container(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      //backgroundColor: black,
      body: getBody()
    );
  }
}
