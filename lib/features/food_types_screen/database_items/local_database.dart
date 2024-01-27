
import 'dart:convert';

import 'package:localstore/localstore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/shared_preference.dart';
import '../models/food_types_models.dart';
import 'items_data.dart';



class LocalFoodTypesDatabase {
  LocalFoodTypesDatabase._privateConstructor();
  static final  LocalFoodTypesDatabase instance = LocalFoodTypesDatabase._privateConstructor();
  final db = Localstore.instance;


  createFoodTypes(FoodTypesModel insideModel) async {
    // gets new id
    // deleteFoodTypes();

    String id = db.collection('FT').doc().id;
    print('creating the ft  category with id $id insidemodel title ${insideModel.data[0].name} ');
    SharedPreferences preferences = await sharedPref();
    preferences.setString('ft_ID', id);

// save the item
    return await  db.collection('FT').doc(id).set({
      'FT': insideModel,
    }).then((value) => getFoodTypes());
  }

  deleteFoodTypes() async {
    SharedPreferences preferences = await sharedPref();

    return await db.collection('FT').delete();
    print('deleting the ft');

    // String? id = preferences.getString('FoodTypes_ID',);
    // print('deleting  the FoodTypes Inside category with id $id');
    // await db.collection('FoodTypes').doc(id).delete();
    // await db.collection('FoodTypes').doc().delete();

  }


  getFoodTypes() async {

try{


 return await db.collection('FT').get().then((value) {
    print('getting the food types ftc check value ${ value}');

    value!.forEach((key, value) {
      print('getting the food types ft inside from the database ${value['FT']}');
      foodTypesModel =     FoodTypesModel.fromJson(
        value['FT'],
      );
      print('items from the collection get food types inside the  data ${foodTypesModel?.data.length}');
    });
  });
} catch (e,s){
  print('catching the error in ft error $e stack trace $s');
}

  }

}