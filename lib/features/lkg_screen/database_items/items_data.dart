import 'package:flutter/material.dart';

import '../../video_categories/model/video_category_model.dart';
import '../models/lkg_models.dart';

// List<LkgModel>? lkgDataItems = <LkgModel>[];
VideoCategoryModel? lkgCategoryModel;
class GroceryData{
  static List<Map<String, dynamic>> lkgProducts = [
    {
      'id': '1',
      'title': 'lkg-1',
      'borderColor': 'Colors.blue',
      'thumbNail': 'https://cdn.pixabay.com/photo/2014/02/27/16/10/flowers-276014_1280.jpg',
      'isSelected': false,
    },
    {
      'id': '2',
      'title': 'lkg-2',
      'borderColor': 'Colors.blue',
      'thumbNail': 'https://cdn.pixabay.com/photo/2017/05/09/03/46/alberta-2297204_1280.jpg',
      'isSelected': false,
    },
    {
      'id': '3',
      'title': 'lkg-3',
      'borderColor': 'Colors.blue',
      'thumbNail': 'https://cdn.pixabay.com/photo/2018/09/23/18/30/drop-3698073_1280.jpg',
      'isSelected': false,
    },
    {
      'id': '4',
      'title': 'lkg-4',
      'borderColor': 'Colors.blue',
      'thumbNail': 'https://cdn.pixabay.com/photo/2015/06/19/20/13/sunset-815270_1280.jpg',
      'isSelected': false,
    },
    {
      'id': '5',
      'title': 'lkg-5',
      'borderColor': 'Colors.blue',
      'thumbNail': 'https://cdn.pixabay.com/photo/2016/04/20/19/47/wolves-1341881_1280.jpg',
      'isSelected': false,
    },
    {
      'id': '6',
      'title': 'lkg-6',
      'borderColor': 'Colors.blue',
      'thumbNail': 'https://cdn.pixabay.com/photo/2018/08/12/16/59/parrot-3601194_1280.jpg',
      'isSelected': false,
    },
    {
      'id': '7',
      'title': 'lkg-7',
      'borderColor': 'Colors.blue',
      'thumbNail': 'https://cdn.pixabay.com/photo/2017/01/14/12/59/iceland-1979445_1280.jpg',
      'isSelected': false,
    },
    {
      'id': '8',
      'title': 'lkg-8',
      'borderColor': 'Colors.blue',
      'thumbNail': 'https://cdn.pixabay.com/photo/2016/11/08/05/26/woman-1807533_1280.jpg',
      'isSelected': false,
    },
    {
      'id': '9',
      'title': 'lkg-9',
      'borderColor': 'Colors.blue',
      'thumbNail': 'https://cdn.pixabay.com/photo/2016/11/08/05/20/sunset-1807524_1280.jpg',
      'isSelected': false,
    },
    {
      'id': '10',
      'title': 'lkg-10',
      'borderColor': 'Colors.blue',
      'thumbNail': 'https://cdn.pixabay.com/photo/2017/05/31/18/38/sea-2361247_1280.jpg',
      'isSelected': false,
    },
    {
      'id': '11',
      'title': 'lkg-11',
      'borderColor': 'Colors.blue',
      'thumbNail': 'https://cdn.pixabay.com/photo/2014/08/29/03/02/horses-430441_1280.jpg',
      'isSelected': false,
    },
    {
      'id': '12',
      'title': 'lkg-12',
      'borderColor': 'Colors.blue',
      'thumbNail': 'https://cdn.pixabay.com/photo/2020/02/15/16/09/loveourplanet-4851331_1280.jpg',
      'isSelected': false,
    },
    {
      'id': '13',
      'title': 'lkg-13',
      'borderColor': 'Colors.blue',
      'thumbNail': 'https://cdn.pixabay.com/photo/2018/12/15/02/53/flowers-3876195_1280.jpg',
      'isSelected': false,
    },
    {
      'id': '14',
      'title': 'lkg-14',
      'borderColor': 'Colors.blue',
      'thumbNail': 'https://cdn.pixabay.com/photo/2015/04/10/01/41/fox-715588_1280.jpg',
      'isSelected': false,
    },
    {
      'id': '15',
      'title': 'lkg-15',
      'borderColor': 'Colors.blue',
      'thumbNail': 'https://cdn.pixabay.com/photo/2017/07/24/19/57/tiger-2535888_1280.jpg',
      'isSelected': false,
    },
    {
      'id': '16',
      'title': 'lkg-16',
      'borderColor': 'Colors.blue',
      'thumbNail': 'https://cdn.pixabay.com/photo/2017/07/24/19/57/tiger-2535888_1280.jpg',
      'isSelected': false,
    },
  ];
}