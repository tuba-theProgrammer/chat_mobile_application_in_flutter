import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Colors/constantsColors.dart';
import 'package:flutter_chat_app/Firebase_working/chatsProvider.dart';
import 'package:flutter_chat_app/Firebase_working/firebaseAuth.dart';
import 'package:flutter_chat_app/Firebase_working/settingProvider.dart';
import 'package:flutter_chat_app/screens/welcomScreen/welcomeScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async{
 
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
   final SharedPreferences sharedPreferences;
   final FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
   final FirebaseStorage firebaseStorage= FirebaseStorage.instance;

  MyApp({Key? key,
  required this.sharedPreferences}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<Firebase_auth>(create: (_)=>
      Firebase_auth(
        sharedPreferences: sharedPreferences,
        firebaseFirestore: firebaseFirestore,
        auth: FirebaseAuth.instance,
        googleSignin: GoogleSignIn(),
      ),
      ),
      Provider<settingProvider>(create: (_)=>
      settingProvider(
        firebaseFirestore: firebaseFirestore,
        firebaseStorage: firebaseStorage,
        sharedPreferences: sharedPreferences)),

        Provider<ChatsProvider>(create:(_)=>
         ChatsProvider(
        firebaseFirestore: firebaseFirestore,
        firebaseStorage: firebaseStorage,
        sharedPreferences: sharedPreferences)),
    ],
    child: MaterialApp(
      title: 'Chat Application by tuba Rajput',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        appBarTheme:AppBarTheme(centerTitle: false, elevation: 0),
      ),
      home: welcomeScreen()
    ) ,
    );
   
  }
}