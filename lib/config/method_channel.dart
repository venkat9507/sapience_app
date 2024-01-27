
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const platform = MethodChannel('android.tv');
Future<bool> isAndroidTv() async {
  final bool isTv = await platform.invokeMethod('isLeanbackLauncherDevice');
  return isTv;
}


extension FindingTheAndoidDevice on bool {

  Future<bool> get findingTheAndroidDevice => isAndroidTv();
}


// class CheckingTv {
//
//  static Future<bool> checkingTheTv()async{
//    bool? Tv;
//    bool isTv = await isAndroidTv().then((value) {
//      print('checking the value $value');
//       Tv = value;
//      return false;
//    });
//
//    // debugPrint('checking the tv $isTv');
//
//     return Tv;
//
//   }
// }