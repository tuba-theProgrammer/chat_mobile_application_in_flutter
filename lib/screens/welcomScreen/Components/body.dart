import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Colors/constantsColors.dart';
import 'package:flutter_chat_app/Firebase_working/firebaseAuth.dart';
import 'package:flutter_chat_app/screens/Chat_Screen/chatScreen.dart';

import 'package:flutter_chat_app/screens/loginScreen/loginScreen.dart';
import 'package:flutter_chat_app/screens/welcomScreen/Components/background.dart';

import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';


class Body extends StatefulWidget{
  const Body({Key? key}) : super(key: key);
  @override
  WelcomeBody createState()=> WelcomeBody();
}

class WelcomeBody extends State<Body>{
  
   @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(seconds: 5),(){
      checkSignIn();
    });
  }

  void checkSignIn() async{
    Firebase_auth auth=context.read<Firebase_auth>();
    bool isLoggedIn= await auth.isLoggedIn();
    if(isLoggedIn){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>chatScreen()));
      return;
    }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    }
  }
  @override
  Widget build(BuildContext context) {
       Size size = MediaQuery.of(context).size;
   return Background(  
     child: SingleChildScrollView(
      child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: <Widget>[    
         const Text("Chat Box",
          style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20),         
         ),
         SizedBox(height: size.height * 0.03),
         SvgPicture.asset(
            "Assests/icons/chat.svg",
            height: size.height * 0.45,
         ),

        SizedBox(height: size.height * 0.03),
         const Text("Welcome Users",
          style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20),         
         ),
          SizedBox(height: size.height * 0.03),
       // ignore: sized_box_for_whitespace
       Container(
         width: 40,
         height: 40,
         child: const CircularProgressIndicator(color: primaryColor),
       )
       ]
     )
     ), 
    
   );
  }
  
}
