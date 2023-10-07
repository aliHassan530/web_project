import 'package:flutter/material.dart';

import '../utilites/constants.dart';
import 'custom_text.dart';

class CustomBottomText extends StatelessWidget {
  CustomBottomText({
    this.title,
    this.fontsize,
    this.textColor,
    this.fontWeight,
    this.borderColor,
    this.borderWidth,
  });

  final title;
  double? fontsize;
  FontWeight? fontWeight;
  Color? borderColor;
  Color? textColor;
  double? borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: borderWidth ?? 1,
            color: borderColor ?? kBlackColor,
          ),
        ),
      ),
      child: CustomText(
        title: title,
        color: textColor ?? kBlackColor,
        fontWeight: fontWeight ?? FontWeight.w500,
        fontSize: fontsize ?? 15,
      ),
    );
  }
}
