//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
//
// import 'package:get/get.dart';
//
// import '../../services/firebase_services.dart';
// import '../model/categories_model.dart';
//
// class CategoriesViewModel extends GetxController {
//   static CategoriesViewModel instance = Get.find();
//
//   ValueNotifier<bool> get loading => _loading;
//   ValueNotifier<bool> _loading = ValueNotifier<bool>(false);
//
//   RxList<CategoriesModel> get categoriesList => _categoriesList;
//   RxList<CategoriesModel> _categoriesList = <CategoriesModel>[].obs;
//
//   RxString find=''.obs;
//
//
//
//   void onInit() {
//     _categoriesList.bindStream(categoriesStream()); //stream coming from firebase
//     super.onInit();
//   }
//
//   Stream<RxList<CategoriesModel>> categoriesStream() {
//     // _loading.value = true;
//
//     return  FirebaseServices()
//         .categoryRef
//         .snapshots()
//         .map((QuerySnapshot query) {
//       RxList<CategoriesModel> retVal = <CategoriesModel>[].obs;
//       query.docs.forEach((element) {
//         retVal.add(CategoriesModel.fromSnapshot(element));
//       });
//
//
//       return retVal;
//     });
//   }
//
//
// }
