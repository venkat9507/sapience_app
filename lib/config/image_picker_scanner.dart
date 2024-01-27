
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scan/scan.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/dashboard_screen/view/dashboard_screen.dart';
import '../features/login_screen/api/login_api.dart';
import '../main.dart';
import 'shared_preference.dart';

class ImagePickerScanner {
  File? image;

  _nav(context){


    return
      Navigator.pushAndRemoveUntil(context!,
          PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 100),
              child: const DashboardScreenView()),(Route<dynamic> route) => false);
  }

 static Future pickImage(context) async {


    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemp = File(image.path);

      String? result =await  Scan.parse(image.path);


      var responseValue;
      if(PlatformType.isTv == false){


        SharedPreferences preferences = await sharedPref();
        final String? token = preferences.getString('token');
        debugPrint(' checking the token value $token');

        final   response = await MobileApi.getPromoCodeStatus(qrCode: result!,token: token);

        debugPrint(' checking the scanned qr status  ${response.body}');
        responseValue = json.decode(response.body);
        // qrModel = qrModelFromJson(response.body);

        debugPrint(' checking the scanned qr status code  ${responseValue['data']}');



        if(response.statusCode == 200 && responseValue['data'] != 401){
          debugPrint(' _navigateToDashboard  ');

          var img = ImagePickerScanner();
          img._nav(context);
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

      print('checking the image path ${image.path}'
          'scanner code ${result}');


      // this.image = imageTemp;
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }
}