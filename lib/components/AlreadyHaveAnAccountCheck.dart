import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Colors/constantsColors.dart';
class AlreadyHaveAnAccountcheck extends StatelessWidget{
  final bool login;
  // ignore: non_constant_identifier_names
  final Function OnPress;
  // ignore: non_constant_identifier_names
  const AlreadyHaveAnAccountcheck({Key?key, this.login= true,required this.OnPress}):super(key: key);

  @override
  Widget build(BuildContext context) { 
   return Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
               Text( login? "Don't have an account ?":" Already Have an Account ?",
               style: const TextStyle(color: primaryColor),
               ),
               GestureDetector(
                 onTap: () {OnPress();},
                 child: Text(login?"Sign Up":"Sign In",
                  style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),),
               )
             ],
           );
  }
  
}