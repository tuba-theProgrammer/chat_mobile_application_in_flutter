import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/ConstantFiles/FireStoreConstant.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Firebase_auth extends ChangeNotifier{


    final FirebaseAuth auth;
    final GoogleSignIn googleSignin;
    final FirebaseFirestore firebaseFirestore;
    final SharedPreferences sharedPreferences;
    User? firebaseUser;

    Status _status = Status.uninitialized;
    Status get status => _status;
      
      Firebase_auth({
        required this.auth,
        required this.googleSignin,
        required this.firebaseFirestore,
        required this.sharedPreferences,
      });
   String? getUserFireBaseID(){
              return sharedPreferences.getString(FirestoreConstants.id);
   }

   Future<bool> isLoggedIn() async{
     bool islogedIn = await googleSignin.isSignedIn();
     if(islogedIn && sharedPreferences.getString(FirestoreConstants.id)?.isNotEmpty==true){
           return true;
     }else{
       return false;
     }
   }

   Future<bool> handleSignIn() async{
     _status =Status.authenticating;
     notifyListeners();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignin.signIn();
          if(googleSignInAccount!=null){
     final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

        firebaseUser =(await auth.signInWithCredential(credential)).user;
         if(firebaseUser!=null){
          final QuerySnapshot result= await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).where(FirestoreConstants.id,isEqualTo: firebaseUser!.uid).get();
           final List<DocumentSnapshot> document = result.docs;
           if(document.length==0){
             firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(firebaseUser!.uid).set({
                    FirestoreConstants.nickname: firebaseUser!.displayName,
                    FirestoreConstants.photoUrl: firebaseUser!.photoURL,
                    FirestoreConstants.id: firebaseUser!.uid,
                    FirestoreConstants.aboutMe:"Hey there ChatBox Users",
                    'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
                    FirestoreConstants.chattingWith:null,
             });
             User? currentUser= firebaseUser;
             await sharedPreferences.setString(FirestoreConstants.id, currentUser!.uid);
             await sharedPreferences.setString(FirestoreConstants.nickname, currentUser.displayName??"");
             await sharedPreferences.setString(FirestoreConstants.photoUrl, currentUser.photoURL??"");
             await sharedPreferences.setString(FirestoreConstants.phoneNumber, currentUser.phoneNumber??"");

           }else{
             DocumentSnapshot  documentSnapshot=document[0];
             UserChat userChat= UserChat.fromDocument(documentSnapshot);
             await sharedPreferences.setString(FirestoreConstants.id,userChat.id);
             await sharedPreferences.setString(FirestoreConstants.nickname,userChat.nickname);
             await sharedPreferences.setString(FirestoreConstants.photoUrl,userChat.photoUrl);
             await sharedPreferences.setString(FirestoreConstants.aboutMe,userChat.aboutMe);
             await sharedPreferences.setString(FirestoreConstants.phoneNumber,userChat.phoneNumber);
           }
           _status=Status.authenticated;
           notifyListeners();
           return true;
         }else{
           _status=Status.authenticateError;
           notifyListeners();
           return false;
         }

          }else{
            _status =Status.authenticateCancel;
            notifyListeners();
            return false;
          }
        
   }

   Future<void> handleSignOut() async{
       _status =Status.uninitialized;
       await auth.signOut();
       await googleSignin.disconnect();
       await googleSignin.signOut();

   }


  
  
   String getUserId(){
     return firebaseUser!.uid;
   }
  

  

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
     _status =Status.authenticating;
     notifyListeners();
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = result.user;
    
        if(firebaseUser!=null){
          final QuerySnapshot result= await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).where(FirestoreConstants.id,isEqualTo: firebaseUser.uid).get();
           final List<DocumentSnapshot> document = result.docs;
           if(document.length==0){
             firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(firebaseUser.uid).set({
                    FirestoreConstants.nickname: "User",
                    FirestoreConstants.photoUrl: firebaseUser.photoURL,
                    FirestoreConstants.id: firebaseUser.uid,
                    FirestoreConstants.aboutMe:"Hey there ChatBox Users",
                    'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
                    FirestoreConstants.chattingWith:null,
             });
             User? currentUser= firebaseUser;
             await sharedPreferences.setString(FirestoreConstants.id, currentUser.uid);
             await sharedPreferences.setString(FirestoreConstants.nickname, currentUser.displayName??"");
             await sharedPreferences.setString(FirestoreConstants.photoUrl, currentUser.photoURL??"");
             await sharedPreferences.setString(FirestoreConstants.phoneNumber, currentUser.phoneNumber??"");

           }else{
             DocumentSnapshot  documentSnapshot=document[0];
             UserChat userChat= UserChat.fromDocument(documentSnapshot);
             await sharedPreferences.setString(FirestoreConstants.id,userChat.id);
             await sharedPreferences.setString(FirestoreConstants.nickname,userChat.nickname);
             await sharedPreferences.setString(FirestoreConstants.photoUrl,userChat.photoUrl);
             await sharedPreferences.setString(FirestoreConstants.aboutMe,userChat.aboutMe);
             await sharedPreferences.setString(FirestoreConstants.phoneNumber,userChat.phoneNumber);
           }
           _status=Status.authenticated;
           notifyListeners();
           return true;
         }else{
           _status=Status.authenticateError;
           notifyListeners();
           return false;
         }


    
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future signUpWithEmailAndPassword(String name,String email, String password) async {
    _status =Status.authenticating;
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = result.user;
 
        if(firebaseUser!=null){
          final QuerySnapshot result= await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).where(FirestoreConstants.id,isEqualTo: firebaseUser.uid).get();
           final List<DocumentSnapshot> document = result.docs;
           if(document.length==0){
             firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(firebaseUser.uid).set({
                    FirestoreConstants.nickname: name,
                    FirestoreConstants.photoUrl: firebaseUser.photoURL,
                    FirestoreConstants.id: firebaseUser.uid,
                    FirestoreConstants.aboutMe:"Hey there ChatBox Users",
                    'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
                    FirestoreConstants.chattingWith:null,
             });
             User? currentUser= firebaseUser;
             await sharedPreferences.setString(FirestoreConstants.id, currentUser.uid);
             await sharedPreferences.setString(FirestoreConstants.nickname, name);
             await sharedPreferences.setString(FirestoreConstants.photoUrl, currentUser.photoURL??"");
             await sharedPreferences.setString(FirestoreConstants.phoneNumber, currentUser.phoneNumber??"");
              await sharedPreferences.setString(FirestoreConstants.aboutMe, "Hey there ChatBox Users");

           }
           _status=Status.authenticated;
           notifyListeners();
           return true;
         }else{
           _status=Status.authenticateError;
           notifyListeners();
           return false;
         }

    } catch (e) {
      print(e.toString());
      return null;
    }
  }
 

  Future resetPass(String email) async {
    try {
      return await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


}

class UserChat {
  final String id;
  final String photoUrl;
  final String nickname;
  final String aboutMe;
  final String  phoneNumber;
  UserChat({
    required this.id,
    required this.aboutMe,
    required this.nickname,
    required this.phoneNumber,
    required this.photoUrl,
  });

  Map<String,String> toJson(){
    return{
       FirestoreConstants.aboutMe:aboutMe,
       FirestoreConstants.id:id,
       FirestoreConstants.phoneNumber:phoneNumber,
       FirestoreConstants.photoUrl:photoUrl,
       FirestoreConstants.nickname:nickname
    };
  }
  factory UserChat.fromDocument(DocumentSnapshot doc){
  String id="";
  String photoUrl="";
  String nickname="";
  String aboutMe="";
  String  phoneNumber="";
  try{
    aboutMe=doc.get(FirestoreConstants.aboutMe);
  }catch(e){}
   try{
    nickname=doc.get(FirestoreConstants.nickname);
  }catch(e){}
   try{
    phoneNumber=doc.get(FirestoreConstants.phoneNumber);
  }catch(e){}

   try{
    photoUrl=doc.get(FirestoreConstants.photoUrl);
  }catch(e){}

  return UserChat(id: doc.id, aboutMe: aboutMe, nickname: nickname, phoneNumber: phoneNumber, photoUrl: photoUrl);
  }
}

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateCancel,
}


