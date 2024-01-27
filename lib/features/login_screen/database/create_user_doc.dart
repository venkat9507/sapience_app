// import 'package:appwrite/appwrite.dart';
// import 'package:appwrite/models.dart';
// import 'package:flutter/material.dart';
// import '../../../data/appwrite_client.dart';
//
// class CreateUserDocument {
//   static Future<bool> createUserDoc(
//       {String? userName, String? userEmail}) async {
//     try {
//       Document result = await databases.createDocument(
//         databaseId: "6455463a33a53e047345",
//         collectionId: "645546614af62d32b799",
//         documentId: ID.unique(),
//         data: {
//           "user-name": userName,
//           "user-email": userEmail,
//           // "Created-at": DateTime.now().toIso8601String(),
//         },
//       );
//       return true;
//     } catch (e) {
//       print('getting databse error $e');
//       rethrow;
//     }
//   }
// }


import 'package:nimu_tv/features/login_screen/models/user_model.dart';

import '../models/login_model.dart';
import '../models/qrModel.dart';

var mobileNo;
var storingQrCode;



List<SapienceParentModel> sapienceParentsModelList = <SapienceParentModel>[];

UserModel? userData ;
QrModel? qrModel ;

class SapienceParentsData{
  static List<Map<String, dynamic>> parentList = [
    {
      'index': 0,
      'title': 'YES',
      'isSelected': false,
    },
    {
      'index': 1,
      'title': 'NO',
      'isSelected': true,
    },

  ];
}
