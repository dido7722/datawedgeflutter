// import 'dart:convert';
//
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
//
// import '../model/ameen_model.dart';
// import 'products_view_model.dart';
//
// class AmeenImportViewModel extends GetxController{
//   ProductsViewModel _productsViewModel = Get.find();
//   RxString find = ''.obs;
//   RxList<AmeenProductModel> get ameenProductModel => _ameenProductModel;
//   RxList<AmeenProductModel> _ameenProductModel = <AmeenProductModel>[].obs;
//   RxBool get loading => _loading;
//   RxBool _loading = false.obs;
//   RxBool isStarted=false.obs;
//   Future<List> getProducts() async {
//     var url = 'http://eyad.hopto.org:3000/api/orders';
//
//     var response =
//     await http.get(Uri.parse(url));
//
//    var list = json.decode(response.body);
//     return list;
//
//   }
//
//
//
//   refreshProduct()async{
//     _productsViewModel.loading.value=true;
//     _ameenProductModel.clear();
//    await getProducts().then((value) {
//       value.forEach((data){
//         _ameenProductModel.add(AmeenProductModel.fromJson(data));
//       });
//       _productsViewModel.loading.value=false;
//       isStarted.value=true;
//       update();
//     },
//         onError:(error){
//           _productsViewModel.loading.value=false;
//           print(error);
//         }
//     );
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//
//   }
// }