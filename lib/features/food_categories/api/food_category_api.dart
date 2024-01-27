// import 'package:appwrite/appwrite.dart';
// import 'package:appwrite/models.dart' as models;
//
// import '../../../data/appwrite_client.dart';
//
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String apiUrl = 'https://www.sapiencepublications.co.in/api';

class FoodCategoryApi {
  static Future getFoodCategoriesSectionID({ String? token,int? sectionID}) async {
    print('checking the food category section ID $sectionID Token $token');
    var errorState;


    try {
      final Uri url = Uri.parse(
          '$apiUrl/food-categories?section_id=$sectionID');
      final response = await http.get(url,
          headers: {
            // 'Content-Type': 'application/json',
            // 'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });

      debugPrint('checking the food video category  jsonData ${json.decode(response.body)}');
      errorState = response;

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);


        debugPrint('checking the food video category after the response.statusCode == 200 jsonData $jsonData');

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