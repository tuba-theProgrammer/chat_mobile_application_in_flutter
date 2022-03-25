import 'dart:io'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class ChatsProvider{
   final SharedPreferences sharedPreferences;
   final FirebaseStorage firebaseStorage;
   final FirebaseFirestore firebaseFirestore;
      ChatsProvider({
             required this.firebaseFirestore,
             required this.firebaseStorage,
             required this.sharedPreferences,
      });

      String? getPreferences(String key){
        return sharedPreferences.getString(key);
      }

      Future<bool> setPref(String key,String value)async{
        return await sharedPreferences.setString(key, value);

      }

   
      
}