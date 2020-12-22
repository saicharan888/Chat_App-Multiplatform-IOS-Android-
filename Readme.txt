Project Title:  Chat App

Group Members (Single Person):
Sai Charan Katta (Red ID: 824636274 )

Description :

Project is a Chat App, where any two persons on the given application can exchange messages.
For backend, I have used firebase and for authentication, I used firebase auth.

In this application
1)  User can create an account by using the sign-up
   where email and username must be unique, adding a photo is optional
2)  Once an account is created can sign with valid credentials.
3)  If a user forgets his password,
   A password reset link is sent to email by using the forgot password screen.
4)  If the user closes the app without using sign-out.
   when the user returns the actual app opens with the same user details.
   This is done by using shared preferences by storing the user details either in sign up or sign in.
5)  After Signing in user can view recently contacted chats with  or
   recently created chat files between the user with their status (online or offline)
   and the last message time.
6)  Whenever the user signs in the status changes to online,
   if he uses the sign out button status turns offline,
   The only way to change offline to online is by using the sign-out.
7)  User can view frequently contacted chats by using the frequent button on the bottom navigation bar,
   Frequently contacted users are sorted desc by the number of messages exchanged between them.
8)  User can update his profile details, where he can update photo or
   ( first name and last name ) or both.
9)  User Can search other users by email or username and message them.
   **  If a search through the empty string is used to search it retrieves all users. **
10) User can send a message to any other by selecting their chat.
11) If the user doesn't have an image, the first letter is used as a user’s image.


Instruction:

Project UI is created in references of Pixel API 29 - FLUTTER (the same device used in Assignments)

There is no specific account to use this flutter app.
Users can register themselves and can sign in with the same credentials on the sign-in screen.

The data is retrieved through stream builder
(In sending messages, updating profile, initiating chat between two users)
Everything is updated directly on FireStore and then streamed on App through StreamBuilder.
Sometimes network may take time ( not more than 2 seconds ) example as uploading photos.

Testing is done by deploying the app in two emulators on two macs,
to check real-time updates like messages and status online  or offline

Sample user to search:

username     :  sai45
email        :  1995.saicharan@gmail.com,



Known Issues:

Not an issue but a warning. While updating the profile when only an image is updated
we can see errors in the form as "please enter the valid name" (
if first name and last name are empty).


In Chat Screen the scrolls don’t automatically scroll to end, it should be done manually.








