import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Colors/constantsColors.dart';
import 'package:flutter_chat_app/Firebase_working/firebaseAuth.dart';
import 'package:flutter_chat_app/components/AlreadyHaveAnAccountCheck.dart';
import 'package:flutter_chat_app/components/TextInputField.dart';
import 'package:flutter_chat_app/components/buttons.dart';
import 'package:flutter_chat_app/components/passwordInputField.dart';
import 'package:flutter_chat_app/components/socialIcons.dart';
import 'package:flutter_chat_app/screens/Chat_Screen/chatScreen.dart';
import 'package:flutter_chat_app/screens/SignUpScreen/Components/divider.dart';
import 'package:flutter_chat_app/screens/SignUpScreen/SignUpScreen.dart';
import 'package:flutter_chat_app/screens/loginScreen/components/background.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';


// ignore: camel_case_types
class loginBody extends StatefulWidget{
  const loginBody({Key? key}) : super(key: key);

  @override
  Body createState() => Body();
}

class Body extends State<loginBody>{


    final TextEditingController _passwordTextController = TextEditingController();
    final TextEditingController _emailTextController = TextEditingController();
    
  
   final formKey = GlobalKey<FormState>();
   Firebase_auth? auth;
   bool isLoading = false;
   // ignore: non_constant_identifier_names
   LogMeUp() async {

    if(formKey.currentState!.validate()){
      setState(() {
       isLoading = true;
      });
      
     bool isSuccess= await auth!
          .signInWithEmailAndPassword(
               _emailTextController.text,_passwordTextController.text);
               if(isSuccess){
                isLoading = false;
   Navigator.pushReplacement(context,MaterialPageRoute(builder : (context){
                     return  chatScreen();
                      },
                         ),);
               }
      
       /* await auth!
          .signInWithEmailAndPassword(
               _emailTextController.text,_passwordTextController.text)
          .then((result) async {
        if (result != null)  {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => chatScreen()));
        } else {
          setState(() {
            isLoading = false;
            //show snackbar
          });
        }
      });
*/

    }
  }

  @override
  Widget build(BuildContext context) {
     auth=Provider.of<Firebase_auth>(context);
    Size size = MediaQuery.of(context).size;
      return Background(
      child: isLoading?Container(
        child: (
          const Center(
            child: CircularProgressIndicator(),
          )
        ),
      ): SingleChildScrollView(

         child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           SvgPicture.asset(
               "Assests/icons/login.svg",
               height: size.height * 0.35,
            ),
            const Text("Login to your Accounts",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            ),
            Form(
              key: formKey,
              child: 
            Column(
                  children: [
                    TextinputField(
             hintData: "Your Email",
             icon: Icons.person, 
             controller: _emailTextController
              ),
           passInputField(
             controller: _passwordTextController
             ),
               buttons(
                 name: "LOGIN", pressbtn: (){
                   LogMeUp();               
           
           }, color: primaryColor, textcolor: Colors.white),
                  ],
            ),
            ),
          
         
           SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountcheck(OnPress: (){
             Navigator.push(context,MaterialPageRoute(builder : (context){
               return SignUpScreen();
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
                   SocalIcon(iconSrc: "Assests/icons/google-plus.svg", press: () async{
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