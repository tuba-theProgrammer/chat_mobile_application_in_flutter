import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/ConstantFiles/FireStoreConstant.dart';

// ignore: camel_case_types
class databaseMethods{
    
/*    uploadUserInfo(userMap){
             FirebaseFirestore.instance.collection(FirestoreConstants.pathUserCollection).add(userMap).catchError((e){
                //  print(e.toString());
             });
    }*/

    getUserByUserName(String username) async{
      return await FirebaseFirestore.instance.collection(FirestoreConstants.pathUserCollection)
      .where("nickname",isEqualTo:username).get();
    }
    getAlluserChats(String id)async{
    return await FirebaseFirestore.instance.collection(FirestoreConstants.pathUserCollection)
      .where("id",isNotEqualTo:id).get();
    }


    createChatRoom(String chatRoomId,chatRoomMap){
            FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).set(chatRoomMap).catchError((e){
                    print(e.toString());
            });
    }
    addConversationMessages(String chatRoomid,messageMap){
    
      FirebaseFirestore.instance.collection("ChatRoom")
      .doc(chatRoomid)
      .collection("chats")
      .add(messageMap).catchError((e){
          print(e.toString());
      });
    }
 getConversationMessages(String chatRoomid) async{

     return
      FirebaseFirestore.instance.collection("ChatRoom")
      .doc(chatRoomid)
      .collection("chats")
      .snapshots();
      
    }

  
}