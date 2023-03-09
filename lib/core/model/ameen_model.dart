
import 'package:get/get.dart';

class AmeenProductModel {
  int number=0;
  String code='',name='',latinName='';
  RxBool selected=false.obs;
  RxInt categoryID=19.obs;
  int vat=12;


  AmeenProductModel({
    required this.number,
    required this.code,
    required this.name,
    required this.latinName ,
    required this.selected,
    required this.categoryID,
    required this.vat,

  });
   AmeenProductModel.fromJson(Map<String, dynamic> snapshot){

    number = snapshot['Number'] ?? 0;
    code= snapshot['Code'] ?? '';
    name = snapshot['Name'] ?? '';
    latinName = snapshot['LatinName'] ?? '';
    vat = snapshot['VAT'] ??12;
    selected=false.obs;
    categoryID=19.obs;
  }

  @override
  String toString() {
    return '$number,$code,$name,$latinName,';
  }

}
