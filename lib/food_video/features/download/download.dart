
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';


Rx<num> downloadFoodPercentage = 0.obs;

Future downloadFoodFile({String? url,String? title}) async {
  Dio dio = Dio();

  try {
    var dir = await getApplicationDocumentsDirectory();
    debugPrint('checking the directory ${dir.path}');
    await dio.download(url!, "${dir.path}/video-url/$url", onReceiveProgress: (rec, total) {

      int percentage = ((rec / total) * 100).floor();

     if(percentage % 5 == 0){
       downloadFoodPercentage.value = percentage;
     }

      print("percentage $percentage");
    },);
    return '${dir.path}/video-url';
  } catch (e) {
    print(e);
  }
  print("Download completed");
}