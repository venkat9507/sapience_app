import 'package:flutter/material.dart';

import '../models/subscribe_models.dart';

List<SubscribeDatum>? subscribeDataItems = <SubscribeDatum>[];

SubscriptionPlanModel? subscriptionPlanModel;

class SubscribeData{
  static List<Map<String, dynamic>> subscribeList = [
    {
      'id': '1',
      'title': '90 Days Subscription',
      'price': '290',
      'borderColor': 'Colors.blue',
      'isSelected': false,
    },
    {
      'id': '2',
      'title': '180 Days Subscription',
      'price': '490',
      'borderColor': 'Colors.blue',
      'isSelected': false,
    },
    {
      'id': '3',
      'title': '270 Days Subscription',
      'price': '590',
      'borderColor': 'Colors.blue',
      'isSelected': false,
    },
    {
      'id': '4',
      'title': '360 Days Subscription',
      'price': '690',
      'borderColor': 'Colors.blue',
      'isSelected': false,
    },

  ];
}