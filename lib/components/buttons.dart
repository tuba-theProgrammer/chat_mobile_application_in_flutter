// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Colors/constantsColors.dart';

class buttons extends StatelessWidget{
  final String name;
  final Function pressbtn;
  final Color color,textcolor;
  
  const buttons({Key? key,
   required this.name,
   required this.pressbtn,
   required this.color,
   required this.textcolor
    }): super(key: key);
  @override
  Widget build(BuildContext context) {
        Size size = MediaQuery.of(context).size;
     return  Container(
           margin: const EdgeInsets.symmetric(vertical: 10) ,
          
           width: size.width * 0.8,
           child:  ClipRRect(   
           borderRadius: BorderRadius.circular(20),
           child: FlatButton(
           padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 40),
           color: color,
           onPressed: (){
             pressbtn();
           }, 
           child: Text(name,
           style: TextStyle(
           color: textcolor,
           ),
           )),
         )
       ,
     );
  }
  
}