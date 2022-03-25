import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Colors/constantsColors.dart';
import 'package:flutter_chat_app/ConstantFiles/FireStoreConstant.dart';
import 'package:flutter_chat_app/Firebase_working/firebaseAuth.dart';
import 'package:flutter_chat_app/Firebase_working/settingProvider.dart';
import 'package:flutter_chat_app/components/TextInputField.dart';
import 'package:flutter_chat_app/components/TextfieldContainer.dart';
import 'package:flutter_chat_app/components/buttons.dart';
import 'package:flutter_chat_app/screens/loginScreen/loginScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart'; 
class SettingsUI extends StatelessWidget {
  const SettingsUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Setting UI",
      home: EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);  
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  String id="";
  String photoUrl="";
  String nickname="";
  String aboutMe="";
  String  phoneNumber="";
  String dialCodeDigits="";
  bool isloading=false;
  File? avatarImageFile;
  late settingProvider settingprovider;
  final FocusNode focusNodeNickname=FocusNode();
  final FocusNode focusNodeAboutMe=FocusNode();
  TextEditingController? userNameController;
  TextEditingController? aboutMeController;
  TextEditingController? PhoneNumberController;

   Firebase_auth? auth;

  @override
  void initState(){
    super.initState();
    settingprovider= context.read<settingProvider>();
    auth= context.read<Firebase_auth>();
    readLocal();
  }

  void readLocal(){
    setState(() {
       id= settingprovider.getPreferences(FirestoreConstants.id)??"";
       nickname= settingprovider.getPreferences(FirestoreConstants.nickname)??"";
       aboutMe= settingprovider.getPreferences(FirestoreConstants.aboutMe)??"";
       photoUrl= settingprovider.getPreferences(FirestoreConstants.photoUrl)??"";
       phoneNumber= settingprovider.getPreferences(FirestoreConstants.phoneNumber)??"";
    });
    userNameController = TextEditingController(text: nickname);
    aboutMeController = TextEditingController(text: aboutMe);
    PhoneNumberController  = TextEditingController(text: phoneNumber);
  }

  Future getImage() async{
    ImagePicker imagePicker =ImagePicker();
    PickedFile? pickedfile = await imagePicker.getImage(source: ImageSource.gallery).catchError(
      (e){
         Fluttertoast.showToast(msg: e.toString());
      }
    );
    
    File? image;
    if(pickedfile!=null){
      image=File(pickedfile.path);
    }
    if(image!=null){
      setState(() {
        avatarImageFile=image;
        isloading=true;
      });
    }
    UploadFile();
    

  }
  // ignore: non_constant_identifier_names
  Future UploadFile() async{
    String filename= id;
    UploadTask uploadTask = settingprovider.uploadTask(avatarImageFile!, filename);
    try{
      TaskSnapshot snapshot = await uploadTask;
      photoUrl = await snapshot.ref.getDownloadURL();

      UserChat updateInfo = UserChat(
        id: id, 
        aboutMe: aboutMe,
         nickname: nickname,
          phoneNumber: phoneNumber, 
          photoUrl: photoUrl);
     settingprovider.updateDataFirestore(FirestoreConstants.pathUserCollection, id, updateInfo.toJson())
     .then((data) async{
          await settingprovider.setPref(FirestoreConstants.photoUrl, photoUrl);
          setState(() {
            isloading=false;
          });
     }).catchError((e){
       setState(() {
         isloading=false;
       });
           Fluttertoast.showToast(msg: e.toString());
     });
    }on FirebaseException catch(e){
         setState(() {
           isloading= false;
         });
         Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
     
  }

  void handleUpdateData(){
    focusNodeAboutMe.unfocus();
    focusNodeNickname.unfocus();
    setState(() {
      isloading=true;
      if(dialCodeDigits != "+00" && PhoneNumberController!.text!=""){
        phoneNumber= dialCodeDigits+ PhoneNumberController!.text.toString();
      }
    });
    UserChat updateInfo= UserChat(id: id,
     aboutMe: aboutMe,
     nickname: nickname,
     phoneNumber: phoneNumber,
     photoUrl: photoUrl);
     settingprovider.updateDataFirestore(
       FirestoreConstants.pathUserCollection,
      id, updateInfo.toJson()).then((data) async{
             await settingprovider.setPref(FirestoreConstants.aboutMe, aboutMe);
             await settingprovider.setPref(FirestoreConstants.nickname, nickname);
             await settingprovider.setPref(FirestoreConstants.photoUrl, photoUrl);
             await settingprovider.setPref(FirestoreConstants.phoneNumber, phoneNumber);
        
              setState(() {
              isloading=false;
            });
            Fluttertoast.showToast(msg: "Update SuccessFully");

      }).catchError((e){
            setState(() {
              isloading=false;
            });
             Fluttertoast.showToast(msg: e.toString());
      });
  }
  

  @override
  Widget build(BuildContext context) {
      Size size = MediaQuery.of(context).size;
     Icon logout = const Icon(Icons.logout);
    return Scaffold(
      appBar: AppBar(
      backgroundColor: primaryColor,
      title: const Text("Profile"),
      actions:
       [
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
    ),
  body: Stack(
    children: [
      SingleChildScrollView(
           padding: const EdgeInsets.only(
             left: 15, right: 15
           ),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               InkWell(

                    onTap: (){
                      getImage();
                    },
                    child: 
                    Container(
                       margin: EdgeInsets.all(20),
                       child: avatarImageFile==null?photoUrl.isNotEmpty?
                       ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: Image.network(
                            
                              photoUrl,
                              fit: BoxFit.cover,
                              width: 130,
                              height: 130,
                              errorBuilder: (context,object,stackTrace){
                                     return const Icon(
                                   Icons.account_circle,
                                   size: 90,
                                   color: primaryColor,
                                     );

                              },
                              loadingBuilder: (BuildContext context,Widget child,ImageChunkEvent? loadingProgress){
                                          if(loadingProgress==null)return child;
                                          return Container(
                                          width: 90,
                                          height: 90,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: primaryColor,
                                              value: loadingProgress.expectedTotalBytes !=null&& loadingProgress.expectedTotalBytes!=null?
                                              loadingProgress.cumulativeBytesLoaded/loadingProgress.expectedTotalBytes!
                                              :null,

                                            ) ,
                                          ),
                                          );
                              },
                            ),

                       ): const Icon(
                         Icons.account_circle,
                         size: 90,
                         color:  primaryLightColor,
                       ): ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: Image.file(   
                              avatarImageFile!,
                              fit: BoxFit.cover,
                              width: 130,
                              height: 130,
                            ),
                       )      
                      
                    ),
                    
                ),
               const SizedBox(height: kDefaultPadding*0.6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Container(
                 margin: const EdgeInsets.symmetric(vertical: 10),
         padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
         width: size.width,
         decoration: BoxDecoration(
           color: primaryLightColor,
           borderRadius: BorderRadius.circular(20)
         ),
         child: TextFormField(
                 controller: userNameController,
                 focusNode: focusNodeNickname,
                  onChanged: (val){
                    nickname=val;
                         },
              validator: (value) {
                 return value!.isEmpty || value.length < 3 ? "Enter Username 3+ characters" : null;
              },
              decoration: const InputDecoration(
                icon: Icon( Icons.person,
                color: primaryColor,
                ),
                hintText: "Username",
                border: InputBorder.none,
                
              ),
            )
    ), 
    Container(
                 margin: const EdgeInsets.symmetric(vertical: 10),
         padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
         width: size.width,
         decoration: BoxDecoration(
           color: primaryLightColor,
           borderRadius: BorderRadius.circular(20)
         ),
         child: TextFormField(
                 controller: aboutMeController,
                 focusNode: focusNodeAboutMe,
                  onChanged: (val){
                    aboutMe=val;
                         },
            
              decoration: const InputDecoration(
                icon: Icon( 
                Icons.edit,
                color: primaryColor,
                ),
                hintText: "About",
                border: InputBorder.none,
                
              ),
            )
    ), 
    Container(
                 margin: const EdgeInsets.symmetric(vertical: 10),
         padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
         width: size.width,
         decoration: BoxDecoration(
           color: primaryLightColor,
           borderRadius: BorderRadius.circular(20)
         ),
         child: TextFormField(
                 enabled: false,
                 controller: PhoneNumberController,
                  onChanged: (val){
                    phoneNumber=val;
                         },
            
              decoration: const InputDecoration(
                icon: Icon( 
                Icons.phone,
                color: primaryColor,
                ),
                hintText: "Phone Number",
                border: InputBorder.none,
                
              ),
            )
    ), 

     Container(
         margin: const EdgeInsets.symmetric(vertical: 10),
         padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),         
               child: SizedBox(
                 width: size.width ,
                 child: CountryCodePicker(
                 onChanged: (val){
                 setState(() {
                   dialCodeDigits= val.dialCode!;

                 });
                 
                 },
                 initialSelection: "IT",
                 showCountryOnly: false,
                 showOnlyCountryWhenClosed: false,
                 favorite: ["+1","US","+92","PAK"],
               ),
               )
               
    ),  Container(
                 margin: const EdgeInsets.symmetric(vertical: 10),
         padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
         width: size.width,
         decoration: BoxDecoration(
           color: primaryLightColor,
           borderRadius: BorderRadius.circular(20)
         ),
         child: TextFormField(
           
           maxLength: 13,
           keyboardType: TextInputType.number,
                 controller: PhoneNumberController,
               
                  onChanged: (val){
                    phoneNumber=val;
                         },
            
              decoration: InputDecoration(
                icon: const Icon( 
                Icons.edit,
                color: primaryColor,
                ),
                hintText: "Enter your phone Number:",
                border: InputBorder.none,
                prefix: Padding(padding: EdgeInsets.all(4),
                child: Text(dialCodeDigits,style: TextStyle(color: Colors.black)),
                )
              ),
            )
    ), 
          buttons(name: "Update Now", pressbtn: (){
                       handleUpdateData();   }, 
          color: primaryColor, textcolor: Colors.white)
    
                  ],
                )
             ],
           ),
      ),
      Positioned(child: isloading?Container(
      color: Colors.black87,
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.grey,
        ),
      ),
    ): SizedBox.shrink()
    ),
    ],
  ),
    );
  }


}