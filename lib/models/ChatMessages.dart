import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/ConstantFiles/FireStoreConstant.dart';

class chatMessages {
 

  String? sendBy;
  String?  message;
 
  Map<String,dynamic> toJson()=>{
     'sendBy':sendBy,
     'message':message,
  };
 chatMessages.fromSnapshot(snapshot):
    sendBy = snapshot.data()['sendBy'],
    message = snapshot.data()['message'];
  
}