
import 'dart:convert';

import 'package:localstore/localstore.dart';
import 'package:nimu_tv/features/dashboard_screen/database_items/items_data.dart';
import 'package:nimu_tv/features/login_screen/database/create_user_doc.dart';
import 'package:nimu_tv/features/video_categories/data/items_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/shared_preference.dart';

import '../models/food_inside_models.dart';
import 'items_data.dart';



class LocalFoodInsideDatabase {
  LocalFoodInsideDatabase._privateConstructor();
  static final  LocalFoodInsideDatabase instance = LocalFoodInsideDatabase._privateConstructor();
  final db = Localstore.instance;


  createFoodInside(FoodInsideModel insideModel) async {
    // gets new id
    // deleteFoodInside();


    String id = db.collection('FoodInside').doc().id;
    print('creating the Food inside category with id $id insidemodel title ${insideModel.title} check the cat id ${insideModel.foodCatID}');
    SharedPreferences preferences = await sharedPref();
    preferences.setString('FoodInside_ID', id);

// save the item
    return await db.collection('FoodInside').doc(id).set({
      'FoodInside': insideModel,
      'title'  :  insideModel.title,
      'sectionID'  :  insideModel.sectionID,
      'foodCatID'  :  insideModel.foodCatID,
      'foodDayID'  :  insideModel.foodDayID,
      'foodTypeID'  :  insideModel.foodTypeID,
    }).then((value) =>  getFoodInside());
  }

  deleteFoodInside() async {
    SharedPreferences preferences = await sharedPref();

   return await db.collection('FoodInside').delete();

    // String? id = preferences.getString('FoodInside_ID',);
    // print('deleting  the Food Inside category with id $id');
    // await db.collection('FoodInside').doc(id).delete();
    // await db.collection('FoodInside').doc().delete();

  }


  getFoodInside() async {
    return await db.collection('FoodInside').get().then((value) {
         value!.forEach((key, value) {
           print('getting the Food inside from the database ${value['foodCatID']}');
           foodInsideModelList!.add(
               FoodInsideModel.fromJson(
                 value['FoodInside'],
                 title: value['title'],
                 sectionID: value['sectionID'],
                 foodCatID: value['foodCatID'],
                 foodDayID: value['foodDayID'],
                 foodTypeID: value['foodTypeID'],
               )
           );

         });
         print('items from the collection get foodInsideModelList data ${foodInsideModelList!.length}');
    });

  }

}