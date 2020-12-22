import 'package:chat_app/Model/User.dart';

import 'package:firebase_auth/firebase_auth.dart';


// Back end user authentication

class UserAuthentication{
  FirebaseAuth firebaseAuthObj=FirebaseAuth.instance;

  CurrentUser currentUserSave(User user, String string) {
    return user != null ? CurrentUser(uid: user.uid) : CurrentUser(error:string );
  }

  // User Sign IN Authentication
  Future userSignIn(String emailID,String password) async {
    try{
      UserCredential result=
          await firebaseAuthObj.signInWithEmailAndPassword(email: emailID, password: password);
      User firebaseUser=result.user;
      return currentUserSave(firebaseUser,null);
    }
    catch(e){
      print("error" + e.toString());
      return currentUserSave(null,e.toString() );
    }

  }


  // User Sign Up
  Future userSignUp(String email, String password) async {
    try {
      print(email);
      UserCredential result = await firebaseAuthObj.createUserWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser=result.user;
      return currentUserSave(firebaseUser,null);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Reset Password of User backed
  Future<String> resetUserPassword(String email) async {
    try {
       await firebaseAuthObj.sendPasswordResetEmail(email: email);
      return "success";
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  // User Sign Out
  Future userSignOut() async {
    try {
      return await firebaseAuthObj.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

}