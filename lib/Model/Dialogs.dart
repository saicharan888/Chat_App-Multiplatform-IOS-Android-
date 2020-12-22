import 'package:flutter/material.dart';


// used to show alert pop ups
class Dialogs{
  information(BuildContext context,String title,String description){
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(description)
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: ()=>Navigator.pop(context),
                child: Text("Ok"),
              )
            ],
          );
        }
    );
  }
}