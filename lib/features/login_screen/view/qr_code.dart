import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimu_tv/features/dashboard_screen/database_items/items_data.dart';
import 'package:nimu_tv/features/login_screen/bloc/login_bloc.dart';
import 'package:nimu_tv/features/login_screen/database/create_user_doc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/color_const.dart';
import '../../../config/shared_preference.dart';
import '../../../config/utils.dart';
import '../../../main.dart';
import '../../dashboard_screen/api/dashboard_api.dart';
import '../../dashboard_screen/view/dashboard_screen.dart';
import '../../splash_screen/view/splash_screen_view.dart';
import '../api/login_api.dart';
import '../models/qrModel.dart';



class QRViewPage extends StatefulWidget {
  const QRViewPage({Key? key,}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewPageState();
}

class _QRViewPageState extends State<QRViewPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          // Expanded(
          //   flex: 1,
          //   child: FittedBox(
          //     fit: BoxFit.contain,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: <Widget>[
          //         if (result != null)
          //           Text(
          //               'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
          //         else
          //           const Text('Scan a code'),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: <Widget>[
          //             Container(
          //               margin: const EdgeInsets.all(8),
          //               child: ElevatedButton(
          //                   onPressed: () async {
          //                     await controller?.toggleFlash();
          //                     setState(() {});
          //                   },
          //                   child: FutureBuilder(
          //                     future: controller?.getFlashStatus(),
          //                     builder: (context, snapshot) {
          //                       return Text('Flash: ${snapshot.data}');
          //                     },
          //                   )),
          //             ),
          //             Container(
          //               margin: const EdgeInsets.all(8),
          //               child: ElevatedButton(
          //                   onPressed: () async {
          //                     await controller?.flipCamera();
          //                     setState(() {});
          //                   },
          //                   child: FutureBuilder(
          //                     future: controller?.getCameraInfo(),
          //                     builder: (context, snapshot) {
          //                       if (snapshot.data != null) {
          //                         return Text(
          //                             'Camera facing ${describeEnum(snapshot.data!)}');
          //                       } else {
          //                         return const Text('loading');
          //                       }
          //                     },
          //                   )),
          //             )
          //           ],
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: <Widget>[
          //             Container(
          //               margin: const EdgeInsets.all(8),
          //               child: ElevatedButton(
          //                 onPressed: () async {
          //                   await controller?.pauseCamera();
          //                 },
          //                 child: const Text('pause',
          //                     style: TextStyle(fontSize: 20)),
          //               ),
          //             ),
          //             Container(
          //               margin: const EdgeInsets.all(8),
          //               child: ElevatedButton(
          //                 onPressed: () async {
          //                   await controller?.resumeCamera();
          //                 },
          //                 child: const Text('resume',
          //                     style: TextStyle(fontSize: 20)),
          //               ),
          //             )
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

   _navigateToDashboard() async {



     try {
       // bool logout = await DashboardApi.logout();
       // await Future.delayed(const Duration(milliseconds: 100));

       _nav();

       // if(logout){
       //
       //   SharedPreferences preferences = await sharedPref();
       //   preferences.remove('mobileNo',);
       //   preferences.remove('token', );
       //   preferences.remove('created_at', );
       //   preferences.remove('updated_at', );
       //   preferences.remove('role', );
       //   preferences.remove('otp', );
       //   preferences.remove('isLoggedIn',);
       //   preferences.remove('user_subscription', );
       //   preferences.remove('isLKGAvailable',);
       //   preferences.remove('isUKGAvailable',);
       //   preferences.remove('isKidsFoodVideoAvailable',);
       //
       //  _nav();
       // }
       // else
       // {
       //
       //   Get.snackbar(
       //     'Error',
       //     'error occurred while logout',
       //     colorText: Colors.white,
       //     backgroundColor: Colors.lightBlue,
       //     icon: const Icon(Icons.add_alert),
       //   );
       // }

     } catch (e) {
       Get.snackbar(
         'Error',
         'error occurred while logout',
         colorText: Colors.white,
         backgroundColor: Colors.lightBlue,
         icon: const Icon(Icons.add_alert),
       );

     }
  }
  _nav(){
    dashboardModel = null;
    return
    Navigator.pushAndRemoveUntil(context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.center,
            duration: const Duration(milliseconds: 100),
            child: const DashboardScreenView()),(Route<dynamic> route) => false);
            // child: const SplashScreenView()),(Route<dynamic> route) => false);
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.


    print('color ${Color2.red.name}');
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    double baseWidth = 800.0000610352;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    this.controller = controller;


    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        storingQrCode = result?.code;
        if(result != null){
          debugPrint('checking the scanned data ${result!.code}');
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) => const MyHome(),
          // ));

          controller.resumeCamera();
          // widget.loginBloc.add(QRCodeScanningEvent(storingQRCode: result?.code,isScannerOpen: true));





          showGeneralDialog(
              context: context,
              barrierDismissible: true,
              barrierLabel: MaterialLocalizations.of(context)
                  .modalBarrierDismissLabel,
              barrierColor: Colors.transparent,
              transitionDuration: const Duration(milliseconds: 200),
              pageBuilder: (BuildContext buildContext,
                  Animation animation,
                  Animation secondaryAnimation) {
                return StatefulBuilder(
                    builder: (context, changingState) {
                      return Center(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 21*fem),
                          width: 371*fem,
                          height:  244*fem,
                          decoration: BoxDecoration (
                            color: Color(0xfffcfcfe),
                            borderRadius: BorderRadius.circular(8*fem),
                          ),
                          child: Column(
                            children: [
                              Container(
                                // autogroup9uftEDo (D6iWZLEbge3D3evb7c9UfT)
                                margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 11*fem),
                                width:  double.infinity,
                                height:  53*fem,
                                decoration:  BoxDecoration (
                                  color:  Color(0xff00588e),
                                  borderRadius:  BorderRadius.only (
                                    topLeft:  Radius.circular(8*fem),
                                    topRight:  Radius.circular(8*fem),
                                  ),
                                ),
                                child: Center(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: ListTile(
                                      leading:   Text(
                                        'SAPIENCE PARENTS',
                                        textAlign:  TextAlign.center,
                                        style:  SafeGoogleFont (
                                          'Poppins',
                                          fontSize:  18*ffem,
                                          fontWeight:  FontWeight.w700,
                                          height:  1.2222222222*ffem/fem,
                                          letterSpacing:  0.7920002747*fem,
                                          color:  Color(0xffffffff),
                                        ),
                                      ),
                                      trailing: IconButton(
                                          onPressed: (){
                                            Navigator.pushAndRemoveUntil(context,
                                                PageTransition(
                                                    type: PageTransitionType.scale,
                                                    alignment: Alignment.center,
                                                    duration: const Duration(milliseconds: 100),
                                                    child: const DashboardScreenView()),(Route<dynamic> route) => false);
                                          },
                                          icon: Icon(Icons.close,color: Colors.white,)),
                                    ),
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: Container(
                                  // ifyourchildisstudyingschoolass (567:1164)
                                  margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 29*fem),
                                  constraints:  BoxConstraints (
                                    maxWidth:  324*fem,
                                  ),
                                  child:
                                  RichText(
                                    textAlign:  TextAlign.center,
                                    text:
                                    TextSpan(
                                      style:  SafeGoogleFont (
                                        'Poppins',
                                        fontSize:  13*ffem,
                                        fontWeight:  FontWeight.w400,
                                        height:  1.2307692308*ffem/fem,
                                        color:  Color(0xff666666),
                                      ),
                                      children:  [
                                        TextSpan(
                                          text:  'If your child is studying school as ',
                                          style:  SafeGoogleFont (
                                            'Poppins',
                                            fontSize:  13*ffem,
                                            fontWeight:  FontWeight.w400,
                                            height:  1.2307692308*ffem/fem,
                                            color:  Color(0xff666666),
                                          ),
                                        ),
                                        TextSpan(
                                          text:  'SAPIENCE BOOK',
                                          style:  SafeGoogleFont (
                                            'Poppins',
                                            fontSize:  13*ffem,
                                            fontWeight:  FontWeight.w700,
                                            height:  1.2307692308*ffem/fem,
                                            color:  Color(0xff666666),
                                          ),
                                        ),
                                        TextSpan(
                                          text:  '.\nCheck the ',
                                          style:  SafeGoogleFont (
                                            'Poppins',
                                            fontSize:  13*ffem,
                                            fontWeight:  FontWeight.w400,
                                            height:  1.2307692308*ffem/fem,
                                            color:  Color(0xff666666),
                                          ),
                                        ),
                                        TextSpan(
                                          text:  'QR CODE',
                                          style:  SafeGoogleFont (
                                            'Poppins',
                                            fontSize:  13*ffem,
                                            fontWeight:  FontWeight.w700,
                                            height:  1.2307692308*ffem/fem,
                                            color:  Color(0xff666666),
                                          ),
                                        ),
                                        TextSpan(
                                          text:  ' on the book which act as a\n',
                                          style:  SafeGoogleFont (
                                            'Poppins',
                                            fontSize:  13*ffem,
                                            fontWeight:  FontWeight.w400,
                                            height:  1.2307692308*ffem/fem,
                                            color:  Color(0xff666666),
                                          ),
                                        ),
                                        TextSpan(
                                          text:  'PROMO CODE',
                                          style:  SafeGoogleFont (
                                            'Poppins',
                                            fontSize:  13*ffem,
                                            fontWeight:  FontWeight.w700,
                                            height:  1.2307692308*ffem/fem,
                                            color:  Color(0xff666666),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        Material(
                          child:
                          Text(
                            '${result!.code}',
                            style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),
                          ),
                        ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                  Container(
                                    margin: const EdgeInsets.all(20),
                                    width: 100,
                                    height: 30,
                                    decoration:   BoxDecoration(
                                      // shape: BoxShape.circle,
                                      borderRadius: BorderRadius.circular(12),
                                      gradient:   RadialGradient(
                                        radius: 2,
                                        // focalRadius: 5,
                                        colors: [

                                          const Color(0xFFE77817) ,
                                          const Color(0xFFF8B57B) ],

                                      ),
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(0)),
                                      ),
                                      onPressed: () async {
                                        // debugPrint('checking the promodecodecontroller ${width}');
                                        var responseValue;
                                        if(PlatformType.isTv == false){


                                          SharedPreferences preferences = await sharedPref();
                                          final String? token = preferences.getString('token');
                                          debugPrint(' checking the token value $token');

                                          final   response = await MobileApi.getPromoCodeStatus(qrCode: result!.code,token: token);

                                          debugPrint(' checking the scanned qr status  ${response.body}');
                                          responseValue = json.decode(response.body);
                                          // qrModel = qrModelFromJson(response.body);

                                          debugPrint(' checking the scanned qr status code  ${responseValue['data']}');



                                          if(response.statusCode == 200 && responseValue['data'] != 401){
                                            debugPrint(' _navigateToDashboard  ');

                                            _navigateToDashboard();
                                          }
                                          else
                                          {

                                            Get.snackbar(
                                              'Error',
                                              '${responseValue['message']},QR CODE error',
                                              colorText: Colors.white,
                                              backgroundColor: Colors.lightBlue,
                                              icon: const Icon(Icons.add_alert),
                                            );


                                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            //     content: Text(
                                            //         '${qrModel!.message},OTP error')));
                                            // emit(GetOtpButtonErrorState(error: ));
                                          }

                                        }

                                        // if(width < 900){
                                        //   loginBloc.add(BarCodeAddingEvent(qrCode: state.storingQRCode.toString()));
                                        // }
},
                                      child:  Text(
                                        'YES',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(20),
                                    width: 100,
                                    height: 30,
                                    decoration:   BoxDecoration(
                                      // shape: BoxShape.circle,
                                      borderRadius: BorderRadius.circular(12),
                                      gradient:   RadialGradient(
                                        radius: 2,
                                        // focalRadius: 5,
                                        colors: [
                                           Colors.grey.shade300,
                                         Colors.grey.shade300],

                                      ),
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(0)),
                                      ),
                                      onPressed: () {
                                        // debugPrint('checking the promodecodecontroller ${width}');
                                        print('checking the no button ');


                                        if(PlatformType.isTv == false){
                                          // Navigator.of(context, rootNavigator: true).pop(buildContext);
                                          // loginBloc.add(QRCodeScanningEvent());


                                          Navigator.pushAndRemoveUntil(context,
                                              PageTransition(
                                                  type: PageTransitionType.scale,
                                                  alignment: Alignment.center,
                                                  duration: const Duration(milliseconds: 100),
                                                  child:  QRViewPage()),(Route<dynamic> route) => true);




                                          //cancel_button


                                        }


                                      },
                                      child:  Text(
                                        'NO',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ]
                              ) ,

                            ],
                          ),
                        ),
                      );
                    }
                );
              });




         // Future.delayed(Duration(milliseconds: 500),(){
         //   Navigator.pop(context);
         // });

        }
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}