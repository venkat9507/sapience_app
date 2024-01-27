
import 'dart:convert';

import 'package:localstore/localstore.dart';
import 'package:nimu_tv/features/login_screen/database/create_user_doc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/shared_preference.dart';
import '../models/user_model.dart';

class LocalUserDatabase {
  LocalUserDatabase._privateConstructor();
  static final  LocalUserDatabase instance = LocalUserDatabase._privateConstructor();
  final db = Localstore.instance;


  createUser(UserModel userModel) async {
    // gets new id
    // deleteUser();

    String id = db.collection('userLogin').doc().id;
    print('creating the user category with id $id');
    SharedPreferences preferences = await sharedPref();
    preferences.setString('user_ID', id);

// save the item
    db.collection('userLogin').doc(id).set({
      'userMode': userModel,
    }).then((value) => getUser());
  }

  deleteUser() async {
    // print('checking the user login id ${}');
    SharedPreferences preferences = await sharedPref();
    String? id = preferences.getString('user_ID',);
    print('deleting  the user category with id $id');
    await db.collection('userLogin').doc(id).delete().then((value) => print('user login deleted successfully ${value}'));



  }


  getUser() async {
      db.collection('userLogin').get().then((value) {
         value!.forEach((key, value) {
           userData = UserModel.fromJson(value['userMode']);
           print('items from the collection get user data local database ${userData!.message}');
         });
    });

  }

}