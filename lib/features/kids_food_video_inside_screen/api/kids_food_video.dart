import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
const String apiUrl = 'https://www.sapiencepublications.co.in/api';
class KidsFoodVideoApi {
  static Future getKFVInsideVideosApi({ String? token,int? sectionID,}) async {
    var errorState;


    try {
      final Uri sectionUrl = Uri.parse(
          '$apiUrl/video-categories?section_id=$sectionID');

      final sectionResponse = await http.get(sectionUrl,
          headers: {

            'Authorization': 'Bearer $token',
          });

      // debugPrint('checking the jsonData sectionResponse.body ${json.decode(sectionResponse.body)}');


      if(sectionResponse.statusCode == 200){
         int? videoCatID;
        final sectionJsonData = json.decode(sectionResponse.body);


         videoCatID = sectionJsonData['data'][0]['id'];
        final Uri url = Uri.parse(
            '$apiUrl/videos?section_id=$sectionID&video_cat_id=$videoCatID');
        final response = await http.get(url,
            headers: {
              'Authorization': 'Bearer $token',
            });

         // debugPrint('checking the jsonData section ID video CatID ${response.statusCode}');
        errorState = response;
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);


          // debugPrint('checking the jsonData section ID video CatID $jsonData');

          return response;
        } else {
          print('Request failed with status: ${response.statusCode}');
          return errorState;
        }
      }





      // debugPrint('checking the jsonData ${json.decode(response.body)}');



    } catch (error) {
      return errorState;
      print('Error: $error');
    }
  }

}