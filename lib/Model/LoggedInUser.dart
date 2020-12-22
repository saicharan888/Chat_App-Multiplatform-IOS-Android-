class LoggedInUser {

  // Current logged in User Details
  static final user = LoggedInUser.internal();
  String loggedInUserFirstName = '',
      loggedInUserName = '',
      loggedInUserEmail = '',
      loggedInUserLastName='',
      loggedInUserImage='';
  String get image => loggedInUserImage;
  String get userName => loggedInUserName;
  String get email => loggedInUserEmail;
  String get firstName => loggedInUserFirstName;
  String get lastName => loggedInUserLastName;

  factory LoggedInUser() {
    return user;
  }
  LoggedInUser.internal() {
    // Singleton constructor
  }
  void setUserProfile(String inputEmail,String inputUserName,String inputFirstName,String inputLastName,String inputImage) {
    loggedInUserFirstName = inputFirstName;
    loggedInUserName = inputUserName;
    loggedInUserEmail = inputEmail;
    loggedInUserLastName=inputLastName;
    loggedInUserImage=inputImage;
  }

  void setUserFirstName(String inputFirstName) {
    loggedInUserFirstName = inputFirstName;
  }
  void setUserName(String inputUserName) {
    loggedInUserName = inputUserName;
  }
  void setUserEmail(String inputEmail) {
    loggedInUserEmail = inputEmail;
  }
  void setUserLastName(String inputLastName) {
    loggedInUserLastName=inputLastName;
  }
  void setUserImage(String inputImage) {
    loggedInUserImage=inputImage;
  }
}