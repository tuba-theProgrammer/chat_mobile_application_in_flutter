import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Colors/constantsColors.dart';
import 'package:flutter_chat_app/ConstantFiles/FireStoreConstant.dart';
import 'package:flutter_chat_app/Firebase_working/FirebaseDatabase.dart';
import 'package:flutter_chat_app/Firebase_working/chatsProvider.dart';
import 'package:flutter_chat_app/models/ChatMessage.dart';
import 'package:flutter_chat_app/models/ChatMessages.dart';
import 'package:flutter_chat_app/screens/MessagesScreen/Components/EachMessgae.dart';
import 'package:provider/provider.dart';
// ignore: camel_case_types
class body extends StatefulWidget{
  final String chatRoomId;
  body({required this.chatRoomId});
bodyState createState()=> bodyState();
}

// ignore: camel_case_types
class bodyState extends State<body>{
   TextEditingController messageController= TextEditingController();
   databaseMethods db= databaseMethods();
   ChatsProvider? chatsProvider;
   String id="";
   String nickname="";
   List<Object> allMessages=[];



   @override
  void initState() {
    super.initState();
     db.getConversationMessages(widget.chatRoomId).then((value){
            allMessages = List.from(value.docs.map((doc)=>chatMessages.fromSnapshot(doc)));    
     });
     chatsProvider =  context.read<ChatsProvider>();
     readLocal();
  }

   

sendMessgae(){
  if(messageController.text.isNotEmpty){
    Map<String,String> messageMap= {
      "message":messageController.text,
      "sendBy":nickname
    };
    db.addConversationMessages(widget.chatRoomId, messageMap);
    messageController.text="";
  }
}
void readLocal(){
    setState(() {
       id= chatsProvider!.getPreferences(FirestoreConstants.id)??"";
       nickname= chatsProvider!.getPreferences(FirestoreConstants.nickname)??"";
    
    });
  
  }

  @override
  Widget build(BuildContext context) {
   return Column(
     children: [ 
       Expanded(
         child: Padding(
           padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
           child: ListView.builder(
           itemCount: demeChatMessages.length,
           itemBuilder: (context,index)=>
            EachMessage(message: demeChatMessages[index]),
       )),
         ),
        
      Container(
           padding: const EdgeInsets.symmetric(
             horizontal: kDefaultPadding,
             vertical: kDefaultPadding/2,
           ),
               decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 32,
            color: const Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
                child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 0.75,
                ),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sentiment_satisfied_alt_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),
                   const SizedBox(width: kDefaultPadding / 4),
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: const InputDecoration(
                          hintText: "Type message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.attach_file,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),
                   const SizedBox(width: kDefaultPadding / 2),
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),
                  ],
                ),
              ),
            ),
           const   SizedBox(width: kDefaultPadding),
             InkWell(
               child: const Icon(Icons.send, color: primaryColor), 
               onTap: (){
                 sendMessgae();
               },
             )
          
           
          ],
        ),
      ),
       )

     ],
   );
  }
  
}

