
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'constants.dart';
class CustomBtn extends StatelessWidget {
  const CustomBtn(
      {Key? key, required this.text,required this.onPressed, required this.outlineBtn, this.isLoadingWidget, this.heightWidget, this.marginVerticalWidget, this.isImageWidget, this.sourceImageWidget}) : super(key: key);

  final String text;
  final VoidCallback  onPressed;
  final bool? outlineBtn;
  final bool? isLoadingWidget;
  final double? heightWidget;
  final double? marginVerticalWidget;


  final bool? isImageWidget;
  final String? sourceImageWidget;
  @override
  Widget build(BuildContext context) {
    bool isLoading= isLoadingWidget ?? false;
    double  height = heightWidget ?? 5.0.h;
    double marginVertical= marginVerticalWidget ?? 2.h;
    bool isImage=isImageWidget ?? false;
    String sourceImage=sourceImageWidget ?? "";

    return GestureDetector(
      onTap: (){ onPressed();},
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color:  AppColors.activeColor,
          border: Border.all(
            color: Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(
            12.0,
          ),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: marginVertical,
        ),
        child: Stack(
          children: [
            Visibility(
              visible: isLoading ? false:true,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  if(isImage)
                    Visibility(
                      visible: isImage ? true:false,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image(
                            image:
                            AssetImage(sourceImage)),
                      ),
                    ),
                  SizedBox(            width: isImage ? 50.0:0,
                    height: 0,
                  ),
                  Center(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isLoading ,
              child: const Center(
                child:  SizedBox(
                    height: 25.0,
                    width: 25.0,
                    child:  CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
