import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Colors/constantsColors.dart';
import 'package:flutter_chat_app/ConstantFiles/FireStoreConstant.dart';
import 'package:flutter_chat_app/Firebase_working/FirebaseDatabase.dart';
import 'package:flutter_chat_app/components/AlreadyHaveAnAccountCheck.dart';
import 'package:flutter_chat_app/components/TextInputField.dart';
import 'package:flutter_chat_app/components/buttons.dart';
import 'package:flutter_chat_app/components/passwordInputField.dart';
import 'package:flutter_chat_app/screens/Chat_Screen/chatScreen.dart';
import 'package:flutter_chat_app/screens/SignUpScreen/Components/background.dart';
import 'package:flutter_chat_app/screens/SignUpScreen/Components/divider.dart';
import 'package:flutter_chat_app/components/socialIcons.dart';
import 'package:flutter_chat_app/screens/loginScreen/loginScreen.dart';
import 'package:flutter_chat_app/Firebase_working/firebaseAuth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';

// ignore: camel_case_types
class signUpBody extends StatefulWidget{
  const signUpBody({Key? key}) : super(key: key);

   @override
  Body createState() => Body();
}
class Body extends State<signUpBody>{
 Firebase_auth? auth;
  @override
  Widget build(BuildContext context) {
    auth=Provider.of<Firebase_auth>(context);
    TextEditingController _passwordTextController = TextEditingController();
    TextEditingController _emailTextController = TextEditingController();
    TextEditingController _userNameTextController = TextEditingController();
     checkSignInStatus();

   final formKey = GlobalKey<FormState>();
  
   databaseMethods db = databaseMethods();
   bool isLoading = false;
   signMeUp() async {

    if(formKey.currentState!.validate()){
      setState(() {
        isLoading = true;
      });
      bool isSuccess= await auth!.signUpWithEmailAndPassword(_userNameTextController.text,_emailTextController.text,
          _passwordTextController.text);
        if(isSuccess){
                       Navigator.pushReplacement(context,MaterialPageRoute(builder : (context){
                     return  chatScreen();
                      },
                         ),);
                     }

        //  await auth!.signUpWithEmailAndPassword(_userNameTextController.text,_emailTextController.text,
     //     _passwordTextController.text).then((result){
            /*if(result != null){
               Map<String,String> userDataMap = {
                FirestoreConstants.nickname :_userNameTextController.text,
                FirestoreConstants.photoUrl: "none",
                FirestoreConstants.id: auth!.getUserId(),
                FirestoreConstants.aboutMe: "Hey there ChatBox Users",
                'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
                FirestoreConstants.chattingWith:"none",
              };
             db.uploadUserInfo(userDataMap);
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => chatScreen()
              ));
            }else{
               setState(() {
            isLoading = false;
            //show snackbar
          }
          
          );
            }*/


    //  });
    }

    
  }

    Size size = MediaQuery.of(context).size;
      return Background(
      child: isLoading?Container(
        child: (
          const Center(
            child: CircularProgressIndicator(),
          )
        ),
      ):  SingleChildScrollView(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           SvgPicture.asset(
               "Assests/icons/signup.svg",
               height: size.height * 0.3,
            ),
            const Text("Create your Accounts",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            ),
           SizedBox(height: size.height * 0.03),
           Form(
             key: formKey,
             child:
            Column(
                children: [
              TextinputField(
             hintData: "Your Name",
             icon: Icons.person,
             controller: _userNameTextController,
             typeTest: true,
              ),
           TextinputField(
             hintData: "Your Email",
             icon: Icons.person,
             controller: _emailTextController, 
             ),
           passInputField(
              controller: _passwordTextController, 
             ),
           buttons(
             name: "SIGNUP",
              pressbtn: (){
                signMeUp();
                   
              },
               color: primaryColor,
               textcolor: Colors.white
               ),
                ],
            )
           ),
          
           SizedBox(
             height: size.height * 0.03),
           AlreadyHaveAnAccountcheck(
             login: false,
             OnPress: (){
             Navigator.pushReplacement(context,MaterialPageRoute(builder : (context){
               return LoginScreen();
             },
             ),);
              }
             ),
             orDivider(),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SocalIcon(iconSrc: "Assests/icons/facebook.svg", press: (){         
                     
                  }),
                   SocalIcon(iconSrc:"Assests/icons/twitter.svg", press: (){
 
                  }),
                   SocalIcon(
                     iconSrc: "Assests/icons/google-plus.svg", press: () async{
                     bool isSuccess = await auth!.handleSignIn();
                     if(isSuccess){
                       Navigator.pushReplacement(context,MaterialPageRoute(builder : (context){
                     return  chatScreen();
                      },
                         ),);
                     }
                   
                  }),
                ]
             )
         ],
      ),

      ),
      
      );
  } 
 void checkSignInStatus(){
   switch(auth!.status){
     case Status.authenticateError:
       Fluttertoast.showToast(msg: "Sign In fail");
       break;
     case Status.authenticateCancel:
       Fluttertoast.showToast(msg: "Sign In Cancelled");
       break;
     case Status.authenticated:
       Fluttertoast.showToast(msg: "Sign In Successfull");
       break;
     default:
       break;
   } 
 }

}



