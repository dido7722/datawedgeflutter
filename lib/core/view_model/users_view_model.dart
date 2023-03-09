import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../services/firebase_services.dart';
import '../model/user_model.dart';
  import 'package:http/http.dart' as http;

class UsersViewModel extends GetxController {
  RxBool get loading => _loading;
  RxBool _loading = false.obs;
  RxList<UserModel> get usersList => _usersList;
  RxList<UserModel> _usersList = <UserModel>[].obs;
  RxString find = ''.obs;
  RxString vrServer = ''.obs;

  @override
  void onInit() {
    _usersList.bindStream(usersStream());
    Future ssss()=> getVersionServerFirebase(); //stream coming from firebase
    ssss();
    super.onInit();
  }
  getVersionServerFirebase() async {
    QuerySnapshot querySnapshot;
    querySnapshot = await FirebaseFirestore.instance
        .collection('settings')
        .get();
    if (!querySnapshot.docs.length.isEqual(0)) {
      vrServer.value=querySnapshot.docs.where((element) => element.id=='vrServer').first.get('vrServer').toString();
    }
  }
  Stream<RxList<UserModel>> usersStream() {
    _loading.value = true;
    return FirebaseServices()
        .userRef
        .orderBy('enabled', descending: true)
        .orderBy('id')
        .snapshots()
        .map((QuerySnapshot query) {
      RxList<UserModel> retVal = <UserModel>[].obs;
      query.docs.forEach((element) {
        retVal.add(UserModel.fromSnapshot(element));
      });
      _loading.value = false;
      return retVal;
    });
  }

// Future<List<dynamic>> loadUsers() async {
  //   list=[];
  //   for (var i = 1; i < 100; i++) {
  //     var url = 'https://jfaab.se//wp-json/wc/v3/customers/?per_page=10&page=$i';
  //     var headers = {
  //       'Authorization': 'Basic Y2tfZDcyNjA2YzE2NjFkODhlMjcwNWFlZjQ1MDhkOWFlYjEwYTY3MDBiOTpjc19lMTYzZGE1NTAwZDFmNGRkOTA0N2I0N2NjNWMyMzYwNDQzMTI2ZWQz',
  //     };
  //
  //     var response = await http.get(Uri.parse(url), headers: headers);
  //     List listUsersWebsite=List.from(json.decode(response.body));
  //     list.addAll(listUsersWebsite);
  //     if(listUsersWebsite.isEmpty){
  //       break;
  //     }
  //   }
  //   return list;
  // }

}
