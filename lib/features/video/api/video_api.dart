// import 'package:appwrite/appwrite.dart';
// import 'package:appwrite/models.dart' as models;
//
// import '../../../data/appwrite_client.dart';
//



import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nimu_tv/config/shared_preference.dart';
import 'package:nimu_tv/features/login_screen/database/create_user_doc.dart';
import 'package:nimu_tv/features/login_screen/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const String apiUrl = 'https://www.sapiencepublications.co.in/api';

class VideoApi {
  static Future getVideoSections({ String? token,int? videoNumber, bool? isDTTC = false}) async {
    debugPrint('checking the qrcode $token dbug video number $videoNumber');
    var errorState;



    if(isDTTC == true){
      try {
        final Uri url = Uri.parse(
            '$apiUrl/dttcvideos/$videoNumber');
        final response = await http.get(url,
            headers: {
              'Authorization': 'Bearer $token',
            });

        debugPrint('checking the jsonData ${json.decode(response.body)}');
        errorState = response;

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);


          debugPrint('checking the jsonData $jsonData');

          return response;
        } else {
          debugPrint('Request failed with status: ${response.statusCode}');
          return errorState;
        }
      } catch (error) {
        return errorState;
      }
    }
    else
      {
        try {
          final Uri url = Uri.parse(
              '$apiUrl/videos/$videoNumber');
          final response = await http.get(url,
              headers: {
                'Authorization': 'Bearer $token',
              });

          debugPrint('checking the jsonData ${json.decode(response.body)}');
          errorState = response;

          if (response.statusCode == 200) {
            final jsonData = json.decode(response.body);


            debugPrint('checking the jsonData $jsonData');

            return response;
          } else {
            debugPrint('Request failed with status: ${response.statusCode}');
            return errorState;
          }
        } catch (error) {
          return errorState;
        }
      }
  }

}