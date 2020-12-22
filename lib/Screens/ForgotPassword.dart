import 'package:chat_app/Backend/UserAuthentication.dart';
import 'package:chat_app/Model/Dialogs.dart';
import 'package:chat_app/Widgets/LoginAnimation.dart';
import 'package:chat_app/Screens/SignInPage.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  bool isLoading=false;
  final formKey=GlobalKey<FormState>();
  Dialogs dialogs=new Dialogs();
  UserAuthentication userAuth=new UserAuthentication();
  String email;
  TextEditingController emailController = TextEditingController(text: '');

  // function to make call to send reset link for forgot password
  submit() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      await userAuth.resetUserPassword(emailController.text).
      then((result) async {
        if (result == "success") {
          setState(() {
            isLoading = false;
            emailController.text = "";
          });
          dialogs.information(context, "Success ", "Email sent Successfully");
        }else{
          dialogs.information(context, "Failed to Sent Reset Link ", result);
        }
      });
    }
  }



  // email validation
  String validateEmailInput (String inputEmail) {
    if (inputEmail.length == 0) {
      return "Must not be empty";
    }
    RegExp regex = new RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if(!regex.hasMatch(inputEmail)){
      return "Enter valid email";
    }
    print(inputEmail);
    return null;
  }


  // navigation to sign In screen
  openSignIn(){
    Navigator.pushReplacement(context, MaterialPageRoute
      (
        builder: (context) => SignInScreen()
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center (
        child:SingleChildScrollView(
          child: Column(
            children:<Widget>[
              // Animation for page
              Container(
                height: 370,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/background.png'),
                        fit: BoxFit.fill
                    )
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: FadeAnimation(1, Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/light-1.png')
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: FadeAnimation(1.3, Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/light-2.png')
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: FadeAnimation(1.5, Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/clock.png')
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      child: FadeAnimation(1.6, Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Center(
                          child: Text(
                            "Reset Password",
                            style: TextStyle(
                                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      )),
                    )
                  ],
                ),
              ),
              // form to enter email
              Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 10.0
                        ),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(labelText: 'Reset Email',border: OutlineInputBorder()),
                          validator:(input){
                            return validateEmailInput(input);
                          },
                          onSaved: (input) =>email=emailController.text,
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Container(
                        width: 250.0,
                        child: FlatButton(
                          onPressed: submit,
                          color: Colors.indigoAccent.shade200,
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Container(
                        width: 250.0,
                        child: FlatButton(
                          onPressed: openSignIn,
                          color: Colors.indigoAccent.shade200,
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Back To Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
