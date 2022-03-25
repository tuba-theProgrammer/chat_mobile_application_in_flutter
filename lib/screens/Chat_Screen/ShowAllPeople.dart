import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Colors/constantsColors.dart';
import 'package:flutter_chat_app/Firebase_working/FirebaseDatabase.dart';
import 'package:flutter_chat_app/Firebase_working/chatsProvider.dart';
import 'package:flutter_chat_app/Firebase_working/firebaseAuth.dart';
import 'package:flutter_chat_app/components/filled_outline_button.dart';
import 'package:flutter_chat_app/ConstantFiles/FireStoreConstant.dart';
import 'package:flutter_chat_app/models/Chat.dart';
import 'package:flutter_chat_app/screens/Chat_Screen/components/SearchScreen.dart';
import 'package:flutter_chat_app/screens/Chat_Screen/components/chatCard.dart';
import 'package:flutter_chat_app/screens/MessagesScreen/Messages.dart';
import 'package:flutter_chat_app/screens/loginScreen/loginScreen.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:provider/provider.dart';

class showAllPeople extends StatefulWidget{

  @override
  body createState() => body();
}

class body extends State<showAllPeople>{
 
  List<Object> allData=[];
  databaseMethods db= databaseMethods();
  late String currentUserId;
   SearchBar? searchBar;
   String searchResult="";
   Firebase_auth? auth;
   late String chatRoomId;
   QuerySnapshot? qr;
  String id="";
  String nickname="";

 late  ChatsProvider chatsProvider;
  initialChatsLoad(){
    db.getAlluserChats(currentUserId).then((val){
      setState(() {
  
      allData = List.from(val.docs.map((doc)=>UserChat.fromDocument(doc)));    
      });      
    });
  }
initialSearch(){
    db.getUserByUserName(searchResult).then((val){
      setState(() {
      qr=val;
      allData = List.from(val.docs.map((doc)=>UserChat.fromDocument(doc)));    
      });
    
      
    });
  }


  createChatRoomAnStartConverstation(String userName){

    if(userName!=nickname){
      chatRoomId= getChatRoomId(userName,nickname);
    List<String> chatUsers=[userName,nickname];
    Map<String,dynamic> chatRoomMap= {
            "users":chatUsers,
            "chatRoomId":chatRoomId
    };
    db.createChatRoom(chatRoomId, chatRoomMap);
    }
  }
    getChatRoomId(String a,String b){
   if(a.substring(0,1).codeUnitAt(0)>b.substring(0,1).codeUnitAt(0)){
     return "$b\_$a";
   }else{
     return "$a\_$b";
   }
  }

  @override
  void initState() {
    super.initState();
    auth = context.read<Firebase_auth>();
     if(auth!.getUserFireBaseID()?.isNotEmpty==true){
       currentUserId= auth!.getUserFireBaseID()!;
     }else{
        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder : (context)=> LoginScreen()),(Route<dynamic> route)=> false);
     }
   initialChatsLoad();
    chatsProvider =  context.read<ChatsProvider>();
     readLocal();
  }

  void readLocal(){
    setState(() {
       id= chatsProvider.getPreferences(FirestoreConstants.id)??"";
       nickname= chatsProvider.getPreferences(FirestoreConstants.nickname)??"";
    
    });
  
  }

  @override
  Widget build(BuildContext context) {
  
     return Scaffold(
      appBar: searchBar!.build(context),
      body: qr==null?   
     Column(
     
       children: [
         SizedBox(height: kDefaultPadding ),
        Container(
          
             child: Text("ALL AVAILABLE USER",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
         SizedBox(height: kDefaultPadding ),
         Expanded(
           child: ListView.builder(
             itemCount: allData.length,
             itemBuilder: (context,index)=> 
             SearchResultState( 
               ui: allData[index] as UserChat, press: (){
                   UserChat ui=allData[index] as UserChat;
                  createChatRoomAnStartConverstation(ui.nickname);
                      Navigator.push(context,MaterialPageRoute(builder : (context){
               return MessagesScreen(chat: allData[index] as UserChat,ChatRoomId: chatRoomId);
             },
             ),);
               })
           
         
         ), 
         ),
       ],
     ):SafeArea(

          child:  ListView.builder(
         itemCount: allData.length,
         itemBuilder: (context,index){
             return  SearchResultState( 
               ui: allData[index] as UserChat,
               press: (){
                  UserChat ui=allData[index] as UserChat;
                  createChatRoomAnStartConverstation(ui.nickname);
                      Navigator.push(context,MaterialPageRoute(builder : (context){
               return MessagesScreen(chat: allData[index] as UserChat,ChatRoomId: chatRoomId);
             },
             ),);
               });
         },
          )
        ),
      
     );
    
  }
  AppBar buildAppBar(BuildContext context) {
    
   
    
     Icon logout = const Icon(Icons.logout);
   
    return  AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: primaryColor,
      title: Text("CHAT BOX"),
      actions:
       [searchBar!.getSearchAction(context),
         IconButton(onPressed: (){
              auth!.handleSignOut();
              Navigator.pushReplacement(context,MaterialPageRoute(builder : (context){
               return LoginScreen();
             },
             ),);
         },
          icon: logout
         )
        ],
    );
  }


   body(){
    searchBar = SearchBar(
      inBar: false,
      setState: setState,
      onSubmitted: (String username){
                    setState((){
                     searchResult = username;
                     initialSearch();
                    });
                  },
      buildDefaultAppBar: buildAppBar
    );
  }


  
}




