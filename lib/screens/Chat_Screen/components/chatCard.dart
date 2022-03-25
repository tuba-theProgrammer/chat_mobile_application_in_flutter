import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Colors/constantsColors.dart';
import 'package:flutter_chat_app/Firebase_working/firebaseAuth.dart';
import 'package:flutter_chat_app/models/Chat.dart';
import 'package:flutter_chat_app/screens/Chat_Screen/components/body.dart';

class chatCard extends StatelessWidget{
  final UserChat chat;
 
  final VoidCallback press;
  const chatCard({Key?key,required this.chat,required this.press}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
     child:  Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding,vertical: kDefaultPadding*0.75),
      child: Row(
        children: [
          Stack(
            children: [
                 CircleAvatar(
             radius: 27,
               backgroundImage: NetworkImage(chat.photoUrl)
           ),
           if(true)
           Positioned(
             right: 0,
             bottom: 0,
             child: Container(
               height: 16,
               width: 16,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor
                ),

              ),
           ),
           )
         
            ],
          ),
           Expanded(
             child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child:   Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
                    Text(chat.nickname,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8),
                    Opacity(opacity: 0.64,
                    child:  Text(chat.aboutMe,maxLines: 1, overflow: TextOverflow.ellipsis) ,
                    )                 
             ],
           )
         ,
             ),
           ),
           Opacity(opacity: 0.64,
           child: Text("3 min ago"),
           )
        ],
      ),
   ),
    );
  }
  
}
