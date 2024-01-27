
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimu_tv/config/color_const.dart';
import 'package:nimu_tv/features/dttc_screen/view/dttc_screen.dart';
import 'package:nimu_tv/features/kids_food_video_inside_screen/view/kids_food_video_inside_screen.dart';
import 'package:nimu_tv/features/login_screen/database/create_user_doc.dart';
import 'package:nimu_tv/features/subscribe_screen/view/subscribe_screen_view.dart';
import 'package:page_transition/page_transition.dart';

import '../features/lkg_screen/view/lkg_screen.dart';
import '../features/ukg_screen/view/ukg_screen.dart';
import 'circle_back_button.dart';
import 'image_picker_scanner.dart';


switchingBetweenDifferentWidget({int? index, BuildContext? context,int? sectionID, int? videoCatID,int? subscriptionReturnBackID}){
  print('checking the index for the scan qr widget index ${index} sectionID $sectionID ');
  switch(index){
    case 1:
      // Navigator.push(
      //   context!,
      //   MaterialPageRoute(builder: (context) =>  LkgScreenView(sectionID: sectionID,),),
      // );
      Navigator.push(context!, PageTransition(
        type: PageTransitionType.scale,
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 100),
        child:  LkgScreenView(sectionID: sectionID,),
      ),
      );
      break;
    case 2:
      Navigator.push(context!, PageTransition(
        type: PageTransitionType.scale,
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 100),
        child:  UkgScreenView(sectionID: sectionID,),
      ),);
      break;
    case 3:
      Navigator.push(context!, PageTransition(
        type: PageTransitionType.scale,
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 100),
        child:  DttcScreenView(sectionID: sectionID,),
      ),);
      break;
    case 4:
      Navigator.push(context!, PageTransition(
        type: PageTransitionType.scale,
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 100),
        child:  KidsFoodVideoInsideScreenView(sectionID: sectionID,title: 'KIDS FOOD VIDEO',videoCatID: videoCatID,),
      ),);
      break;
    case 5:
      Navigator.push(context!, PageTransition(
        type: PageTransitionType.scale,
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 100),
        child:  SubscribeScreenView(sectionID: subscriptionReturnBackID,),
      ),);
      break;



  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
    required this.width,
    required this.height,
    required this.dashboardList,
    required this.backButton,
     this.logOut,this.scanQR
  }) : super(key: key);

  final double width;
  final double height;
  final List<Widget> dashboardList;
  final VoidCallback backButton;
  final VoidCallback? logOut;
  final VoidCallback? scanQR;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 220,
      // shadowColor: Colors.red,
      // surfaceTintColor: Colors.orange,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 171,
            child: DrawerHeader(

              curve: Curves.bounceIn,
              duration: const Duration(milliseconds: 250),
              decoration:  BoxDecoration(
                // color: Color(0xFFF1EADE),
                border: Border.all(color: Colors.transparent)
              ),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleButton(
                    onTap: backButton,
                    isBackButton: true,
                  ),
                  const Spacer(),
                  Text(
                    'MOBILE NO :',
                    style: GoogleFonts.poppins(fontSize: 16,
                        fontWeight: FontWeight.bold,color: Colors.black26),
                  ),
                  Text(
                    '$mobileNo',
                    style: GoogleFonts.poppins(fontSize: 16,
                        fontWeight: FontWeight.bold,color: primaryBlue),
                  ),
                ],
              ),
            ),
          ),
          Column(
              children:
              dashboardList
          ),
          Container(
            margin: const EdgeInsets.all(12),
            height: 40,
            width: 120,
            decoration:   BoxDecoration(
              // shape: BoxShape.circle,
              borderRadius: BorderRadius.circular(12),
              gradient:   RadialGradient(
                radius: 2,
                // focalRadius: 5,
                colors: [primaryOrange, Color(0xFFF8B57B)],

              ),
            ),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(0)),
                ),
                onPressed: scanQR,
                child: Center(
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.camera_enhance_outlined,color: Colors.white,),
                      SizedBox(width: 5,),
                      Text(
                        'Scan QR',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                )
            ),
          ),
          Container(
            margin: const EdgeInsets.all(12),
            height: 40,
            width: 120,
            decoration:   BoxDecoration(
              // shape: BoxShape.circle,
              borderRadius: BorderRadius.circular(12),
              gradient:   RadialGradient(
                radius: 2,
                // focalRadius: 5,
                colors: [primaryOrange, Color(0xFFF8B57B)],

              ),
            ),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(0)),
                ),
                onPressed:(){
                  ImagePickerScanner.pickImage(context);
                },
                child: Center(
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.camera_enhance_outlined,color: Colors.white,),
                      SizedBox(width: 5,),
                      Text(
                        'QR File',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                )
            ),
          ),
          Container(
            margin: const EdgeInsets.all(12),
            height: 40,
            width: 120,
            decoration:   BoxDecoration(
              // shape: BoxShape.circle,
              borderRadius: BorderRadius.circular(12),
              gradient:   RadialGradient(
                radius: 2,
                // focalRadius: 5,
                colors: [primaryOrange, Color(0xFFF8B57B)],

              ),
            ),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(0)),
                ),
                onPressed: logOut,
                child: Center(
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout,color: Colors.white,),
                      SizedBox(width: 5,),
                      Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
}