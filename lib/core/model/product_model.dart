
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProductModel {
  String id = '', source = '', image = '',idAmeen='',categoryName='';
  var specialPrice = 0.0.obs,
      sort = 0.obs;
  var  categoryID = 0.obs;
  bool enabled = true, isSpecial = true, isGood = true, isNew = true;
  RxBool isPrint=false.obs;
  List<dynamic> names = [];
  List<dynamic> descs = [];
  List<dynamic> size = [];
  RxList prices = [].obs;
  List<dynamic> brand = [];
  String dateImage='';
  var qty = 1.obs;
  RxInt realQty=0.obs;
  int vat=12;
  RxBool finishPicked=false.obs;
  RxString commentQty=''.obs;
  RxInt pallNr=1.obs;
  RxBool needUpdatePrice=false.obs;
  RxString barcode1=''.obs,barcode2=''.obs,barcode3=''.obs;
  double countQty=0.0;


  ProductModel({
    required this.id,
    required this.names,
    required this.descs,
    required this.size,
    required this.brand,
    required this.source,
    required this.categoryID,
    required this.image,
    required this.specialPrice,
    required this.sort,
    required this.enabled,
    required this.isSpecial,
    required this.isGood,
    required this.isNew,
    required this.prices,
    required this.idAmeen,
    required this.dateImage,
    required this.qty ,
    required this.vat,
    required this.barcode1,
    required this.barcode2,
    required this.barcode3,
    required this.countQty,

  });
  ProductModel.fromSnapshot(
      DocumentSnapshot snapshot) {
    id = snapshot.get('id') ?? '';
    idAmeen = snapshot.get('idAmeen') ?? '';
    names = snapshot.get('name') ?? '';
    dateImage = snapshot.get('date_img') ?? '';
    descs = snapshot.get('desc') ?? '';
    brand = snapshot.get('brand') ?? '';
    size = snapshot.get('size') ?? '';
    prices.value = snapshot.get('prices') ?? 0;
    source = snapshot.get('source') ?? '';
    categoryID.value = snapshot.get('categoryID') ?? 0.obs;
    image = snapshot.get('image') ?? '';
    specialPrice.value = double.parse(snapshot.get('specialPrice').toString());
    enabled = snapshot.get("enabled");
    isSpecial = snapshot.get("isSpecial");
    isGood = snapshot.get("isGood");
    isNew = snapshot.get("isNew");
    sort.value = snapshot.get("sort") ?? 0;
    vat = snapshot.get("vat") ?? 12;
    barcode1.value=snapshot.get('barcode1');
    barcode2.value=snapshot.get('barcode2');
    barcode3.value=snapshot.get('barcode3');
    countQty=double.parse(snapshot.get('countQty').toString());

  }

  ProductModel.fromSnapshotOrder(
      Map<String, dynamic> snapshot) {
    id = snapshot['id'] ?? '';
    idAmeen = snapshot['idAmeen'] ?? '';
    names = snapshot['names'] ;
    dateImage = snapshot['date_img'] ?? '';
    descs = snapshot['desc'] ?? '';
    vat = snapshot['vat'] ?? 12;
    brand = snapshot['brand'] ?? '';
    size = snapshot['size'] ?? '';
    prices.value = snapshot['prices'] ?? 0;
    source = snapshot['source'] ?? '';
    categoryID.value = snapshot['categoryID'] ?? 0.obs;
    image = snapshot['image'] ?? '';
    specialPrice.value = double.parse(snapshot['specialPrice'].toString());
    enabled = snapshot["enabled"];
    isSpecial = snapshot["isSpecial"];
    isGood = snapshot["isGood"];
    isNew = snapshot["isNew"];
    sort.value = snapshot["sort"] ?? 0;
    qty.value = snapshot["qty"] ?? 0;
      if(snapshot.containsKey('commentQty')){
        commentQty.value=snapshot['commentQty']??'';
      }
      if(snapshot.containsKey('realQty')){
        commentQty.value=snapshot['realQty']??0;
      }

    if(snapshot.containsKey('finishPicked')){
        finishPicked.value=snapshot['finishPicked']??false;
      }
    if(snapshot.containsKey('pallNr')){
        pallNr.value=snapshot['pallNr']??1;
      }
    if(snapshot.containsKey('barcode1')){
      barcode1.value=snapshot['barcode1'];
    }
    if(snapshot.containsKey('barcode2')){
      barcode2.value=snapshot['barcode2'];
    }
    if(snapshot.containsKey('barcode3')){
      barcode3.value=snapshot['barcode3'];
    }
    if(snapshot.containsKey('countQty')){
      countQty=double.parse(snapshot['countQty'].toString());
    }


  }

  ProductModel.fromSnapshotOrder2(
      Map<String, dynamic> snapshot) {
    id = snapshot['id'] ?? '';
    idAmeen = snapshot['idAmeen'] ?? '';
    names = snapshot['name'] ;
    dateImage = snapshot['date_img'] ?? '';
    descs = snapshot['desc'] ?? '';
    vat = snapshot['vat'] ?? 12;
    brand = snapshot['brand'] ?? '';
    size = snapshot['size'] ?? '';
    prices.value = snapshot['prices'] ?? 0;
    source = snapshot['source'] ?? '';
    categoryID.value = snapshot['categoryID'] ?? 0.obs;
    image = snapshot['image'] ?? '';
    specialPrice.value = double.parse(snapshot['specialPrice'].toString());
    enabled = snapshot["enabled"];
    isSpecial = snapshot["isSpecial"];
    isGood = snapshot["isGood"];
    isNew = snapshot["isNew"];
    sort.value = snapshot["sort"] ?? 0;
    qty.value = snapshot["qty"] ?? 0;
      if(snapshot.containsKey('commentQty')){
        commentQty.value=snapshot['commentQty']??'';
      }
      if(snapshot.containsKey('realQty')){
        commentQty.value=snapshot['realQty']??0;
      }

    if(snapshot.containsKey('finishPicked')){
        finishPicked.value=snapshot['finishPicked']??false;
      }
    if(snapshot.containsKey('pallNr')){
        pallNr.value=snapshot['pallNr']??1;
      }
    barcode1.value=snapshot['barcode1'];
    barcode2.value=snapshot['barcode2'];
    barcode3.value=snapshot['barcode3'];
    countQty=double.parse(snapshot['countQty'].toString());

  }

  static Map<String, dynamic> toMap(ProductModel product) => {
    'id': product.id,
    'idAmeen':product.idAmeen,
    'name':product. names,
    'desc': product.descs,
    'brand':product. brand,
    'size':product. size,
    'source': product.source,
    'categoryID':product. categoryID.value,
    'image': product.image,
    'specialPrice':product.specialPrice.value,
    "enabled":product. enabled,
    "isSpecial":product. isSpecial,
    "isGood": product.isGood,
    "isNew": product.isNew,
    "sort": product.sort.value,
    'prices': product.prices,
    'date_img':product.dateImage,
    'vat':product.vat,
    'qty':product.qty.value,
  'barcode1':product.barcode1.value,
  'barcode2':product.barcode2.value,
  'barcode3':product.barcode3.value,
  'countQty':product.countQty,

};


  static String encode(List<ProductModel> musics) => json.encode(
    musics
        .map<Map<String, dynamic>>((music) => ProductModel.toMap(music))
        .toList(),
  );

  static List<ProductModel> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<ProductModel>((item) => ProductModel.fromSnapshotOrder2(item))
          .toList();

  ProductModel.fromList(
      Map<dynamic, dynamic> snapshot) {

    id = snapshot['id'] ?? '';
    idAmeen = snapshot['idAmeen'] ?? '';
    names = snapshot['name'] ;
    dateImage = snapshot['date_img'] ?? '';
    descs = snapshot['desc'] ?? '';
    vat = snapshot['vat'] ?? 12;
    brand = snapshot['brand'] ?? '';
    size = snapshot['size'] ?? '';
    prices.value = snapshot['prices'] ?? 0;
    source = snapshot['source'] ?? '';
    categoryID.value = snapshot['categoryID'] ?? 0.obs;
    image = snapshot['image'] ?? '';
    specialPrice.value = double.parse(snapshot['specialPrice'].toString());
    enabled = snapshot["enabled"];
    isSpecial = snapshot["isSpecial"];
    isGood = snapshot["isGood"];
    isNew = snapshot["isNew"];
    sort.value = snapshot["sort"] ?? 0;
    qty.value = snapshot["qty"] ?? 0;
      if(snapshot.containsKey('commentQty')){
        commentQty.value=snapshot['commentQty']??'';
      }
      if(snapshot.containsKey('realQty')){
        commentQty.value=snapshot['realQty']??0;
      }

    if(snapshot.containsKey('finishPicked')){
        finishPicked.value=snapshot['finishPicked']??false;
      }
    if(snapshot.containsKey('pallNr')){
        pallNr.value=snapshot['pallNr']??1;
      }
    barcode1.value=snapshot['barcode1'];
    barcode2.value=snapshot['barcode2'];
    barcode3.value=snapshot['barcode3'];
    countQty=double.parse(snapshot['countQty'].toString());


  }

  ProductModel.fromSnapshotOrderWithQty(
      Map<String, dynamic> snapshot,Map<String, dynamic> snapShotQty) {
    id = snapshot['id'] ?? '';
    idAmeen = snapshot['idAmeen'] ?? '';
    names = snapshot['names'] ?? '';
    dateImage = snapshot['date_img'] ?? '';
    descs = snapshot['desc'] ?? '';
    vat = snapshot['vat'] ?? 12;
    brand = snapshot['brand'] ?? '';
    size = snapshot['size'] ?? '';
    prices.value = snapshot['prices'] ?? 0;
    source = snapshot['source'] ?? '';
    categoryID.value = snapshot['categoryID'] ?? 0.obs;
    image = snapshot['image'] ?? '';
    specialPrice.value = double.parse(snapshot['specialPrice'].toString());
    enabled = snapshot["enabled"];
    isSpecial = snapshot["isSpecial"];
    isGood = snapshot["isGood"];
    isNew = snapshot["isNew"];
    sort.value = snapshot["sort"] ?? 0;
    qty.value = snapshot["qty"] ?? 0;

      if(snapShotQty.containsKey('commentQty')){
        commentQty.value=snapShotQty['commentQty']??'';
      }

      if(snapShotQty.containsKey('realQty')){
        realQty.value=snapShotQty['realQty']??0;
      }

    if(snapShotQty.containsKey('finishPicked')){
        finishPicked.value=snapShotQty['finishPicked']??false;
      }
    barcode1.value=snapshot['barcode1'];
    barcode2.value=snapshot['barcode2'];
    barcode3.value=snapshot['barcode3'];
    countQty=double.parse(snapshot['countQty'].toString());

  }



  @override
  String toString() {
    return '$id,$names[1],$names[0],$brand[1],$size[1], $enabled, $idAmeen, ${barcode1.value}, ${barcode2.value}, ${barcode3.value}';
  }

  toJson() {
    return {
      'id': id,
      'idAmeen': idAmeen,
      'names': names,
      'desc': descs,
      'brand': brand,
      // 'maxKopDesc': maxKopdescs,
      'size': size,
      'source': source,
      'categoryID': categoryID.value,
      'image': image,
      // 'compareUnit': compareUnit,
      // 'comparePrice': comparePrice.value,
      // 'price': price.value,
      // 'maxKop': maxKop.value,
      'specialPrice': specialPrice.value,
      "enabled": enabled,
      "isSpecial": isSpecial,
      "isGood": isGood,
      "isNew": isNew,
      "sort": sort.value,
      'prices': prices,
      'qty': qty.value,
      'barcode1':barcode1.value,
      'barcode2':barcode2.value,
      'barcode3':barcode3.value,
      'countQty':countQty,
    };
  }
}
