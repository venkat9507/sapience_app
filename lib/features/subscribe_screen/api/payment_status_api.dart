import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubscriptionStatus {

  static   Future sendingStatusToApi({int? subscriptionId, int? amount,String? log,String? status }) async {
    var errorState;

    try {

      String? apiUrl = 'https://www.sapiencepublications.co.in/api/';


      final Uri url = Uri.parse('$apiUrl/subscription-payment?subscription_id=$subscriptionId&amount=$amount&gateway_log=$log&payment_status=$status');
      final response = await http.post(url, );

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
}