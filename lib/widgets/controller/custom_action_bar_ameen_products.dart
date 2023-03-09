// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../core/view_model/ameen_import_view_model.dart';
// import 'constants.dart';
//
// // ignore: must_be_immutable
// class CustomActionBarAmeenProducts extends StatefulWidget {
//   CustomActionBarAmeenProducts({
//     Key? key,
//     this.title,
//     required this.find,
//     required this.countA,
//   }) : super(key: key);
//
//   final String? title;
//   final String find;
//   final String countA;
//
//   @override
//   State<CustomActionBarAmeenProducts> createState() =>
//       _CustomActionBarAmeenProductsState();
// }
//
// class _CustomActionBarAmeenProductsState
//     extends State<CustomActionBarAmeenProducts> {
//   AmeenImportViewModel ameenImportViewModel = Get.find();
//   final myController = new TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     final _newValue = widget.find;
//     myController.value = TextEditingValue(
//       text: _newValue,
//       selection: TextSelection.fromPosition(
//         TextPosition(offset: _newValue.length),
//       ),
//     );
//
//     return Container(
//       decoration: BoxDecoration(),
//       // : null),
//       padding: EdgeInsets.only(
//         top: MediaQuery.of(context).padding.top + 5,
//         left: 24.0,
//         right: 24.0,
//         bottom: 15.0,
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                   FocusScope.of(context).unfocus();
//                 },
//                 child: Container(
//                     width: 42.0,
//                     height: 42.0,
//                     decoration: BoxDecoration(
//                       color: Colors.black,
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     alignment: Alignment.center,
//                     child: Icon(
//                       Icons.arrow_back_ios,
//                       size: 20,
//                       color: Colors.white,
//                     )),
//               ),
//
//               Center(
//                 child: PrimaryText(
//                   text: widget.title ?? "Action Bar",
//                   size: 12.sp,
//                   maxLine: 2,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//               Center(
//                 child: PrimaryText(
//                   text: 'تم اختيار : ' + widget.countA,
//                   size: 12.sp,
//                   maxLine: 2,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//               // IconButton(
//               //   icon: Icon(Icons.list),
//               //   onPressed: () {},
//               // ),
//             ],
//           ),
//           Container(
//             margin: const EdgeInsets.only(top: 20),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               color: Colors.grey.shade200,
//             ),
//             child: TextField(
//               controller: myController,
//               onChanged: (value) {
//                 ameenImportViewModel.find.value = value;
//               },
//               onTap: () {},
//               decoration: InputDecoration(
//                   border: InputBorder.none,
//                   prefixIcon: const Icon(
//                     Icons.search,
//                     color: Colors.black,
//                   ),
//                   suffixIcon: CloseButton(
//                     onPressed: () {
//                       myController.clear();
//                       ameenImportViewModel.find.value = '';
//                       FocusScope.of(context).unfocus();
//                     },
//                   ),
//                   hintText: "search".tr,
//                   fillColor: Colors.grey,
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 24.0,
//                     vertical: 15.0,
//                   )),
//               style: TextStyle(
//                   fontSize: 11.0.sp,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
