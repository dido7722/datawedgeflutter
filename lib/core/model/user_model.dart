import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userId = '',
      email = '',
      name = '',
      pic = '',
      signedInMethod = '',
      phone = '',
      orgNr = '',
      address = '',
      postAddress = '',
      city = '',
      nickName = '',
      password = '';
  int priceLevel = 0, id = 0,vrClient=0;
  bool showPrices = false, enabled = false;
  // RxBool isFortnox=false.obs;
  // String customerNumberFortnox='';
  UserModel({
    required this.userId,
    required this.email,
    required this.name,
    required this.pic,
    required this.signedInMethod,
    required this.orgNr,
    required this.address,
    required this.postAddress,
    required this.city,
    required this.priceLevel,
    required this.showPrices,
    required this.id,
    required this.nickName,
    required this.enabled,
    required this.phone,
    required this.password,
  });

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    userId = snapshot.get('userId') ?? '';
    email = snapshot.get('email') ?? '';
    name = snapshot.get('name') ?? '';
    pic = '';
    signedInMethod = snapshot.get('signedInMethod') ?? '';
    orgNr = snapshot.get('orgNr') ?? '';
    address = snapshot.get('address') ?? '';
    postAddress = snapshot.get('postAddress') ?? '';
    phone = snapshot.get('phone') ?? '';
    city = snapshot.get('city') ?? '';
    nickName = snapshot.get('nickName') ?? '';
    if(snapshot.data().toString().contains('vrClient')) {
      vrClient =int.tryParse( snapshot.get('vrClient').toString())!;
    }else{
      vrClient=0 ;
    }
    showPrices = snapshot.get('showPrices') ?? false;
    enabled = snapshot.get('enabled') ?? false;
    priceLevel = snapshot.get('priceLevel') ?? 0;
    password = snapshot.get('password') ?? 0;
    id = snapshot.get('id') ?? 0;
  }

  @override
  String toString() {
    return '$email,$name,$phone,$orgNr, $address,$postAddress,$city,$nickName,$id,';
  }

  toJson() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'pic': pic,
      'signedInMethod': signedInMethod,
      'orgNr': orgNr,
      'address': address,
      'postAddress': postAddress,
      'city': city,
      'showPrices': showPrices,
      'priceLevel': priceLevel,
      'id': id,
      'nickName': nickName,
      'enabled': enabled,
      'phone': phone,
      'password': password,
      'vrClient':0,
    };
  }
}
