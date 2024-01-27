import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimu_tv/config/constants.dart';
import 'package:nimu_tv/config/mute_button_config.dart';
import 'package:nimu_tv/features/dashboard_screen/view/dashboard_screen.dart';
import 'package:nimu_tv/features/login_screen/database/create_user_doc.dart';
import 'package:nimu_tv/features/login_screen/view/qr_code.dart';
import 'package:nimu_tv/main.dart';
import 'package:page_transition/page_transition.dart';

import '../../../config/check_internet_connection.dart';
import '../../../config/navigation_transition_constants.dart';
import '../../../config/utils.dart';
import '../bloc/login_bloc.dart';

class LoginScreenView extends StatefulWidget {
  const LoginScreenView({Key? key}) : super(key: key);

  @override
  State<LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView> {
  final LoginBloc loginBloc = LoginBloc();
  final _mobileKey = GlobalKey<FormState>();
  final _otpKey = GlobalKey<FormState>();
  final _formQRKey = GlobalKey<FormState>();
  late final TextEditingController mobileNumberTextController =
      TextEditingController();
  late final TextEditingController otpTextController =
      TextEditingController();
  late final TextEditingController promoCodeTextController =
      TextEditingController();

  Color textColor = Colors.blue;

  late FocusNode mobileNumberFocusNode;
  late FocusNode otpFocusNode;
  late FocusNode promoCodeFocusNode;
  late FocusNode confirmFocusNode;

  bool isOtpSent = false;

  var listViewValue = 1;


  @override
  void initState() {
    // TODO: implement initState
    loginBloc.add(LoginInitialEvent());
    mobileNumberFocusNode=FocusNode();
    otpFocusNode=FocusNode();
    promoCodeFocusNode=FocusNode();
    confirmFocusNode=FocusNode();


    // setState(() {
    //
    // });


    super.initState();
  }

  @override
  void dispose() {
    mobileNumberTextController.dispose();
    otpTextController.dispose();
    promoCodeTextController.dispose();
    super.dispose();
  }
  Future<bool> _onWillPop() async {
    return (await showDialog(

      context: context,
      builder: (context) => AlertDialog(
        title:  const Text('Are you sure?'),
        content:  const Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
            child:  const Text('No'),
          ),
          TextButton(
            onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'), // <-- SEE HERE
            child:  const Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    double? width = MediaQuery.of(context).size.width;
    double? height = MediaQuery.of(context).size.height;
    return BlocConsumer<LoginBloc, LoginState>(
      bloc: loginBloc,
      listenWhen: (previous, current) => current is LoginActionState,
      buildWhen: (previous, current) => current is! LoginActionState,
      listener: (context, state) {
        if (state is LoginButtonLoadedSuccessState) {


          loginBloc.add(QRCodeScanningEvent(isScannerOpen: true));

          // showGeneralDialog(
          //     context: context,
          //     // barrierDismissible: true,
          //     barrierLabel: MaterialLocalizations.of(context)
          //         .modalBarrierDismissLabel,
          //     barrierColor: Colors.transparent,
          //     transitionDuration: const Duration(milliseconds: 200),
          //     pageBuilder: (BuildContext buildContext,
          //         Animation animation,
          //         Animation secondaryAnimation) {
          //       return StatefulBuilder(
          //           builder: (context, changingState) {
          //             return RawKeyboardListener(
          //               focusNode: FocusNode(),
          //               autofocus: true,
          //               onKey: (RawKeyEvent event) async {
          //                 print("1) ${event.data}");
          //                 print("2) ${event.character.toString()}");
          //                 print("3) ${event.toString()}");
          //                 print("4) ${event.physicalKey.debugName}");
          //                 print("5) ${event.logicalKey.keyId}");
          //                 print("6) ${event.logicalKey}");
          //                 print("7) ${event.isKeyPressed(LogicalKeyboardKey.enter)}");
          //                 print("7) ${LogicalKeyboardKey.enter}");
          //
          //
          //
          //
          //
          //
          //
          //                 // ScaffoldMessenger.of(context).showSnackBar(snackBar);
          //
          //
          //                 if (event.runtimeType.toString() == 'RawKeyDownEvent') {
          //                   switch (event.logicalKey.debugName) {
          //                     case 'Media Play Pause':
          //                     case 'Select':
          //                       changingState(() {
          //                         for(var item in sapienceParentsModelList){
          //                           if(item.isSelected == true && item.title != 'YES'){
          //                             loginBloc.add(SapienceParentsDialogEvent());
          //                           }
          //                           else
          //                           {
          //                             debugPrint('checking the promodecodecontroller ${promoCodeTextController.text}');
          //                             if(_formQRKey.currentState!.validate() && item.title == 'YES'){
          //                               loginBloc.add(BarCodeAddingEvent(qrCode: promoCodeTextController.text.trim()));                                                                }
          //                           }
          //                         }
          //
          //                         // if(e.index ==0){
          //                         //   if(_formQRKey.currentState!.validate()){
          //                         //     Navigator.push(context, ScaleRoute(page: DashboardScreenView()));
          //                         //   }
          //                         // }
          //                         // else
          //                         // {
          //                         //   Navigator.push(context, ScaleRoute(page: DashboardScreenView()));
          //                         //
          //                         // }
          //
          //                       });
          //                       break;
          //                     case 'Enter':
          //                       changingState(() {
          //                         for(var item in sapienceParentsModelList){
          //                           if(item.isSelected == true && item.title != 'YES'){
          //                             loginBloc.add(SapienceParentsDialogEvent());
          //                           }
          //                           else
          //                           {
          //                             debugPrint('checking the promodecodecontroller ${promoCodeTextController.text}');
          //
          //                             if(_formQRKey.currentState!.validate() && item.title == 'YES' && item.isSelected == true){
          //                               loginBloc.add(BarCodeAddingEvent(qrCode: promoCodeTextController.text.trim()));                                                                }
          //                           }
          //                         }
          //                       });
          //                       break;
          //                   }
          //                 }
          //
          //
          //
          //                 else  if (LogicalKeyboardKey.arrowRight == event.logicalKey) {
          //
          //                   debugPrint('arrowRight listViewValue $listViewValue widget.lkgProducts!.length ${sapienceParentsModelList.length}');
          //
          //                   if(listViewValue < sapienceParentsModelList.length-1){
          //                     loginBloc.add(LoginQRChangingTheColorEvent(index: listViewValue,isRightButton: true));
          //
          //                     listViewValue = 1;
          //                     changingState(() {
          //
          //                     });
          //
          //                   }
          //
          //                 }
          //                 else  if (LogicalKeyboardKey.arrowUp == event.logicalKey) {
          //                   loginBloc.add(LoginQRChangingTheColorEvent(index: listViewValue,isUpButton: true));
          //
          //                   promoCodeFocusNode.requestFocus();
          //                   changingState(() {
          //
          //                   });
          //
          //                   // if(listViewValue>0){
          //                   //   loginBloc.add(LoginQRChangingTheColorEvent(index: listViewValue,isLeftButton: true));
          //                   //
          //                   //   listViewValue = 0;
          //                   //   changingState(() {
          //                   //
          //                   //   });
          //                   //   debugPrint('arrowLeft listViewValue $listViewValue widget.lkgProducts!.length ${sapienceParentsModelList.length}');
          //                   //
          //                   // }
          //
          //                 }
          //                 else  if (LogicalKeyboardKey.arrowDown == event.logicalKey) {
          //                   loginBloc.add(LoginQRChangingTheColorEvent(index: listViewValue,isDownButton: true));
          //
          //                   listViewValue = 0;
          //                   promoCodeFocusNode.unfocus();
          //                   changingState(() {
          //
          //                   });
          //
          //                   // if(listViewValue>0){
          //                   //   loginBloc.add(LoginQRChangingTheColorEvent(index: listViewValue,isLeftButton: true));
          //                   //
          //                   //   listViewValue = 0;
          //                   //   changingState(() {
          //                   //
          //                   //   });
          //                   //   debugPrint('arrowLeft listViewValue $listViewValue widget.lkgProducts!.length ${sapienceParentsModelList.length}');
          //                   //
          //                   // }
          //
          //                 }
          //                 else  if (LogicalKeyboardKey.arrowLeft == event.logicalKey) {
          //
          //                   if(listViewValue>0){
          //                     loginBloc.add(LoginQRChangingTheColorEvent(index: listViewValue,isLeftButton: true));
          //
          //                     listViewValue = 0;
          //                     changingState(() {
          //
          //                     });
          //                     debugPrint('arrowLeft listViewValue $listViewValue widget.lkgProducts!.length ${sapienceParentsModelList.length}');
          //
          //                   }
          //
          //                 }
          //
          //                 if (event is RawKeyDownEvent) {
          //
          //                   print('--> ${event.data.keyLabel}');
          //                   // handle key down
          //                 } else if (event is RawKeyUpEvent) {
          //                   // handle key up
          //                 }
          //               },
          //               child: Center(
          //                 child: Container(
          //                   width: MediaQuery.of(context).size.width * 0.6,
          //                   height: MediaQuery.of(context).size.height * 0.7,
          //                   // padding: EdgeInsets.all(20),
          //                   decoration: const BoxDecoration(
          //                     borderRadius: BorderRadius.all(Radius.circular(12)),
          //                     color: Colors.white,
          //                   ),
          //                   child: Column(
          //                     children: [
          //                       Container(
          //                         height: MediaQuery.of(context).size.height * 0.15,
          //                         width: MediaQuery.of(context).size.width ,
          //                         decoration: const BoxDecoration(
          //                           borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12)),
          //                           color: Colors.blueAccent,
          //                         ),
          //                         child: Center(
          //                           child: Material(
          //                             color: Colors.transparent,
          //                             child: Text(
          //                               'SAPIENCE PARENTS',
          //                               style: GoogleFonts.poppins(
          //                                   color: Colors.white,
          //                                   fontSize: 12,fontWeight: FontWeight.bold),
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //                       10.ph,
          //                       Material(
          //                         color: Colors.transparent,
          //                         child: Padding(
          //                           padding: const EdgeInsets.only(left: 10,right: 10),
          //                           child: Text(
          //                             'If your child is studying school as SAPIENCE BOOK check the QR CODE on the book which act as a promo code',
          //                             style: GoogleFonts.poppins(
          //                                 color: Colors.black,
          //                                 fontSize: 14,fontWeight: FontWeight.bold),
          //                             maxLines: 3,
          //                             overflow: TextOverflow.ellipsis,
          //                             textAlign: TextAlign.center,
          //                           ),
          //                         ),
          //                       ),
          //                       10.ph,
          //                       Container(
          //                         margin: const EdgeInsets.all(20),
          //                         width: 100,
          //                         height: 30,
          //                         decoration:   BoxDecoration(
          //                           // shape: BoxShape.circle,
          //                           borderRadius: BorderRadius.circular(12),
          //                           gradient:   RadialGradient(
          //                             radius: 2,
          //                             // focalRadius: 5,
          //                             colors: [
          //                               const Color(0xFFE77817) ,
          //                               const Color(0xFFF8B57B) ],
          //
          //                           ),
          //                         ),
          //                         child: ElevatedButton(
          //                           style: ElevatedButton.styleFrom(
          //                             backgroundColor: Colors.transparent,
          //                             shadowColor: Colors.transparent,
          //                             shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(0)),
          //                           ),
          //                           onPressed: () {
          //                             debugPrint('checking the promodecodecontroller ${width}');
          //                             if(width < 900){
          //                               loginBloc.add(QRCodeScanningEvent());
          //                             }
          //
          //                           },
          //                           child:  Text(
          //                             'Scan QR Code ',
          //                             style: const TextStyle(color: Colors.white),
          //                           ),
          //                         ),
          //                       ),
          //                       5.ph,
          //                       Row(
          //                         mainAxisAlignment: MainAxisAlignment.center,
          //                         children: state.sapienceParentsModelList!.map((e) =>
          //                             Container(
          //                               margin: const EdgeInsets.all(20),
          //                               width: 100,
          //                               height: 30,
          //                               decoration:   BoxDecoration(
          //                                 // shape: BoxShape.circle,
          //                                 borderRadius: BorderRadius.circular(12),
          //                                 gradient:   RadialGradient(
          //                                   radius: 2,
          //                                   // focalRadius: 5,
          //                                   colors: [
          //                                     e.isSelected == true ?
          //                                     const Color(0xFFE77817) : Colors.grey.shade300,
          //                                     e == true ?
          //                                     const Color(0xFFF8B57B) : Colors.grey.shade300],
          //
          //                                 ),
          //                               ),
          //                               child: ElevatedButton(
          //                                 style: ElevatedButton.styleFrom(
          //                                   backgroundColor: Colors.transparent,
          //                                   shadowColor: Colors.transparent,
          //                                   shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(0)),
          //                                 ),
          //                                 onPressed: () {
          //                                   debugPrint('checking the promodecodecontroller ${width}');
          //                                   if(width < 900){
          //                                     if(e.isSelected == true && e.title != 'YES'){
          //                                       // Navigator.push(context, ScaleRoute(page: DashboardScreenView()));
          //
          //                                       loginBloc.add(SapienceParentsDialogEvent());
          //                                     }
          //                                     else
          //                                     {
          //                                       if(_formQRKey.currentState!.validate()){
          //                                         loginBloc.add(BarCodeAddingEvent(qrCode: promoCodeTextController.text.trim()));                                                                }
          //                                     }
          //                                   }
          //
          //                                 },
          //                                 child:  Text(
          //                                   '${e.title}',
          //                                   style: const TextStyle(color: Colors.white),
          //                                 ),
          //                               ),
          //                             ),
          //                         ).toList(),
          //                       ),
          //
          //
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             );
          //           }
          //       );
          //     });

        }
        else if (state is SapienceParentDialogButtonLoadingState) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Loading please wait ....')));
        }  else if (state is QRCodeState) {
          double baseWidth = 800.0000610352;
          double fem = MediaQuery.of(context).size.width / baseWidth;
          double ffem = fem * 0.97;
          num subscriptionLength = userData!.data.subscriptionList.length;

          // .map((e){
          //   e.name.contains('LKG');
          // });

          // loginBloc.add(QRCodeScanningEvent());

          if(PlatformType.isTv == false){
                                      loginBloc.add(SapienceParentsDialogEvent());
                                    }

          // showGeneralDialog(
          //     context: context,
          //     barrierDismissible: true,
          //     barrierLabel: MaterialLocalizations.of(context)
          //         .modalBarrierDismissLabel,
          //     barrierColor: Colors.transparent,
          //     transitionDuration: const Duration(milliseconds: 200),
          //     pageBuilder: (BuildContext buildContext,
          //         Animation animation,
          //         Animation secondaryAnimation) {
          //       return StatefulBuilder(
          //           builder: (context, changingState) {
          //             return RawKeyboardListener(
          //               focusNode: FocusNode(),
          //               autofocus: true,
          //               onKey: (RawKeyEvent event) async {
          //                 print("1) ${event.data}");
          //                 print("2) ${event.character.toString()}");
          //                 print("3) ${event.toString()}");
          //                 print("4) ${event.physicalKey.debugName}");
          //                 print("5) ${event.logicalKey.keyId}");
          //                 print("6) ${event.logicalKey}");
          //                 print("7) ${event.isKeyPressed(LogicalKeyboardKey.enter)}");
          //                 print("7) ${LogicalKeyboardKey.enter}");
          //
          //
          //
          //
          //
          //
          //
          //                 // ScaffoldMessenger.of(context).showSnackBar(snackBar);
          //
          //
          //                 if (event.runtimeType.toString() == 'RawKeyDownEvent') {
          //                   switch (event.logicalKey.debugName) {
          //                     case 'Media Play Pause':
          //                     case 'Select':
          //                       changingState(() {
          //                         for(var item in sapienceParentsModelList){
          //                           if(item.isSelected == true && item.title != 'YES'){
          //                             loginBloc.add(SapienceParentsDialogEvent());
          //                           }
          //                           else
          //                           {
          //                             debugPrint('checking the promodecodecontroller ${promoCodeTextController.text}');
          //                             if(_formQRKey.currentState!.validate() && item.title == 'YES'){
          //                               loginBloc.add(BarCodeAddingEvent(qrCode: promoCodeTextController.text.trim()));                                                                }
          //                           }
          //                         }
          //
          //                         // if(e.index ==0){
          //                         //   if(_formQRKey.currentState!.validate()){
          //                         //     Navigator.push(context, ScaleRoute(page: DashboardScreenView()));
          //                         //   }
          //                         // }
          //                         // else
          //                         // {
          //                         //   Navigator.push(context, ScaleRoute(page: DashboardScreenView()));
          //                         //
          //                         // }
          //
          //                       });
          //                       break;
          //                     case 'Enter':
          //                       changingState(() {
          //                         for(var item in sapienceParentsModelList){
          //                           if(item.isSelected == true && item.title != 'YES'){
          //                             loginBloc.add(SapienceParentsDialogEvent());
          //                           }
          //                           else
          //                           {
          //                             debugPrint('checking the promodecodecontroller ${promoCodeTextController.text}');
          //
          //                             if(_formQRKey.currentState!.validate() && item.title == 'YES' && item.isSelected == true){
          //                               loginBloc.add(BarCodeAddingEvent(qrCode: promoCodeTextController.text.trim()));                                                                }
          //                           }
          //                         }
          //                       });
          //                       break;
          //                   }
          //                 }
          //
          //
          //
          //                 else  if (LogicalKeyboardKey.arrowRight == event.logicalKey) {
          //
          //                   debugPrint('arrowRight listViewValue $listViewValue widget.lkgProducts!.length ${sapienceParentsModelList.length}');
          //
          //                   if(listViewValue < sapienceParentsModelList.length-1){
          //                     loginBloc.add(LoginQRChangingTheColorEvent(index: listViewValue,isRightButton: true));
          //
          //                     listViewValue = 1;
          //                     changingState(() {
          //
          //                     });
          //
          //                   }
          //
          //                 }
          //                 else  if (LogicalKeyboardKey.arrowUp == event.logicalKey) {
          //                   loginBloc.add(LoginQRChangingTheColorEvent(index: listViewValue,isUpButton: true));
          //
          //                   promoCodeFocusNode.requestFocus();
          //                   changingState(() {
          //
          //                   });
          //
          //                   // if(listViewValue>0){
          //                   //   loginBloc.add(LoginQRChangingTheColorEvent(index: listViewValue,isLeftButton: true));
          //                   //
          //                   //   listViewValue = 0;
          //                   //   changingState(() {
          //                   //
          //                   //   });
          //                   //   debugPrint('arrowLeft listViewValue $listViewValue widget.lkgProducts!.length ${sapienceParentsModelList.length}');
          //                   //
          //                   // }
          //
          //                 }
          //                 else  if (LogicalKeyboardKey.arrowDown == event.logicalKey) {
          //                   loginBloc.add(LoginQRChangingTheColorEvent(index: listViewValue,isDownButton: true));
          //
          //                   listViewValue = 0;
          //                   promoCodeFocusNode.unfocus();
          //                   changingState(() {
          //
          //                   });
          //
          //                   // if(listViewValue>0){
          //                   //   loginBloc.add(LoginQRChangingTheColorEvent(index: listViewValue,isLeftButton: true));
          //                   //
          //                   //   listViewValue = 0;
          //                   //   changingState(() {
          //                   //
          //                   //   });
          //                   //   debugPrint('arrowLeft listViewValue $listViewValue widget.lkgProducts!.length ${sapienceParentsModelList.length}');
          //                   //
          //                   // }
          //
          //                 }
          //                 else  if (LogicalKeyboardKey.arrowLeft == event.logicalKey) {
          //
          //                   if(listViewValue>0){
          //                     loginBloc.add(LoginQRChangingTheColorEvent(index: listViewValue,isLeftButton: true));
          //
          //                     listViewValue = 0;
          //                     changingState(() {
          //
          //                     });
          //                     debugPrint('arrowLeft listViewValue $listViewValue widget.lkgProducts!.length ${sapienceParentsModelList.length}');
          //
          //                   }
          //
          //                 }
          //
          //                 if (event is RawKeyDownEvent) {
          //
          //                   print('--> ${event.data.keyLabel}');
          //                   // handle key down
          //                 } else if (event is RawKeyUpEvent) {
          //                   // handle key up
          //                 }
          //               },
          //               child: Center(
          //                 child: Container(
          //                   padding: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 21*fem),
          //                   width: 371*fem,
          //                   height: state.storingQRCode == null?  201*fem  : 244*fem,
          //                   decoration: BoxDecoration (
          //                     color: Color(0xfffcfcfe),
          //                     borderRadius: BorderRadius.circular(8*fem),
          //                   ),
          //                   child: Column(
          //                     children: [
          //                       Container(
          //                         // autogroup9uftEDo (D6iWZLEbge3D3evb7c9UfT)
          //                         margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 11*fem),
          //                         width:  double.infinity,
          //                         height:  53*fem,
          //                         decoration:  BoxDecoration (
          //                           color:  Color(0xff00588e),
          //                           borderRadius:  BorderRadius.only (
          //                             topLeft:  Radius.circular(8*fem),
          //                             topRight:  Radius.circular(8*fem),
          //                           ),
          //                         ),
          //                         child: Center(
          //                           child: Material(
          //                             color: Colors.transparent,
          //                             child: Text(
          //                               'SAPIENCE PARENTS',
          //                               textAlign:  TextAlign.center,
          //                               style:  SafeGoogleFont (
          //                                 'Poppins',
          //                                 fontSize:  18*ffem,
          //                                 fontWeight:  FontWeight.w700,
          //                                 height:  1.2222222222*ffem/fem,
          //                                 letterSpacing:  0.7920002747*fem,
          //                                 color:  Color(0xffffffff),
          //                               ),
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //                       Material(
          //                         color: Colors.transparent,
          //                         child: Container(
          //                           // ifyourchildisstudyingschoolass (567:1164)
          //                           margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 29*fem),
          //                           constraints:  BoxConstraints (
          //                             maxWidth:  324*fem,
          //                           ),
          //                           child:
          //                           RichText(
          //                             textAlign:  TextAlign.center,
          //                             text:
          //                             TextSpan(
          //                               style:  SafeGoogleFont (
          //                                 'Poppins',
          //                                 fontSize:  13*ffem,
          //                                 fontWeight:  FontWeight.w400,
          //                                 height:  1.2307692308*ffem/fem,
          //                                 color:  Color(0xff666666),
          //                               ),
          //                               children:  [
          //                                 TextSpan(
          //                                   text:  'If your child is studying school as ',
          //                                   style:  SafeGoogleFont (
          //                                     'Poppins',
          //                                     fontSize:  13*ffem,
          //                                     fontWeight:  FontWeight.w400,
          //                                     height:  1.2307692308*ffem/fem,
          //                                     color:  Color(0xff666666),
          //                                   ),
          //                                 ),
          //                                 TextSpan(
          //                                   text:  'SAPIENCE BOOK',
          //                                   style:  SafeGoogleFont (
          //                                     'Poppins',
          //                                     fontSize:  13*ffem,
          //                                     fontWeight:  FontWeight.w700,
          //                                     height:  1.2307692308*ffem/fem,
          //                                     color:  Color(0xff666666),
          //                                   ),
          //                                 ),
          //                                 TextSpan(
          //                                   text:  '.\nCheck the ',
          //                                   style:  SafeGoogleFont (
          //                                     'Poppins',
          //                                     fontSize:  13*ffem,
          //                                     fontWeight:  FontWeight.w400,
          //                                     height:  1.2307692308*ffem/fem,
          //                                     color:  Color(0xff666666),
          //                                   ),
          //                                 ),
          //                                 TextSpan(
          //                                   text:  'QR CODE',
          //                                   style:  SafeGoogleFont (
          //                                     'Poppins',
          //                                     fontSize:  13*ffem,
          //                                     fontWeight:  FontWeight.w700,
          //                                     height:  1.2307692308*ffem/fem,
          //                                     color:  Color(0xff666666),
          //                                   ),
          //                                 ),
          //                                 TextSpan(
          //                                   text:  ' on the book which act as a\n',
          //                                   style:  SafeGoogleFont (
          //                                     'Poppins',
          //                                     fontSize:  13*ffem,
          //                                     fontWeight:  FontWeight.w400,
          //                                     height:  1.2307692308*ffem/fem,
          //                                     color:  Color(0xff666666),
          //                                   ),
          //                                 ),
          //                                 TextSpan(
          //                                   text:  'PROMO CODE',
          //                                   style:  SafeGoogleFont (
          //                                     'Poppins',
          //                                     fontSize:  13*ffem,
          //                                     fontWeight:  FontWeight.w700,
          //                                     height:  1.2307692308*ffem/fem,
          //                                     color:  Color(0xff666666),
          //                                   ),
          //                                 ),
          //                               ],
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //                       state.storingQRCode == null ?      Container(
          //                         // group427319496QiV (567:1157)
          //                         margin: EdgeInsets.fromLTRB(33*fem, 0*fem, 32*fem, 0*fem),
          //                         width: double.infinity,
          //                         height: 39*fem,
          //                         decoration: BoxDecoration (
          //                           borderRadius: BorderRadius.circular(97.3562927246*fem),
          //                         ),
          //                         child:
          //
          //                         subscriptionLength.toInt() == 0 ?
          //                         Container(
          //                           // group165X (567:1158)
          //                           margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 44*fem, 0*fem),
          //                           child: TextButton(
          //                             onPressed: () {
          //                               debugPrint('checking the promodecodecontroller ${width}');
          //                               if(PlatformType.isTv == false){
          //                                 loginBloc.add(QRCodeScanningEvent());
          //                               }
          //                             },
          //                             style: TextButton.styleFrom (
          //                               padding: EdgeInsets.zero,
          //                             ),
          //                             child: Container(
          //                               width: 131*fem,
          //                               height: double.infinity,
          //                               decoration: BoxDecoration (
          //                                 borderRadius: BorderRadius.circular(97.3562927246*fem),
          //                                 gradient: RadialGradient (
          //                                   center: Alignment(0.66, -0.463),
          //                                   radius: 1.01,
          //                                   colors: <Color>[Color(0xffe77817), Color(0xfff7b57a)],
          //                                   stops: <double>[0, 1],
          //                                 ),
          //                                 boxShadow: [
          //                                   BoxShadow(
          //                                     color: Color(0x33000000),
          //                                     offset: Offset(0*fem, 11.6827545166*fem),
          //                                     blurRadius: 16*fem,
          //                                   ),
          //                                 ],
          //                               ),
          //                               child: Center(
          //                                 child: Text(
          //                                   'SCAN QR',
          //                                   textAlign: TextAlign.center,
          //                                   style: SafeGoogleFont (
          //                                     'Poppins',
          //                                     fontSize: 18*ffem,
          //                                     fontWeight: FontWeight.w600,
          //                                     height: 1.5*ffem/fem,
          //                                     color: Color(0xffffffff),
          //                                   ),
          //                                 ),
          //                               ),
          //                             ),
          //                           ),
          //                         ) :
          //                         Row(
          //                           crossAxisAlignment: CrossAxisAlignment.center,
          //                           children: [
          //                             Container(
          //                               // group165X (567:1158)
          //                               margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 44*fem, 0*fem),
          //                               child: TextButton(
          //                                 onPressed: () {
          //                                   debugPrint('checking the promodecodecontroller ${width}');
          //                                   if(PlatformType.isTv == false){
          //                                     loginBloc.add(QRCodeScanningEvent());
          //                                   }
          //                                 },
          //                                 style: TextButton.styleFrom (
          //                                   padding: EdgeInsets.zero,
          //                                 ),
          //                                 child: Container(
          //                                   width: 131*fem,
          //                                   height: double.infinity,
          //                                   decoration: BoxDecoration (
          //                                     borderRadius: BorderRadius.circular(97.3562927246*fem),
          //                                     gradient: RadialGradient (
          //                                       center: Alignment(0.66, -0.463),
          //                                       radius: 1.01,
          //                                       colors: <Color>[Color(0xffe77817), Color(0xfff7b57a)],
          //                                       stops: <double>[0, 1],
          //                                     ),
          //                                     boxShadow: [
          //                                       BoxShadow(
          //                                         color: Color(0x33000000),
          //                                         offset: Offset(0*fem, 11.6827545166*fem),
          //                                         blurRadius: 16*fem,
          //                                       ),
          //                                     ],
          //                                   ),
          //                                   child: Center(
          //                                     child: Text(
          //                                       'SCAN QR',
          //                                       textAlign: TextAlign.center,
          //                                       style: SafeGoogleFont (
          //                                         'Poppins',
          //                                         fontSize: 18*ffem,
          //                                         fontWeight: FontWeight.w600,
          //                                         height: 1.5*ffem/fem,
          //                                         color: Color(0xffffffff),
          //                                       ),
          //                                     ),
          //                                   ),
          //                                 ),
          //                               ),
          //                             ),
          //                             TextButton(
          //                               // group2At1 (567:1161)
          //                               onPressed: () {
          //                                 if(PlatformType.isTv == false){
          //                                   loginBloc.add(SapienceParentsDialogEvent());
          //                                 }
          //                               },
          //                               style: TextButton.styleFrom (
          //                                 padding: EdgeInsets.zero,
          //                               ),
          //                               child: Container(
          //                                 width: 131*fem,
          //                                 height: double.infinity,
          //                                 decoration: BoxDecoration (
          //                                   border: Border.all(color: Color(0xffe77817)),
          //                                   borderRadius: BorderRadius.circular(97.3562927246*fem),
          //                                   color: Colors.white,
          //                                   boxShadow: [
          //                                     BoxShadow(
          //                                       color: Color(0x33000000),
          //                                       offset: Offset(0*fem, 11.6827545166*fem),
          //                                       blurRadius: 16*fem,
          //                                     ),
          //                                   ],
          //                                 ),
          //                                 child: Center(
          //                                   child: Text(
          //                                     'SKIP',
          //                                     textAlign: TextAlign.center,
          //                                     style: SafeGoogleFont (
          //                                       'Poppins',
          //                                       fontSize: 18*ffem,
          //                                       fontWeight: FontWeight.w600,
          //                                       height: 1.5*ffem/fem,
          //                                       color: Color(0xffe77817),
          //                                     ),
          //                                   ),
          //                                 ),
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                       ) : SizedBox.shrink(),
          //                 Material(
          //                   child:
          //                   state.storingQRCode == null ? SizedBox.shrink() :
          //                   Text(
          //                     state.storingQRCode!,
          //                     style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),
          //                   ),
          //                 ),
          //                       state.storingQRCode != null ?
          //                       Row(
          //                         mainAxisAlignment: MainAxisAlignment.center,
          //                         children:[
          //                           Container(
          //                             margin: const EdgeInsets.all(20),
          //                             width: 100,
          //                             height: 30,
          //                             decoration:   BoxDecoration(
          //                               // shape: BoxShape.circle,
          //                               borderRadius: BorderRadius.circular(12),
          //                               gradient:   RadialGradient(
          //                                 radius: 2,
          //                                 // focalRadius: 5,
          //                                 colors: [
          //
          //                                   const Color(0xFFE77817) ,
          //                                   const Color(0xFFF8B57B) ],
          //
          //                               ),
          //                             ),
          //                             child: ElevatedButton(
          //                               style: ElevatedButton.styleFrom(
          //                                 backgroundColor: Colors.transparent,
          //                                 shadowColor: Colors.transparent,
          //                                 shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(0)),
          //                               ),
          //                               onPressed: () {
          //                                 debugPrint('checking the promodecodecontroller ${width}');
          //                                 if(width < 900){
          //                                   loginBloc.add(BarCodeAddingEvent(qrCode: state.storingQRCode.toString()));                                                                }
          //
          //
          //                               },
          //                               child:  Text(
          //                                 'YES',
          //                                 style: const TextStyle(color: Colors.white),
          //                               ),
          //                             ),
          //                           ),
          //                           Container(
          //                             margin: const EdgeInsets.all(20),
          //                             width: 100,
          //                             height: 30,
          //                             decoration:   BoxDecoration(
          //                               // shape: BoxShape.circle,
          //                               borderRadius: BorderRadius.circular(12),
          //                               gradient:   RadialGradient(
          //                                 radius: 2,
          //                                 // focalRadius: 5,
          //                                 colors: [
          //                                    Colors.grey.shade300,
          //                                  Colors.grey.shade300],
          //
          //                               ),
          //                             ),
          //                             child: ElevatedButton(
          //                               style: ElevatedButton.styleFrom(
          //                                 backgroundColor: Colors.transparent,
          //                                 shadowColor: Colors.transparent,
          //                                 shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(0)),
          //                               ),
          //                               onPressed: () {
          //                                 debugPrint('checking the promodecodecontroller ${width}');
          //
          //
          //
          //                                 if(PlatformType.isTv!= false){
          //                                   // Navigator.of(context, rootNavigator: true).pop(buildContext);
          //                                   loginBloc.add(QRCodeScanningEvent());
          //                                   //cancel_button
          //                                   // Navigator.pop(context);
          //
          //                                 }
          //
          //
          //                               },
          //                               child:  Text(
          //                                 'NO',
          //                                 style: const TextStyle(color: Colors.white),
          //                               ),
          //                             ),
          //                           ),
          //                         ]
          //                       ) :
          //                       SizedBox.shrink(),
          //
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             );
          //           }
          //       );
          //     });

        }
        else if (state is QRCodeButtonSuccessState) {
          Navigator.pushAndRemoveUntil(context,
              PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 100),
                  child:  QRViewPage()),(Route<dynamic> route) => true);
        }
      else  if (state is SapienceParentDialogButtonLoadedSuccessState) {

          Navigator.pushAndRemoveUntil(context,
              PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 100),
                  child: const DashboardScreenView()),(Route<dynamic> route) => false);
        }
        else if (state is SapienceParentDialogButtonErrorState) {

          if (state.error.isNotEmpty) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        }
        else if (state is BarCodeAddingButtonLoadingState) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('BarCode Loading please wait ....')));
        }
      else  if (state is BarCodeAddingButtonLoadedSuccessState) {

          Navigator.pushAndRemoveUntil(context,
              PageTransition(
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 100),
                  child: const DashboardScreenView()),(Route<dynamic> route) => false);
        }
        else if (state is BarCodeAddingButtonErrorState) {
          if (state.error.isNotEmpty) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        }



        else if (state is LoginButtonLoadingState) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Loading please wait ....')));
        } else if (state is LoginButtonErrorState) {
          if (state.error.isNotEmpty) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        } else if (state is GetOtpButtonLoadedSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(state.message)));
          isOtpSent = true;
        } else if (state is GetOtpButtonLoadingState) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sending please wait ....')));
        } else if (state is GetOtpButtonErrorState) {
          if (state.error.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    '${state.error},OTP error')));
          }
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case LoginLoadingState:
            return const Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          case LoginLoadedSuccessState:
            // Future.delayed(Duration(seconds: 3),(){
            //   FocusScope.of(context).nextFocus();
            // });
            final successState = state as LoginLoadedSuccessState;
            double baseWidth = 800.0000610352;
            double fem = MediaQuery.of(context).size.width / baseWidth;
            double ffem = fem * 0.97;
            return WillPopScope(
              onWillPop: _onWillPop,
              child: Scaffold(
                // backgroundColor: Colors.red,
                body: Stack(
                  children: [
                    // SizedBox(
                    //     height: double.maxFinite,
                    //     width: double.maxFinite,
                    //     child:  SvgPicture.asset(
                    //       'assets/login_bc.svg',
                    //       semanticsLabel: 'Acme Logo',
                    //       fit: BoxFit.fill,
                    //     )
                    //         .animate(onPlay: (controller) => controller.repeat())
                    //     // this "pads out" the total duration
                    //         .effect(delay: 200.ms, duration: 1500.ms).shake()
                    // ),
                    Positioned(
                      // login1mR3 (12:38)
                      left: 0*fem,
                      top: 0*fem,
                      child: Container(
                          width: 800*fem,
                          height: MediaQuery.of(context).size.height,
                          child: Image.asset(
                            'assets/LoginScreen.jpg',
                            // 'assets/Login.jpg',
                            fit: BoxFit.cover,
                          )
                              // .animate().effect(duration: 3000.ms) // this "pads out" the total duration
                              // .effect( duration: 500.ms).scaleY()
                              // .animate(onPlay: (controller) => controller.repeat())
                              // .effect(duration: 3000.ms) // this "pads out" the total duration
                              // .effect(delay: 750.ms, duration: 1500.ms).shimmer()
                      ),
                    ),
                    // Positioned(
                    //   bottom: 0,
                    //   right: 150,
                    //   child: SizedBox(
                    //     height: height * 0.15,
                    //     width: width * 0.1,
                    //     child: SvgPicture.asset(
                    //       'assets/yellow_tree.svg',
                    //       fit: BoxFit.fill,
                    //     )
                    //         // .animate()
                    //         // .effect(duration: 3000.ms) // this "pads out" the total duration
                    //         // .effect(delay: 750.ms, duration: 1500.ms).shake()
                    //         // .animate(onPlay: (controller) => controller.repeat())
                    //         // .effect(duration: 3000.ms) // this "pads out" the total duration
                    //         // .effect(delay: 1000.ms, duration: 1500.ms).shimmer()
                    //     ,
                    //   ),
                    // ),
                    Positioned(
                      // loginUaM (4:7)
                      left: 512*fem,
                      top: 70*fem,
                      child: Container(
                        width: 230*fem,
                        height: 250*fem,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Form(
                                key: _mobileKey,
                                child: TextFormField(
                                  maxLength: 10,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    // for below version 2 use this
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                                    FilteringTextInputFormatter.digitsOnly

                                  ],
                                  autofocus: false,
                                  controller: mobileNumberTextController,
                                  obscureText: false,
                                  // autofocus: true,
                                  focusNode: mobileNumberFocusNode,
                                  validator: (value) {
                                    if (value == null || value.isEmpty || value.length < 10) {
                                      return 'Please Enter The Correct Number';
                                    }
                                    return null;
                                  },
                                  // onSubmitted: (value){
                                  //   ScaffoldMessenger.of(context)
                                  //       .showSnackBar(const SnackBar(content: Text('email on submit')));
                                  //   passwordFocusNode.requestFocus();
                                  // },
                                  onEditingComplete: (){
                                    // otpFocusNode.requestFocus();
                                    // FocusScope.of(context).nextFocus();
                                    if(_mobileKey.currentState!.validate()){
                                      loginBloc.add(GetOtpEvent(
                                        mobileNo: int.parse(mobileNumberTextController.text.trim()),));

                                    }
                                  },
                                  decoration:   InputDecoration(
                                    labelStyle: SafeGoogleFont (
                                    'Poppins',
                                    fontSize: 10*ffem,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5*ffem/fem,
                                    color: Color(0xff5b84c2),
                                  ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white,width: 2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFEFF5FF),
                                    border: const OutlineInputBorder(),
                                    labelText: 'Enter Mobile Number',
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 1*fem, 1*fem),
                                child: InkWell(
                                    onTap: () {

                                      if(_mobileKey.currentState!.validate()){
                                       loginBloc.add(GetOtpEvent(
                                         mobileNo: int.parse(mobileNumberTextController.text.trim()),));
                                     }
                                    },
                                    child:  Text(
                                      'Get OTP',
                                      style: SafeGoogleFont (
                                        'Poppins',
                                        fontSize: 14*ffem,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5*ffem/fem,
                                        color: Colors.white,
                                      ),
                                    ),
                                ),
                              ),
                              Form(
                                key: _otpKey,
                                child: TextFormField(
                                  maxLength: 6,
                                  validator: (value) {
                                    if(isOtpSent){
                                      if (value == null || value.isEmpty || value.length < 6 ) {
                                        return 'Please Enter The Correct OTP';
                                      }
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    // for below version 2 use this
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                                    FilteringTextInputFormatter.digitsOnly

                                  ],
                                  focusNode: otpFocusNode,
                                  controller: otpTextController,
                                  obscureText: true,
                                  decoration:  InputDecoration(
                                    labelStyle: SafeGoogleFont (
                                      'Poppins',
                                      fontSize: 10*ffem,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5*ffem/fem,
                                      color: Color(0xff5b84c2),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white,width: 2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFEFF5FF),
                                    border: const OutlineInputBorder(),
                                    labelText: 'Enter OTP',
                                  ),
                                  // onSubmitted: (value){
                                  //   passwordFocusNode.dispose();
                                  //   ScaffoldMessenger.of(context)
                                  //       .showSnackBar(const SnackBar(content: Text('password on submit')));
                                  // },
                                  onEditingComplete: (){
                                    FocusScope.of(context).nextFocus();
                                    var number = mobileNumberTextController.text.trim();
                                    var otp = otpTextController.text.trim();
                                    if(_mobileKey.currentState!.validate()){

                                      if(_otpKey.currentState!.validate()){
                                        loginBloc.add(LoginWithEmailIdAndPasswordEvent(
                                            mobileNo: int.parse(number),
                                            otp: int.parse(otp)));
                                      }

                                      // loginBloc.add(LoginWithEmailIdAndPasswordEvent(
                                      //     mobileNo: int.parse(number),
                                      //     otp: int.parse(otp)));
                                    }
                                  },
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 40*fem,
                                decoration: BoxDecoration (
                                  borderRadius: BorderRadius.circular(20*fem),
                                  gradient: RadialGradient (
                                    center: Alignment(0.726, -0.425),
                                    radius: 1.12,
                                    colors: <Color>[Color(0xffe97d1e), Color(0xfff8b67b)],
                                    stops: <double>[0, 1],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x3f000000),
                                      offset: Offset(0*fem, 4*fem),
                                      blurRadius: 17*fem,
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    minimumSize: MaterialStateProperty.all(Size(width, 50)),
                                    backgroundColor:
                                    MaterialStateProperty.all(Colors.transparent),
                                    // elevation: MaterialStateProperty.all(3),
                                    shadowColor:
                                    MaterialStateProperty.all(Colors.transparent),
                                  ),
                                  onPressed: () {

                                    //login_button_pressed

                                    // loginBloc.add(QRCodeScanningEvent(isScannerOpen: true));



                                    var number = mobileNumberTextController.text.trim();
                                    var otp = otpTextController.text.trim();
                                    if(_mobileKey.currentState!.validate()){

                                      if(_otpKey.currentState!.validate()){
                                        loginBloc.add(LoginWithEmailIdAndPasswordEvent(
                                            mobileNo: int.parse(number),
                                            otp: int.parse(otp)));
                                      }

                                      // loginBloc.add(LoginWithEmailIdAndPasswordEvent(
                                      //     mobileNo: int.parse(number),
                                      //     otp: int.parse(otp)));
                                    }




                                    // loginBloc.add(LoginWithEmailIdAndPasswordEvent(
                                    //     mobileNo: int.parse('8778480033'),
                                    //     otp: int.parse('228161')));
                                    // FocusScope.of(context).nextFocus();
                                  },
                                  child: Center(
                                    child: Text(
                                      'LOGIN',
                                      style: SafeGoogleFont (
                                        'Poppins',
                                        fontSize: 14*ffem,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5*ffem/fem,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // loginPWH (4:10)
                      left: 602*fem,
                      top: 41*fem,
                      child: Align(
                        child: SizedBox(
                          width: 49*fem,
                          height: 24*fem,
                          child: Text(
                            'LOGIN',
                            style: SafeGoogleFont (
                              'Poppins',
                              fontSize: 16*ffem,
                              fontWeight: FontWeight.w600,
                              height: 1.5*ffem/fem,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    muteButtonConfig(),
                    // Positioned(
                    //   bottom: 0,
                    //   left: 0,
                    //   child: SizedBox(
                    //     height: height * 0.2,
                    //     width: width * 0.1,
                    //     child: SvgPicture.asset(
                    //       'assets/blue_tree.svg',
                    //       fit: BoxFit.fill,
                    //     )
                    //         // .animate()
                    //         // .effect(duration: 3000.ms) // this "pads out" the total duration
                    //         // .effect(delay: 750.ms, duration: 1500.ms).shake()
                    //         // .animate(onPlay: (controller) => controller.repeat())
                    //         // .effect(duration: 3000.ms) // this "pads out" the total duration
                    //         // .effect(delay: 1000.ms, duration: 1500.ms).shimmer()
                    //     ,
                    //   ),
                    // ),
                    // Positioned(
                    //   bottom: 40,
                    //   left: 180,
                    //   child: SizedBox(
                    //     height: height * 0.35,
                    //     width: width * 0.2,
                    //     child: SvgPicture.asset(
                    //       'assets/baby1_bc.svg',
                    //       fit: BoxFit.fill,
                    //     )
                    //         // .animate()
                    //         // .effect(duration: 3000.ms) // this "pads out" the total duration
                    //         // .effect(delay: 750.ms, duration: 1500.ms).shake()
                    //         // .animate(onPlay: (controller) => controller.repeat())
                    //         // .effect(duration: 3000.ms) // this "pads out" the total duration
                    //         // .effect(delay: 1000.ms, duration: 1500.ms).shimmer()
                    //     ,
                    //   ),
                    // ),
                    // Positioned(
                    //   bottom: 15,
                    //   left: 170,
                    //   child: SizedBox(
                    //     height: height * 0.3,
                    //     width: width * 0.1,
                    //     child: SvgPicture.asset(
                    //       'assets/books_row.svg',
                    //       fit: BoxFit.fill,
                    //     )
                    //         // .animate()
                    //         // .effect(duration: 3000.ms) // this "pads out" the total duration
                    //         // .effect(delay: 750.ms, duration: 1500.ms).shake()
                    //         // .animate(onPlay: (controller) => controller.repeat())
                    //         // .effect(duration: 3000.ms) // this "pads out" the total duration
                    //         // .effect(delay: 1000.ms, duration: 1500.ms).shimmer()
                    //     ,
                    //   ),
                    // ),
                    // Positioned(
                    //   bottom: 15,
                    //   left: width * 0.39,
                    //   child: SizedBox(
                    //     height: height * 0.3,
                    //     width: width * 0.15,
                    //     child: SvgPicture.asset(
                    //       'assets/baby2_bc.svg',
                    //       semanticsLabel: 'Acme Logo',
                    //       fit: BoxFit.fill,
                    //     )
                    //         // .animate()
                    //         // .effect(duration: 3000.ms) // this "pads out" the total duration
                    //         // .effect(delay: 750.ms, duration: 1500.ms).shake()
                    //         // .animate(onPlay: (controller) => controller.repeat())
                    //         // .effect(duration: 3000.ms) // this "pads out" the total duration
                    //         // .effect(delay: 1000.ms, duration: 1500.ms).shimmer()
                    //     ,
                    //   ),
                    // ),
                    // Positioned(
                    //   bottom: 20,
                    //   right: 320,
                    //   child: SizedBox(
                    //     height: height * 0.3,
                    //     width: width * 0.15,
                    //     child: SvgPicture.asset(
                    //       'assets/rabbit_bc.svg',
                    //       fit: BoxFit.fill,
                    //     )
                    //         // .animate()
                    //         // .effect(duration: 3000.ms) // this "pads out" the total duration
                    //         // .effect(delay: 750.ms, duration: 1500.ms).shake()
                    //         // .animate(onPlay: (controller) => controller.repeat())
                    //         // .effect(duration: 3000.ms) // this "pads out" the total duration
                    //         // .effect(delay: 1000.ms, duration: 1500.ms).shimmer()
                    //     ,
                    //   ),
                    // ),

                    // Positioned(
                    //   bottom: 0,
                    //   right: 50,
                    //   child: SizedBox(
                    //     height: height * 0.15,
                    //     width: width * 0.1,
                    //     child: SvgPicture.asset(
                    //       'assets/blue_tree2.svg',
                    //       fit: BoxFit.fill,
                    //     )
                    //         // .animate()
                    //         // .effect(duration: 3000.ms) // this "pads out" the total duration
                    //         // .effect(delay: 750.ms, duration: 1500.ms).shake()
                    //         // .animate(onPlay: (controller) => controller.repeat())
                    //         // .effect(duration: 3000.ms) // this "pads out" the total duration
                    //         // .effect(delay: 1000.ms, duration: 1500.ms).shimmer()
                    //     ,
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          case LoginErrorState:
            RxString? val = ''.obs;
            CheckInternetConnection.instance.checkInternet().then((value) {
              print('v--> ${value.toString()}');
              if (value.toString() == 'none') {
                val.value = 'No Internet Connection';
              }
              else {
                val.value =  'Error ';
              }
            });

            return Obx(() {
              return WillPopScope(
                onWillPop: _onWillPop,
                child: Scaffold(
                    body: Center(
                        child: Text(val.value))),
              );
            });
          default:
            return const SizedBox();
        }
      },
    );
  }
}



