import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/shared_preference.dart';
import '../../features/login_screen/database/create_user_doc.dart';
import '../../features/login_screen/models/user_model.dart';
const String apiUrl = 'https://www.sapiencepublications.co.in/api';


class UserDataApi {
  static Future getUserApi({ String? token,}) async {
    print('checking the qrcode $token');
    var errorState;


    try {
      final Uri url = Uri.parse(
          '$apiUrl/get-user');
      final response = await http.get(url,
          headers: {
            // 'Content-Type': 'application/json',
            // 'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });

      debugPrint('checking the jsonData ${json.decode(response.body)}');
      errorState = response;

      try {
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);

          userData = userModelFromJson(response.body);

          SharedPreferences preferences = await sharedPref();

          for (var e in userData!.data.subscriptionList) {
            print('checking inside the subscription list map part ');
            var isLKGAvailable =  e.name.contains('LKG');
            var isUKGAvailable =  e.name.contains('UKG');
            var isKidsFoodVideoAvailable =  e.name.contains('KIDS FOOD VIDEO');

            print('checking the lkg contains ${ e.name.contains('LKG')} isLKGAvailable $isLKGAvailable');
            print('checking the ukg contains ${ e.name.contains('UKG')} isUKGAvailable $isUKGAvailable');

            if(isLKGAvailable == true){
              preferences.setBool('isLKGAvailable',  true);
              print('checking the lkg available ${preferences.getBool('isLKGAvailable',)}');
            }

            if(isUKGAvailable == true){
              preferences.setBool('isUKGAvailable',  true);
              print('checking the ukg available ${preferences.getBool('isUKGAvailable',)}');
            }
            if(isKidsFoodVideoAvailable == true){
              preferences.setBool('isKidsFoodVideoAvailable',  true);
              print('checking the kids food video available ${preferences.getBool('isKidsFoodVideoAvailable',)}');
            }
          }


          debugPrint('checking the jsonData $jsonData');

          return response;

          // return response;
        } else {
          print('Request failed with status: ${response.statusCode}');
          return errorState;
        }
      }
      on FormatException catch (error) {

        print('Error: get user  $error');

        return errorState;
      }






    } catch (error) {
      return errorState;
      print('Error: $error');
    }
  }
}