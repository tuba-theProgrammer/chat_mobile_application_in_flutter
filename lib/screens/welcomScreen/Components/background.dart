import 'package:flutter/material.dart';

class Background extends StatelessWidget{
  final Widget child;
  const Background({Key? key, required this.child}):super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
   // ignore: sized_box_for_whitespace
   return Container(
     height: size.height,
     width: double.infinity,
     child: Stack(
       alignment: Alignment.center,
       children: 
         <Widget>[Positioned(
           top: 0,
           left: 0,
           width: size.width * 0.3,
           child: Image.asset("Assests/images/main_top.png",
         ),
         ),
         Positioned(
           bottom: 0,
           left: 0,
            width: size.width * 0.2,
           child: Image.asset("Assests/images/main_bottom.png"),
         ),
          Positioned(
           bottom: 0,
           right: 0,
            width: size.width * 0.32,
           child: const Text("by Tuba Rajput", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
         ),
         child,
         ],
       
     ),
   );
  }
  
}
