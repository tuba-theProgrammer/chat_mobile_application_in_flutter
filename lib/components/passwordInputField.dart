import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Colors/constantsColors.dart';
import 'package:flutter_chat_app/components/TextfieldContainer.dart';

// ignore: camel_case_types
class passInputField extends StatefulWidget {
  final TextEditingController controller;
  const passInputField({Key?key,required this.controller}):super(key: key);
  @override
 // ignore: no_logic_in_create_state
 psstext createState() => psstext(controller: controller);
}

// ignore: camel_case_types
class psstext extends State<passInputField>{
   final TextEditingController controller;
   bool _isHidden = true;

   psstext({required this.controller});
  @override
  Widget build(BuildContext context) {
   
     return TextFieldContainer(
             child: TextFormField(
             controller: controller,
             obscureText: _isHidden,
             validator: (val) {   
               return val!.length < 6 ? "Enter Password 6+ characters" : null;
            
             }
             ,
             decoration: InputDecoration(              
               icon: const Icon(Icons.lock, color: primaryColor),
               hintText: "Password",
               suffix: InkWell(
                  child: Icon(
                        _isHidden 
                        ? Icons.visibility 
                        : Icons.visibility_off,
                        color: primaryColor,
                    ),
                onTap: _togglePasswordView        
               ),
               
               border: InputBorder.none,
             ),
           ),
           );
  }
void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  
}