
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



class LocalFoodUKGCategoryDatabase {
  LocalFoodUKGCategoryDatabase._privateConstructor();
  static final  LocalFoodUKGCategoryDatabase instance = LocalFoodUKGCategoryDatabase._privateConstructor();
  final db = Localstore.instance;


  createFoodUKGCategory(FoodCategoryModel foodCategoryModel) async {
    // gets new id
    // deleteUKG();

    String id = db.collection('FoodUKGCategory').doc().id;
    print('creating the FoodUKGCategory category with id $id');
    SharedPreferences preferences = await sharedPref();
    preferences.setString('FoodUKGCategory_ID', id);

// save the item
    return await  db.collection('FoodUKGCategory').doc(id).set({
      'FoodUKGCategory': foodCategoryModel,
    }).then((value) => getFoodUKGCategory());
  }

  deleteFoodUKGCategory() async {
    SharedPreferences preferences = await sharedPref();

    String? id = preferences.getString('FoodUKGCategory_ID',);
    print('deleting  the FoodUKGCategory category with id $id');
    return await db.collection('FoodUKGCategory').doc(id).delete();

  }


  getFoodUKGCategory() async {
    return await db.collection('FoodUKGCategory').get().then((value) {
      value!.forEach((key, value) {
        foodUkgCategoryModel = FoodCategoryModel.fromJson(value['FoodUKGCategory']);
        print('items from the collection get ukg data ${foodUkgCategoryModel!.message}');
      });
    });

  }

}