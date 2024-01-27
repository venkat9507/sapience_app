// import 'package:appwrite/appwrite.dart';
// import 'package:appwrite/models.dart' as models;
//
// import '../../../data/appwrite_client.dart';
//



import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nimu_tv/config/shared_preference.dart';
import 'package:nimu_tv/features/login_screen/database/create_user_doc.dart';
import 'package:nimu_tv/features/login_screen/database/local_database.dart';
import 'package:nimu_tv/features/login_screen/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const String apiUrl = 'https://www.sapiencepublications.co.in/api';

class MobileApi {
  static   Future getPromoCodeStatus({String? qrCode,String? token,  }) async {
    print('checking the qrcode from mobile api $qrCode');
    var errorState;


    try {
      final Uri url = Uri.parse('$apiUrl/book-qr-code-validate?qr_code=$qrCode');
      final response =  await http.post(url,
          headers: {
            // 'Content-Type': 'application/json',
            // 'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });

      debugPrint('checking the jsonData qrcode api response ${json.decode(response.body)}');
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
  static   Future getOtp({int? mobileNo,  }) async {
    var errorState;
    try {
      final Uri url = Uri.parse('$apiUrl/generate?phone=$mobileNo');
      final response =  await http.post(url);

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





  static   Future loginWithOtp({int? mobileNo, int? otp }) async {
    var errorState;
    try {
      final Uri url = Uri.parse('$apiUrl/login?phone=$mobileNo&otp=$otp');
      final response =  await http.post(url);

      print('checking the jsonData from login api  ${json.decode(response.body)}');
      errorState = response;

      if (response.statusCode == 200) {
        print('checking the status code 200');
        final jsonData = json.decode(response.body);
        // LocalUserDatabase.instance.createUser(userModelFromJson(response.body));
        // userData = userModelFromJson(response.body);
        // userData = UserModel.fromJson(jsonData);
        return response;

  // await   Future.delayed(Duration(seconds: 1),() async {
  //      SharedPreferences preferences = await sharedPref();
  //      preferences.setInt('mobileNo', mobileNo!);
  //      preferences.setString('token', userData!.data.token);
  //      preferences.setString('created_at', userData!.data.createdAt.toIso8601String());
  //      preferences.setString('updated_at', userData!.data.updatedAt.toIso8601String());
  //      preferences.setString('role', userData!.data.role);
  //      preferences.setInt('otp', otp!);
  //      preferences.setBool('isLoggedIn', true);
  //      preferences.setBool('user_subscription',  userData!.data.userSubscription);
  //
  //      print('checking the user subscription length ${userData!.data.subscriptionList.length}');
  //
  //      for (var e in userData!.data.subscriptionList) {
  //        print('checking inside the subscription list map part ');
  //        var isLKGAvailable =  e.name.contains('LKG');
  //        var isUKGAvailable =  e.name.contains('UKG');
  //        var isKidsFoodVideoAvailable =  e.name.contains('KIDS FOOD VIDEO');
  //
  //        print('checking the lkg contains ${ e.name.contains('LKG')} isLKGAvailable $isLKGAvailable');
  //        print('checking the ukg contains ${ e.name.contains('UKG')} isUKGAvailable $isUKGAvailable');
  //
  //        if(isLKGAvailable == true){
  //          preferences.setBool('isLKGAvailable',  true);
  //          print('checking the lkg available ${preferences.getBool('isLKGAvailable',)}');
  //        }
  //
  //        if(isUKGAvailable == true){
  //          preferences.setBool('isUKGAvailable',  true);
  //          print('checking the ukg available ${preferences.getBool('isUKGAvailable',)}');
  //        }
  //        if(isKidsFoodVideoAvailable == true){
  //          preferences.setBool('isKidsFoodVideoAvailable',  true);
  //          print('checking the kids food video available ${preferences.getBool('isKidsFoodVideoAvailable',)}');
  //        }
  //      }
  //
  //      debugPrint('checking the jsonData $jsonData');
  //
  //      return response;
  //    });

      } else {
        print('Request failed with status: ${response.statusCode}');
        return errorState;
      }

    } catch (error) {
      print(' login api Error: $error');
      return errorState;

    }
  }
}

class GetUserDataApi {

  static   Future loginWithOtp({int? mobileNo, int? otp }) async {
    var errorState;

    try {


      final body = {
        'mobile': '$mobileNo',
        'otp': '$otp',
      };
      final encodedJsonBody = json.encode(body);
      final uri = Uri.parse('www.google.com', );
      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      final response = await http.post(uri, headers: headers, body: encodedJsonBody);

      errorState = response;

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        userData = UserModel.fromJson(jsonData);

        SharedPreferences preferences = await sharedPref();
        preferences.setInt('mobileNo', mobileNo!);
        preferences.setString('token', userData!.data.token);



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
}

// class LoginApi {
//   static Future<bool> loginWithEmailAnfPassword(
//       {String? email, String? password}) async {
//     try {
//       final models.Session response = await account.createEmailSession(
//         email: email!,
//         password: password!,
//       );
//
//       print('checking the response ${response}');
//       return true;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   static bool signUpWithEmailAndPassword({String? email, String? password}) {
//     try {
//       var response = account.create(
//         name: 'Test user',
//         email: email!,
//         password: password!,
//         userId: ID.unique(),
//       );
//
//       print(
//           'checking the response ${response.then((value) => print('status ${value.status}'))}');
//       return true;
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
