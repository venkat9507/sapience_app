import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
const String apiUrl = 'https://www.sapiencepublications.co.in/api';
class FoodDaysApi {
  static Future getFoodDaysApi({ String? token,}) async {
    var errorState;


    try {
      final Uri url = Uri.parse(
          '$apiUrl/food-days');
      final response = await http.get(url,
          headers: {
            // 'Content-Type': 'application/json',
            // 'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });

      // debugPrint('checking the jsonData ${json.decode(response.body)}');
      errorState = response;

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);


        debugPrint('checking the jsonData section ID video CatID $jsonData');

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