// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';


class CusTextInput extends StatefulWidget {
  final String hintText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool? isPasswordField;
  final bool? isOrg;
  final bool? isPriceLevel;
  final bool? isPost;
  final bool? isNumberOnly;
  final String? text;
  final String? labelValue;
  final double  marginVertical;
  final double  contentPaddingVertical;
  final double  marginHorizontal;
  final double? size;
  final FontWeight? fontWeight;

  const CusTextInput(
      {Key? key,
      required this.hintText,
      required this.isPasswordField,
      this.onChanged,
      this.onSubmitted,
      this.focusNode,
      this.textInputAction,
      this.isOrg,
      this.isPriceLevel,
      this.isNumberOnly,
      this.isPost,
      this.text,
      this.labelValue,
      this.marginVertical =8,
      this.contentPaddingVertical =20,
        this.marginHorizontal =24,
      this.fontWeight =FontWeight.w600,
      this.size =16.0,
      })
      : super(key: key);

  @override
  State<CusTextInput> createState() => _CusTextInputState();
}

class _CusTextInputState extends State<CusTextInput> {
  var maskFormatter = MaskTextInputFormatter(
      mask: '######-####', filter: {"#": RegExp(r'[0-9]')});

  var maskFormatter1 =
      MaskTextInputFormatter(mask: '### ##', filter: {"#": RegExp(r'[0-9]')});

  var maskFormatter2 =
      MaskTextInputFormatter(mask: '#', filter: {"#": RegExp(r'[0-9]')});

  var maskFormatter3 =
      MaskTextInputFormatter( filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    bool isPasswordField = widget.isPasswordField ?? false;
    bool isOrg = widget.isOrg ?? false;
    bool isPost = widget.isPost ?? false;
    bool isNumberOnly = widget.isNumberOnly ?? false;
    bool isPriceLevel = widget.isPriceLevel ?? false;
    String labelValue=widget.labelValue ?? '';
    final myController = TextEditingController(text: widget.text);
    return Container(
      margin:  EdgeInsets.symmetric(
        vertical: widget.marginVertical,
        horizontal: widget.marginHorizontal,
      ),
      decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadiusDirectional.circular(12.0)),
      child: TextField(

        controller: myController,
        inputFormatters: isOrg
            ? [maskFormatter]
            : isPost
                ? [maskFormatter1]
                :isPriceLevel
        ?[maskFormatter2]:isNumberOnly
            ?[maskFormatter3]:null,
        keyboardType: isOrg
            ? TextInputType.number
            : isPost
                ? TextInputType.number
                : isPriceLevel
            ? TextInputType.number
            :isNumberOnly
            ? TextInputType.number
            :null,
        obscureText: isPasswordField,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        textInputAction: widget.textInputAction,
        decoration:(labelValue.isNotEmpty) ? InputDecoration(
            labelText: widget.labelValue,
            border: InputBorder.none,
            hintText: widget.hintText,
            contentPadding:  EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: widget.contentPaddingVertical,
            )):
        InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText,
            contentPadding:  EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: widget.contentPaddingVertical,
            )),
        style: TextStyle(
            fontSize:widget.size,
                fontWeight: widget.fontWeight,
        ),
      ),
    );
  }
}

class CusTextInputWithController extends StatefulWidget {
  final String hintText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool? isPasswordField;
  final bool? isOrg;
  final bool? isPriceLevel;
  final bool? isPost;
  final bool? isNumberOnly;
  final String? text;
  final String? labelValue;
  final double  marginVertical;
  final double  contentPaddingVertical;
  final double  marginHorizontal;
  final double? size;
  final FontWeight? fontWeight;
  final TextEditingController myEdit;

  const CusTextInputWithController(
      {Key? key,
      required this.hintText,
      required this.isPasswordField,
      this.onChanged,
      this.onSubmitted,
      this.focusNode,
      this.textInputAction,
      this.isOrg,
      this.isPriceLevel,
      this.isNumberOnly,
      this.isPost,
      this.text,
      this.labelValue,
      this.marginVertical =8,
      this.contentPaddingVertical =20,
        this.marginHorizontal =24,
      this.fontWeight =FontWeight.w600,
      this.size =16.0,
      required this.myEdit})
      : super(key: key);

  @override
  State<CusTextInputWithController> createState() => _CusTextInputWithControllerState();
}

class _CusTextInputWithControllerState extends State<CusTextInputWithController> {
  var maskFormatter = MaskTextInputFormatter(
      mask: '######-####', filter: {"#": RegExp(r'[0-9]')});

  var maskFormatter1 =
      MaskTextInputFormatter(mask: '### ##', filter: {"#": RegExp(r'[0-9]')});

  var maskFormatter2 =
      MaskTextInputFormatter(mask: '#', filter: {"#": RegExp(r'[0-9]')});

  var maskFormatter3 =
      MaskTextInputFormatter( filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    bool isPasswordField = widget.isPasswordField ?? false;
    bool isOrg = widget.isOrg ?? false;
    bool isPost = widget.isPost ?? false;
    bool isNumberOnly = widget.isNumberOnly ?? false;
    bool isPriceLevel = widget.isPriceLevel ?? false;
    String labelValue=widget.labelValue ?? '';
    TextEditingController myEdit=widget.myEdit;

    return Container(
      margin:  EdgeInsets.symmetric(
        vertical: widget.marginVertical,
        horizontal: widget.marginHorizontal,
      ),
      decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadiusDirectional.circular(12.0)),
      child: TextField(

        controller: myEdit,
        inputFormatters: isOrg
            ? [maskFormatter]
            : isPost
                ? [maskFormatter1]
                :isPriceLevel
        ?[maskFormatter2]:isNumberOnly
            ?[maskFormatter3]:null,
        keyboardType: isOrg
            ? TextInputType.number
            : isPost
                ? TextInputType.number
                : isPriceLevel
            ? TextInputType.number
            :isNumberOnly
            ? TextInputType.number
            :null,
        obscureText: isPasswordField,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        textInputAction: widget.textInputAction,
        decoration:(labelValue.isNotEmpty) ? InputDecoration(
            labelText: widget.labelValue,
            border: InputBorder.none,
            hintText: widget.hintText,
            contentPadding:  EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: widget.contentPaddingVertical,
            )):
        InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText,
            contentPadding:  EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: widget.contentPaddingVertical,
            )),
        style: TextStyle(
            fontSize:widget.size,
                fontWeight: widget.fontWeight,
        ),
      ),
    );
  }
}
