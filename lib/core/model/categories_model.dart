// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class CategoriesModel {
//    CategoriesModel({required this.id,});
//
//   String id='';
//   List<dynamic> name = [];
//   List<dynamic> desc = [];
//   int no=0, parent=0, sort=0;
//    bool enable=false;
//
//
//    @override
//   String toString() {
//     return name[1].toString();
//   }
//
//    CategoriesModel.fromSnapshot(DocumentSnapshot snapshot) {
//     id = snapshot.get('id') ?? '';
//     name = snapshot.get('name') ?? '';
//     no = snapshot.get('no') ?? 0;
//     parent = snapshot.get('parent') ?? 0;
//     sort = snapshot.get('sort') ?? 0;
//     enable = snapshot.get('enable') ?? true;
//     desc=snapshot.get('desc') ?? '';
//   }
// }
