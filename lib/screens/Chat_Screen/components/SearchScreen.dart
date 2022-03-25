import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Colors/constantsColors.dart';
import 'package:flutter_chat_app/ConstantFiles/FireStoreConstant.dart';
import 'package:flutter_chat_app/Firebase_working/FirebaseDatabase.dart';
import 'package:flutter_chat_app/Firebase_working/chatsProvider.dart';
import 'package:flutter_chat_app/Firebase_working/firebaseAuth.dart';
import 'package:flutter_chat_app/models/Chat.dart';
import 'package:flutter_chat_app/screens/MessagesScreen/Messages.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:provider/provider.dart';
class SearchScreen extends StatefulWidget{
      Search createState()=> Search();
}
class Search extends State<SearchScreen>{

   SearchBar? searchBar;
   String searchResult="";
   databaseMethods db= databaseMethods();
  bool isLoading = false;
  bool haveUserSearched = false;
  QuerySnapshot? qr;
  ChatsProvider? chatsProvider;
  List<Object> allData=[];
  String id="";
  String nickname="";
   late String chatRoomId;
  initialSearch(){
    db.getUserByUserName(searchResult).then((val){
      setState(() {
      qr=val;
      allData = List.from(val.docs.map((doc)=>UserChat.fromDocument(doc)));    
      });
      
    });
  }
  

  @override
  void initState() {
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
     return Scaffold(
        appBar: searchBar!.build(context),
        body: SafeArea(

          child: qr!=null? ListView.builder(
  
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
          ):const Center(
            child: Text("Search Friends here", style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold),)
          )
        ),
     );
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

   AppBar buildAppBar(BuildContext context) {
    
   
     Widget customSearchBar = const  Text('Search friends...');
 
    return  AppBar(
      backgroundColor: primaryColor,
      title: customSearchBar,
      actions:
       [searchBar!.getSearchAction(context)],
    );
  }
    Search(){ 
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


class SearchResultState extends StatelessWidget{
  final UserChat ui;
  final VoidCallback press;
   SearchResultState({Key?key,required this.ui,required this.press});

  @override
  Widget build(BuildContext context) {
   return  InkWell(
      onTap: press,
     child:  Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding,vertical: kDefaultPadding*0.75),
      child: Row(
        children: [
          Stack(
            children: [
                 CircleAvatar(
             radius: 27,
               backgroundImage: NetworkImage("${ui.photoUrl}")
           ),
                
            ],
          ),
           Expanded(
             child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child:   Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
                    Text(ui.nickname,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                    ),
                   const SizedBox(height: 8),
                    Opacity(opacity: 0.64,
                    child:  Text(ui.aboutMe,maxLines: 1, overflow: TextOverflow.ellipsis) ,
                    )                 
             ],
           )
         ,
             ),
           ),
           Container(       
           child: GestureDetector(
            onTap: press,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(24)
              ),
              child: const Text("Connect",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),),
            ),
          ),
           )
        ],
      ),
   ),
    );

  }


}


