
import 'dart:convert';

import 'package:localstore/localstore.dart';
import 'package:nimu_tv/features/dashboard_screen/database_items/items_data.dart';
import 'package:nimu_tv/features/login_screen/database/create_user_doc.dart';
import 'package:nimu_tv/features/video_categories/data/items_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/shared_preference.dart';
import '../../video_categories/model/video_category_model.dart';
import 'items_data.dart';



class LocalUKGDatabase {
  LocalUKGDatabase._privateConstructor();
  static final  LocalUKGDatabase instance = LocalUKGDatabase._privateConstructor();
  final db = Localstore.instance;


  createUKG(VideoCategoryModel videoCategoryModel) async {
    // gets new id
    // deleteUKG();

    String id = db.collection('UKG').doc().id;
    print('creating the ukg category with id $id');
    SharedPreferences preferences = await sharedPref();
    preferences.setString('UKG_ID', id);

// save the item
    return await db.collection('UKG').doc(id).set({
      'UKG': videoCategoryModel,
    }).then((value) => getUKG());
  }

  deleteUKG() async {
    SharedPreferences preferences = await sharedPref();

    String? id = preferences.getString('UKG_ID',);
    print('deleting  the ukg category with id $id');
    return await db.collection('UKG').doc(id).delete();

  }


  getUKG() async {
    return await db.collection('UKG').get().then((value) {
         value!.forEach((key, value) {
           ukgCategoryModel = VideoCategoryModel.fromJson(value['UKG']);
           print('items from the collection get ukg data ${ukgCategoryModel!.message}');
         });
    });

  }

}