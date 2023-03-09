// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
//
// import '../core/model/ameen_model.dart';
// import '../core/model/categories_model.dart';
// import '../core/view_model/ameen_import_view_model.dart';
// import '../core/view_model/categories_view_model.dart';
// import '../widgets/controller/constants.dart';
// import '../widgets/controller/custom_action_bar_ameen_products.dart';
//
// class ImportProductsAmeen extends GetWidget<AmeenImportViewModel> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GetX<AmeenImportViewModel>(
//           init: Get.put<AmeenImportViewModel>(AmeenImportViewModel()),
//           builder: (AmeenImportViewModel importProducts) {
//             CategoriesViewModel categoriesViewModel=Get.find();
//             categoriesViewModel.categoriesList.sort((a, b) => a.sort.compareTo(b.sort));
//             return Column(
//               children: <Widget>[
//                 CustomActionBarAmeenProducts(
//                   title: 'الاصناف'.tr,
//                   find: importProducts.find.value,
//                   countA:importProducts.ameenProductModel.where((p0) => p0.selected.value).length.toString() ,
//
//                 ),
//                 Flexible(
//                   child: Container(
//                     child: Column(
//                       children: <Widget>[
//                         Expanded(
//                           child: ListView.builder(
//                             itemCount: importProducts.find.value.length > 0
//                                 ? importProducts.ameenProductModel
//                                     .where((p0) => p0
//                                         .toString()
//                                         .toLowerCase()
//                                         .contains(importProducts.find.value))
//                                     .length
//                                 : importProducts.ameenProductModel.length,
//                             itemBuilder: (_, index) {
//                               return Container(
//                                 // width: 600,
//                                 // height: 700,
//                                 child: AmeenProductCard(
//                                   index: index,
//                                   categoriesList: categoriesViewModel.categoriesList,
//                                   ameenProductModel: importProducts
//                                               .find.value.length >
//                                           0
//                                       ? importProducts.ameenProductModel
//                                           .where((p0) => p0
//                                               .toString()
//                                               .toLowerCase()
//                                               .contains(
//                                                   importProducts.find.value))
//                                           .toList()
//                                       : importProducts.ameenProductModel
//                                           .toList(),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//
//             // Expanded(child: OrdersListview()),
//           }),
//       // floatingActionButton: Container(
//       //   child: new FloatingActionButton.small(
//       //     onPressed: () =>
//       //         Navigator.pushNamed(context, '/AddProduct'),
//       //     backgroundColor: Colors.deepOrangeAccent,
//       //     child: const Icon(Icons.add),
//       //   ),
//       // ),
//     );
//   }
// }
//
// class AmeenProductCard extends StatefulWidget {
//   AmeenProductCard(
//       {required this.ameenProductModel, required this.index,required this.categoriesList, Key? key})
//       : super(key: key);
//   final List<AmeenProductModel> ameenProductModel;
//   final List<CategoriesModel> categoriesList;
//   final int index;
//
//   @override
//   State<AmeenProductCard> createState() => _AmeenProductCardState();
// }
//
// class _AmeenProductCardState extends State<AmeenProductCard> {
//   RxInt categoryID = 0.obs;
//   String dropDownString = 'منتجات ومعلبات اخرى',categoyName='';
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(()=>
//        Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(5),
//           border: Border.all(
//             color: Color(0xff73747e),
//             width: 1.5,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Color(0xff73747e),
//               spreadRadius: 0,
//               blurRadius: 4,
//               offset: Offset(2, 0), // changes position of shadow
//             ),
//           ],
//         ),
//         margin: const EdgeInsets.all(1.0),
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Container(
//               width: MediaQuery.of(context).size.width * 0.7,
//               padding: EdgeInsets.symmetric(horizontal: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     child: PrimaryText(
//                       text: widget.ameenProductModel[widget.index].name,
//                       fontWeight: FontWeight.w600,
//                       size: 12.sp,
//                       maxLine: 2,
//                     ),
//                   ),
//                   Container(
//                     child: PrimaryText(
//                       text: widget.ameenProductModel[widget.index].latinName,
//                       fontWeight: FontWeight.w600,
//                       size: 12.sp,
//                       maxLine: 2,
//                     ),
//                   ),
//                   DropdownButton(
//                     value: dropDownString,
//                     elevation: 16,
//                     icon: Icon(Icons.keyboard_arrow_down),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         dropDownString = newValue!;
//                         categoyName = newValue;
//                         categoryID.value = widget.categoriesList
//                             .firstWhere((element) =>
//                         element.name[1] == categoyName)
//                             .no;
//                         widget.ameenProductModel[widget.index].categoryID=categoryID;
//                       });
//                     },
//                     items: widget.categoriesList
//                         .where((p0) =>
//                     !p0.name[1].contains('مكسرات') &&
//                         !p0.name[1].contains('كل المنتجات') &&
//                         !p0.name[1].contains('جديدنا') &&
//                         !p0.name[1].contains('العروض الاسبوعية'))
//                         .map<DropdownMenuItem<String>>((element) {
//
//                       return DropdownMenuItem(
//                           value: element.name[1],
//                           child: Text(
//                             element.name[1],
//                           ));
//                     }).toList(),
//                   ),
//
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         child: PrimaryText(
//                           text: widget.ameenProductModel[widget.index].code,
//                           size: 8.sp,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xff73747e),
//                           maxLine: 1,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             RaisedButton.icon(
//                 onPressed: () async {
//                   widget.ameenProductModel[widget.index].selected.toggle();
//                   // if(importProducts.isStarted.value==false) {
//                   //   Future sss() =>
//                   //       importProducts.refreshProduct();
//                   //   await sss();
//                   // }
//                   // Navigator.pushNamed(
//                   //     context,
//                   //     '/ImportProductsAmeen');
//                 },
//                 icon: Icon(
//                   Icons.done,
//                   color: !widget.ameenProductModel[widget.index].selected.value ? Colors.black12 :AppColors.activeColor,
//                 ),
//                 label: Text( '')),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
