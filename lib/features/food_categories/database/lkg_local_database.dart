
import 'dart:convert';

import 'package:localstore/localstore.dart';
import 'package:nimu_tv/features/dashboard_screen/database_items/items_data.dart';
import 'package:nimu_tv/features/food_categories/database/item_data.dart';
import 'package:nimu_tv/features/login_screen/database/create_user_doc.dart';
import 'package:nimu_tv/features/video_categories/data/items_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/shared_preference.dart';
import '../../video_categories/model/video_category_model.dart';
import '../models/food_category_models.dart';



class LocalFoodLKGCategoryDatabase {
  LocalFoodLKGCategoryDatabase._privateConstructor();
  static final  LocalFoodLKGCategoryDatabase instance = LocalFoodLKGCategoryDatabase._privateConstructor();
  final db = Localstore.instance;


  createFoodLKGCategory(FoodCategoryModel foodCategoryModel) async {
    // gets new id
    // await deleteFoodLKGCategory();

    String id = db.collection('FoodLKGCategory').doc().id;
    print('creating the FoodLKGCategory category with id $id');
    SharedPreferences preferences = await sharedPref();
    preferences.setString('FoodLKGCategory_ID', id);

// save the item
    return await  db.collection('FoodLKGCategory').doc(id).set({
      'FoodLKGCategory': foodCategoryModel,
    }).then((value) => getFoodLKGCategory());
  }

 Future deleteFoodLKGCategory() async {
    SharedPreferences preferences = await sharedPref();
    return await db.collection('FoodLKGCategory').delete();

    // String? id = preferences.getString('FoodLKGCategory_ID',);
    // print('deleting  the FoodLKGCategory category with id $id');
    // await db.collection('FoodLKGCategory').doc(id).delete();

  }


  getFoodLKGCategory() async {
    return await  db.collection('FoodLKGCategory').get().then((value) {
         value!.forEach((key, value) {
           foodLkgCategoryModel = FoodCategoryModel.fromJson(value['FoodLKGCategory']);
           print('items from the collection get food lkg data ${foodLkgCategoryModel!.message}');
         });
    });

  }

}