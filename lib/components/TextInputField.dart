import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Colors/constantsColors.dart';
import 'package:flutter_chat_app/components/TextfieldContainer.dart';
class TextinputField extends StatelessWidget{
  
  final String hintData;
  final IconData icon;
  final TextEditingController controller;
  final bool typeTest;
  

   // ignore: use_key_in_widget_constructors
   const TextinputField({
   Key? key,
   required this.hintData,
   required this.icon,
   required this.controller,
   this.typeTest=false,
   });
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
              child: TextFormField(
              controller: controller,
              onChanged: (val){
     
              },
              validator: (value) {
                 return typeTest? value!.isEmpty || value.length < 3 ? "Enter Username 3+ characters" : null : RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!) ?
                          null : "Enter correct email";
              },
              decoration: InputDecoration(
                icon: Icon(icon,
                color: primaryColor,
                ),
                hintText: hintData,
                border: InputBorder.none,
                
              ),
            )
    );   
  }
}