import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Colors/constantsColors.dart';
import 'package:flutter_chat_app/ConstantFiles/FireStoreConstant.dart';
import 'package:flutter_chat_app/Firebase_working/chatsProvider.dart';
import 'package:flutter_chat_app/models/ChatMessage.dart';
import 'package:flutter_chat_app/models/ChatMessages.dart';
import 'package:provider/provider.dart';

class EachMessage extends StatefulWidget{
final ChatMessage message;

EachMessage({required this.message});
EachMessageState createState()=> EachMessageState();
}

class EachMessageState extends State<EachMessage>{

   ChatsProvider? chatsProvider;
    String id="";
   String nickname="";
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
      chatsProvider =  context.read<ChatsProvider>();
     readLocal();
  }
  void readLocal(){
    setState(() {
       id= chatsProvider!.getPreferences(FirestoreConstants.id)??"";
       nickname= chatsProvider!.getPreferences(FirestoreConstants.nickname)??"";
    
    });
  
  }

  @override
  Widget build(BuildContext context) {
       return Row(
         mainAxisAlignment:  widget.message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if(!widget.message.isSender)...[
                    const CircleAvatar(
                           radius: 12,
                           backgroundImage: NetworkImage("https://lh3.googleusercontent.com/a/AATXAJzOL6vJqE2h6dG0Ej-xrbx4-URO-orwVrfGFAfU=s96-c"),
                    ),
                   const SizedBox(width: kDefaultPadding/2),
              ],
             Container(
            margin:const EdgeInsets.only(top: kDefaultPadding),
             padding: const EdgeInsets.symmetric(
               horizontal: kDefaultPadding * 0.75,
               vertical: kDefaultPadding/2,
             ),
             decoration: BoxDecoration(
             color: widget.message.isSender? primaryColor: primaryLightColor,
             borderRadius: BorderRadius.circular(30)
             ),
             child: Text(widget.message.text,style: TextStyle(
               color:widget.message.isSender? Colors.white : Colors.black,
             )),
 
             ),
             if(widget.message.isSender)
              MessageStatusDot(status: widget.message.messageStatus)
            ],
       );
  }
  
}

class MessageStatusDot extends StatelessWidget {
  final MessageStatus status;
  const MessageStatusDot({Key? key, required this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color dotColor(MessageStatus status) {
      switch (status) {
        case MessageStatus.not_sent:
          return kErrorColor;
        case MessageStatus.not_view:
          return Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.1);
        case MessageStatus.viewed:
          return primaryColor;
        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin: EdgeInsets.only(left: kDefaultPadding / 2,top: kDefaultPadding / 1),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: dotColor(status),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == MessageStatus.not_sent ? Icons.close : Icons.done,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}

