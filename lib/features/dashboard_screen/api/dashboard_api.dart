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

class DashboardApi {
  static Future getDashboardSections({ String? token,}) async {
    print('checking the qrcode $token');
    http.Response? errorState;


    try {
      final Uri url = Uri.parse(
          '$apiUrl/sections');
      final response = await http.get(url,
          headers: {
            // 'Content-Type': 'application/json',
            // 'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });

      debugPrint('checking the jsonData ${json.decode(response.body)}');
      errorState = response;




      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);


        debugPrint('checking the jsonData $jsonData');

        return response;
      } else {
        print('Request failed with status: ${response.statusCode}');
        return errorState;
      }


    } catch (error) {
      return errorState;
      print('Error: $error');
    }
  }
  static Future logout() async {


    try {
      SharedPreferences preferences = await sharedPref();
      preferences.remove('mobileNo',);
      preferences.remove('token', );
      preferences.remove('created_at',);
      preferences.remove('updated_at', );
      preferences.remove('role', );
      preferences.remove('otp', );
      preferences.remove('isLoggedIn',);
      preferences.remove('user_subscription',);

      return true;

    } catch (error) {
      print('Error: $error');
    }
  }

}