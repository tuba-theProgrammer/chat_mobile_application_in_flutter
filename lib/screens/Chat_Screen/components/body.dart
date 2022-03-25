import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Colors/constantsColors.dart';
import 'package:flutter_chat_app/Firebase_working/FirebaseDatabase.dart';
import 'package:flutter_chat_app/Firebase_working/firebaseAuth.dart';
import 'package:flutter_chat_app/components/filled_outline_button.dart';
import 'package:flutter_chat_app/models/Chat.dart';
import 'package:flutter_chat_app/screens/Chat_Screen/components/SearchScreen.dart';
import 'package:flutter_chat_app/screens/Chat_Screen/components/chatCard.dart';
import 'package:flutter_chat_app/screens/MessagesScreen/Messages.dart';
import 'package:flutter_chat_app/screens/loginScreen/loginScreen.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:provider/provider.dart';

class chatScreenBody extends StatefulWidget{

  @override
  body createState() => body();
}

class body extends State<chatScreenBody>{
 
  List<Object> allData=[];
  databaseMethods db= databaseMethods();
  late String currentUserId;
   SearchBar? searchBar;
   String searchResult="";
   Firebase_auth? auth;
  initialChatsLoad(){
    db.getAlluserChats(currentUserId).then((val){
      setState(() {
      allData = List.from(val.docs.map((doc)=>UserChat.fromDocument(doc)));    
      });      
    });
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
  }

  @override
  Widget build(BuildContext context) {
  
     return Scaffold(
      appBar: searchBar!.build(context),
      body:  
     Column(
       children: [
         Container(
           padding: EdgeInsets.fromLTRB( kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
            color: primaryColor,
            child: Row(
              children: [
                FillOutlineButton(press: (){
                        // here we will show all recent chats 
                }, text: "Recent Message"),
                SizedBox(width: kDefaultPadding),
                FillOutlineButton(press: (){
                     // here we will show active chats
                }, text: "Active",isFilled: false,)
                
              ],
            ),
         ),

         /*
         Expanded(
           child: ListView.builder(
             itemCount: allData.length,
             itemBuilder: (context,index)=> 
             chatCard(
               chat: allData[index] as UserChat, press: (){
                      Navigator.push(context,MaterialPageRoute(builder : (context){
               return MessagesScreen(chat: allData[index] as UserChat,ChatRoomId: "xyz");
             },
             ),);
               })
           
         
         ), 
         ),*/
       ],
     ),
       floatingActionButton: FloatingActionButton(
              onPressed: (){
               Navigator.push(context,MaterialPageRoute(builder : (context){
               return SearchScreen();
             },
             ),);
              },
              child: const Icon(Icons.person_add_alt_1,color: Colors.white),
              backgroundColor: primaryColor,
           ),
     );
    
  }
  AppBar buildAppBar(BuildContext context) {
    
   
     Widget customSearchBar = const  Text('CHAT BOX');
     Icon logout = const Icon(Icons.logout);
   
    return  AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: primaryColor,
      title: customSearchBar,
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
                    });
                  },
      buildDefaultAppBar: buildAppBar
    );
  }


  
}




