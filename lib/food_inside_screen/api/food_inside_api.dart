import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
const String apiUrl = 'https://www.sapiencepublications.co.in/api';
class FoodInsideApi {
  static Future getFoodInsideVideosApi({ String? token,
    int? sectionID,
    int? foodDayID,
    int? foodCatID ,
    int? foodTypeID ,
  }) async {
    var errorState;

    debugPrint(' food inside screen check the token $token '
        'food inside   API sectionID : ${sectionID} foodCat : ${foodCatID} foodType : ${foodTypeID} foodDay : ${foodDayID}');

    try {
      final Uri url = Uri.parse(

          '$apiUrl/food-videos?section_id=$sectionID&food_category_id=$foodCatID&food_type_id=$foodTypeID&food_day_id=$foodDayID');
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


        debugPrint('checking the fi jsonData section ID video CatID $jsonData');

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