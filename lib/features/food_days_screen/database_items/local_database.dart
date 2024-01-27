
import 'dart:convert';

import 'package:get/get.dart';
import 'package:localstore/localstore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/shared_preference.dart';
import '../models/food_days_models.dart';
import 'items_data.dart';



class LocalFoodDaysDatabase {
  LocalFoodDaysDatabase._privateConstructor();
  static final  LocalFoodDaysDatabase instance = LocalFoodDaysDatabase._privateConstructor();
  final db = Localstore.instance;


  createFoodDays(FoodDaysModel insideModel) async {
    // gets new id
    // deleteFoodDays();

    String id = db.collection('FoodDays').doc().id;
    print('creating the FoodDays  category with id $id insidemodel title ${insideModel.data[0].name} ');
    SharedPreferences preferences = await sharedPref();
    preferences.setString('FoodDays_ID', id);

// save the item
    return await db.collection('FoodDays').doc(id).set({
      'FoodDaysModel': insideModel,
      // 'title'  :  insideModel.title,
      // 'sectionID'  :  insideModel.sectionID,
      // 'catID'  :  insideModel.catID,
    }).then((value) => getFoodDays());
  }

  deleteFoodDays() async {
    SharedPreferences preferences = await sharedPref();

    return await db.collection('FoodDays').delete();

    // String? id = preferences.getString('FoodDays_ID',);
    // print('deleting  the FoodDays Inside category with id $id');
    // await db.collection('FoodDays').doc(id).delete();
    // await db.collection('FoodDays').doc().delete();

  }


  getFoodDays() async {
    return await db.collection('FoodDays').get().then((value) {
         value!.forEach((key, value) {
           print('getting the food Days  inside from the database ${value['FoodDaysModel']}');
       foodDaysModel =     FoodDaysModel.fromJson(
             value['FoodDaysModel'],
             // title: value['title'],
             // sectionID: value['sectionID'],
             // catID: value['catID'],
           );

           // Get.snackbar(
           //   'get food days screen length ${foodDaysModel?.data.length}',
           //   "Display the message here",
           //   // colorText: Colors.white,
           //   // backgroundColor: Colors.lightBlue,
           //   // icon: const Icon(Icons.add_alert),
           // );
           print('items from the collection get food Days inside the  data ${foodDaysModel?.data.length} ');
         });
    });

  }

}