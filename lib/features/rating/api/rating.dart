import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
const String apiUrl = 'https://www.sapiencepublications.co.in/api';
class RatingApi {
  static Future updateRatingApi({ String? token,double? rating,int? videoID}) async {
    var errorState;
    debugPrint('checking the rating   $rating videoID $videoID');


    try {
      final Uri url = Uri.parse(
          '$apiUrl/video-rating?video_id=$videoID&rating=$rating');
      final response = await http.post(url,
          headers: {
            // 'Content-Type': 'application/json',
            // 'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });

      // debugPrint('checking the rating status code ${response.statusCode}');
      errorState = response;

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);


        debugPrint('checking the jsonData rating $jsonData');

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