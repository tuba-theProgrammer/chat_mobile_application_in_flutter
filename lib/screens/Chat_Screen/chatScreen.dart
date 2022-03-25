import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Colors/constantsColors.dart';
import 'package:flutter_chat_app/Firebase_working/FirebaseDatabase.dart';
import 'package:flutter_chat_app/Firebase_working/firebaseAuth.dart';
import 'package:flutter_chat_app/screens/Chat_Screen/ShowAllPeople.dart';
import 'package:flutter_chat_app/screens/Chat_Screen/components/SearchScreen.dart';
import 'package:flutter_chat_app/screens/Chat_Screen/components/body.dart';
import 'package:flutter_chat_app/screens/loginScreen/loginScreen.dart';
import 'package:flutter_chat_app/screens/profileSetting/profileSetting.dart';
import 'package:provider/provider.dart';
class chatScreen extends StatefulWidget {
 
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}
class _ChatsScreenState extends State<chatScreen>{
   Firebase_auth? auth;
   databaseMethods db=  databaseMethods();

   int _selectedIndex = 0;
   
   bool checkType = true;
   late String currentUserId;

   @override
  void initState(){
     super.initState();
     auth = context.read<Firebase_auth>();
     if(auth!.getUserFireBaseID()?.isNotEmpty==true){
       currentUserId= auth!.getUserFireBaseID()!;
     }else{
        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder : (context)=> LoginScreen()),(Route<dynamic> route)=> false);
     }
     
   }

 
   
  List<Widget>  _pages = <Widget>[
   Container(
    child:chatScreenBody(),
  ),
  Container(
    
    child: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
  Icon(
    Icons.add,
    size: 150,
  ),
  Text("Not implemented Yet",style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold)),
        ],
    )
  
    ),
  ),
   Container(
    child: showAllPeople(),
  ),
   Container(
    child: EditProfilePage()
    ),
];



  @override
  Widget build(BuildContext context) {
    
     return Scaffold(    
           body:Center(
            child: _pages.elementAt(_selectedIndex), //New
            ),
         
            bottomNavigationBar: buildBottomNavigationBar(),
     );
  }


  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (value) {
        setState(() {
          _selectedIndex = value;
        });
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.messenger), label: "Chats"),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: "Status"),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "People"),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            radius: 14,
            backgroundImage: AssetImage("Assests/images/user_5.png"),
          ),
          label: "Profile",
        ),
      ],
      
    );
  }



   
 
}

