import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Colors/constantsColors.dart';
import 'package:flutter_chat_app/ConstantFiles/FireStoreConstant.dart';
import 'package:flutter_chat_app/Firebase_working/FirebaseDatabase.dart';
import 'package:flutter_chat_app/Firebase_working/chatsProvider.dart';
import 'package:flutter_chat_app/Firebase_working/firebaseAuth.dart';
import 'package:flutter_chat_app/models/ChatMessage.dart';
import 'package:flutter_chat_app/screens/MessagesScreen/Components/EachMessgae.dart';
import 'package:flutter_chat_app/screens/MessagesScreen/components/body.dart';
import 'package:flutter_chat_app/models/Chat.dart';
import 'package:flutter_chat_app/models/ChatMessages.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
class MessagesScreen extends StatefulWidget{
final UserChat chat;
  String ChatRoomId;
  MessagesScreen({required this.chat,required this.ChatRoomId});
MessagesScreenState createState()=> MessagesScreenState();

}

class MessagesScreenState extends State<MessagesScreen>{
  


  TextEditingController messageController= TextEditingController();
   databaseMethods db= databaseMethods();
   ChatsProvider? chatsProvider;
   String id="";
   String nickname="";
 
   late Stream stream;
   List<Object> allmessages=[];
  @override
  void initState() {
    super.initState();
   
     chatsProvider =  context.read<ChatsProvider>();
     readLocal();
    readChatMessage();
    
  /*   db.getConversationMessages(widget.ChatRoomId).then((value){
             stream = value;
            setState(() {

                allMessages = List.from(value.docs.map((doc)=>chatMessages.fromSnapshot(doc))); 
            });
           
             
             
     });*/
  }
  readChatMessage() async{
await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(widget.ChatRoomId)
        .collection('chats')
        .get()
        .then((querySnapshot) {
          allmessages =List.from(querySnapshot.docs.map((doc)=>chatMessages.fromSnapshot(doc) )); 
          if(allmessages.isEmpty){
            Fluttertoast.showToast(msg: "no messages found "+widget.ChatRoomId);
          }
       
    });

  }
  

sendMessgae(){
  if(messageController.text.isNotEmpty){
    Map<String,String> messageMap= {
      "message":messageController.text,
      "sendBy":nickname
    };
    db.addConversationMessages(widget.ChatRoomId, messageMap);
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
   return Scaffold(
       appBar: appBar(),
       body: Container(
         // ignore: unnecessary_this
         child: Column(
     children: [ 
       Expanded(
         child: Padding(
           padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
           child:  StreamBuilder(
             builder: (context, snapshot){
            return  ListView.builder(
           itemCount: demeChatMessages.length,
           itemBuilder: (context,index)=>
             
            EachMessage(message: demeChatMessages[index]),
       );
             },
           )
          ),
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
   ) ,
       )

   );
  }
  AppBar appBar(){
         return AppBar(
         automaticallyImplyLeading: false,
         backgroundColor: primaryColor,
         title: Row(
           children: [
             BackButton(),
             CircleAvatar(
                 backgroundImage: NetworkImage(widget.chat.photoUrl),
             ),
             SizedBox(width: kDefaultPadding * 0.75),
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(widget.chat.nickname,
                 style: TextStyle(fontSize: 16)
                 ),
                 Text("Active 3 min ago",
                 style: TextStyle(fontSize: 12))
               ],
             )
           ],
         ),
       );
  }
  
}

