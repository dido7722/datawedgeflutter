import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../services/firebase_services.dart';
import '../model/product_model.dart';
import 'package:http/http.dart' as http;

class ProductsViewModel extends GetxController {

  RxBool get loading => _loading;
  final RxBool _loading = false.obs;

  RxList<ProductModel> get productsList => _productsList;
  final RxList<ProductModel> _productsList = <ProductModel>[].obs;

  RxList<ProductModel> get filterProductsList => _filterProductsList;
  RxList<ProductModel> _filterProductsList = <ProductModel>[].obs;
  RxList<ProductModel> productsLocal = <ProductModel>[].obs;

  RxString find = ''.obs;
  RxString findInEditPage = ''.obs;
  String _strSearch = '';
  String keyValue = '';

  set strSearch(String value) {
    _strSearch = value;
  }


  @override
  Future<void> onInit() async {
    _loading.value=true;
    Future loadProductsFuture() => getProducts();
    await  loadProductsFuture().whenComplete((){
      _loading.value=false;
    });

    super.onInit();
  }
  List list=[];

  // Future<List<dynamic>> loadProducts() async                                                                                                                                                                                                                                                                                                                                {
  //   list=[];var rrr;
  //   for (var i = 1; i < 100; i++) {
  //     var url = 'https://jfaab.se/wp-json/wc/v3/products?per_page=95&page=$i';
  //     var headers = {
  //       'Authorization': 'Basic Y2tfZDcyNjA2YzE2NjFkODhlMjcwNWFlZjQ1MDhkOWFlYjEwYTY3MDBiOTpjc19lMTYzZGE1NTAwZDFmNGRkOTA0N2I0N2NjNWMyMzYwNDQzMTI2ZWQz',
  //     };
  //
  //     var response = await http.get(Uri.parse(url), headers: headers);
  //      list +=List.from(json.decode(response.body));
  //     // List listProductsWebsite=List.from(json.decode(response.body));
  //     // list.addAll(listProductsWebsite);
  //     // if(listProductsWebsite.isEmpty){
  //     //   break;
  //     // }
  //     if(response.body.length<4){
  //       // List listProductsWebsite=List.from(rrr);
  //       // list.addAll(listProductsWebsite);
  //       break;
  //     }
  //     print(list.length);
  //   }
  //   return list;
  // }


  getProducts() async {
    _productsList.clear();
    _loading.value = true;
    QuerySnapshot querySnapshot;
    querySnapshot = await FirebaseFirestore.instance
        .collection('proct')
        .orderBy('sort')
        .get();
    for (var element in querySnapshot.docs) {
      _productsList.add(ProductModel.fromSnapshot(element));
    }

    update();
    // _productsList.bindStream(productsStream()); //stream coming from firebase
    find.value='';
    findInEditPage.value='';

    _loading.value = false;
  }

  filterProducts() async {
    loading.value = true;

    filterProductsList.clear();





    for (var p1 in productsList) {
      var s=_strSearch.toLowerCase().split(' ').length;
      switch (s){
        case 1:
          if (p1.toString().toLowerCase().contains(_strSearch.split(' ')[0].toLowerCase()))
          {
            filterProductsList.add(p1);
          }
          // results.addAll( list.where((element) => element.toLowerCase().contains(search.split(' ')[0].toLowerCase())));
          break;
        case 2:
          if (p1.toString().toLowerCase().contains(_strSearch.split(' ')[0].toLowerCase()) &&
              p1.toString().toLowerCase().contains(_strSearch.split(' ')[1].toLowerCase()))
          {
            filterProductsList.add(p1);
          }
          break;
        case 3:
          if (p1.toString().toLowerCase().contains(_strSearch.split(' ')[0].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[1].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[2].toLowerCase())
          )
          {
            filterProductsList.add(p1);
          }
          break;
        case 4:
          if (p1.toString().toLowerCase().contains(_strSearch.split(' ')[0].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[1].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[2].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[3].toLowerCase())
          )
          {
            filterProductsList.add(p1);
          }
          break;
        case 5:
          if (p1.toString().toLowerCase().contains(_strSearch.split(' ')[0].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[1].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[2].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[3].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[4].toLowerCase())
          )
          {
            filterProductsList.add(p1);
          }
          break;
        case 6:
          if (p1.toString().toLowerCase().contains(_strSearch.split(' ')[0].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[1].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[2].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[3].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[4].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[5].toLowerCase())
          )
          {
            filterProductsList.add(p1);
          }
          break;
        case 7:
          if (p1.toString().toLowerCase().contains(_strSearch.split(' ')[0].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[1].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[2].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[3].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[4].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[5].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[6].toLowerCase())
          )
          {
            filterProductsList.add(p1);
          }
          break;
        case 8:
          if (p1.toString().toLowerCase().contains(_strSearch.split(' ')[0].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[1].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[2].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[3].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[4].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[5].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[6].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[7].toLowerCase())
          )
          {
            filterProductsList.add(p1);
          }
          break;
        case 9:
          if (p1.toString().toLowerCase().contains(_strSearch.split(' ')[0].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[1].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[2].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[3].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[4].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[5].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[6].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[7].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[8].toLowerCase())
          )
          {
            filterProductsList.add(p1);
          }
          break;
        case 10:
          if (p1.toString().toLowerCase().contains(_strSearch.split(' ')[0].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[1].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[2].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[3].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[4].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[5].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[6].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[7].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[8].toLowerCase())
              && p1.toString().toLowerCase().contains(_strSearch.split(' ')[9].toLowerCase())
          )
          {
            filterProductsList.add(p1);
          }
          break;
      }




      // if (p1.names.toString().toLowerCase().contains(strSearch.toLowerCase())
      // ||p1.brand.toString().toLowerCase().contains(strSearch.toLowerCase())
      // ||p1.size.toString().toLowerCase().contains(strSearch.toLowerCase())
      // ||p1.idAmeen.toString().toLowerCase().contains(strSearch.toLowerCase()))
      // {
      //   filterProductsList.add(p1);
      // }
    }
    update();
    loading.value = false;
  }

  // Stream<RxList<ProductModel>> productsStream() {
  //
  //   return FirebaseServices()
  //       .productRef
  //       .orderBy('sort')
  //       .snapshots()
  //       .map((QuerySnapshot query) {
  //     RxList<ProductModel> retVal = <ProductModel>[].obs;
  //     for (var element in query.docs) {
  //       retVal.add(ProductModel.fromSnapshot(element));
  //     }
  //
  //     return retVal;
  //   });
  // }

}
