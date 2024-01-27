
import 'dart:convert';

import 'package:localstore/localstore.dart';
import 'package:nimu_tv/features/dashboard_screen/database_items/items_data.dart';
import 'package:nimu_tv/features/login_screen/database/create_user_doc.dart';
import 'package:nimu_tv/features/video_categories/data/items_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/shared_preference.dart';
import '../../video_categories/model/video_category_model.dart';
import 'items_data.dart';



class LocalLKGDatabase {
  LocalLKGDatabase._privateConstructor();
  static final  LocalLKGDatabase instance = LocalLKGDatabase._privateConstructor();
  final db = Localstore.instance;


  createLKG(VideoCategoryModel videoCategoryModel) async {
    // gets new id
   // await deleteLKG();

    String id = db.collection('LKG').doc().id;
    print('creating the lkg category with id $id');
    SharedPreferences preferences = await sharedPref();
    preferences.setString('LKG_ID', id);

// save the item
    return await db.collection('LKG').doc(id).set({
      'LKG': videoCategoryModel,
    }).then((value) => getLKG());
  }

 Future deleteLKG() async {
    SharedPreferences preferences = await sharedPref();

  return  await  db.collection('LKG').delete();

    // String? id = preferences.getString('LKG_ID',);
    // print('deleting  the lkg category with id $id');
    // await db.collection('LKG').doc(id).delete();

  }


  getLKG() async {

    return await db.collection('LKG').get().then((value) {
      print('getting the lkg types check value ${ value}');

      value!.forEach((key, value) {
           lkgCategoryModel = VideoCategoryModel.fromJson(value['LKG']);
           print('items from the collection get lkg data ${lkgCategoryModel!.message}');
         });
    });

  }

}