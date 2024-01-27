
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:nimu_tv/config/method_channel.dart';



// extension MediaQueryExtension on BuildContext {
//   double get width => MediaQuery.of(this).size.width;
//   double get height => MediaQuery.of(this).size.height;
// }

extension EmptyPadding on num {
  SizedBox get ph => SizedBox(height: toDouble(),);
  SizedBox get pw => SizedBox(width: toDouble(),);
}

// Extension class creation for MediaQuery:
extension MediaQueryExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get heightSize => MediaQuery.of(this).size.height;
  double get widthSize => MediaQuery.of(this).size.width;
}


class MyPlatform {
  get tvMode async {
 bool Tv  = await false.findingTheAndroidDevice;
  return Tv;
}
  var isTv ;

  set tvType (bool type)  {

    this.isTv = type;
  }

}



