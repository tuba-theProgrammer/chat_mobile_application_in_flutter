import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Colors/constantsColors.dart';
class orDivider extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
      Size size = MediaQuery.of(context).size;
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        width: size.width * 0.8,
        child: Row(
          children: <Widget>[
            buildDivider(),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
            child:  Text("OR", style: TextStyle(fontWeight: FontWeight.w600, color: primaryColor)),
            ),
           
            buildDivider(),
          ],
        ),
      );
  }
  
  Expanded buildDivider(){
     return  Expanded(
              child: Divider(
              color: primaryColor,
              height: 1.5,

              ),
            );
  }
}