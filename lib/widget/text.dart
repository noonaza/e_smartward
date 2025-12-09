import 'package:flutter/material.dart';

text(
  BuildContext context,
  String label,{
  Color? color,
  FontWeight? fontWeight,
  TextAlign? textAlign,
  double? fontSize,
  TextOverflow? overflow,
  int? maxLines,
}) {
  final width = MediaQuery.of(context).size.width;
  double size = 14 / 1920;

  return Text(
    label,
    style: TextStyle(
        fontSize: fontSize ?? (width * size < 14 ? 14 : width * size),
        color: color,
        fontWeight: fontWeight),
    overflow: overflow,
    maxLines: maxLines,
  );
}

textH1(BuildContext context, String label,
    {Color? color, bool isbold = false}) {
  final width = MediaQuery.of(context).size.width;
  double size = 30 / 1920;

  return Text(label,
      style: TextStyle(
          fontSize: width * size < 24 ? 24 : width * size,
          color: color,
          fontWeight: isbold ? FontWeight.bold : null));
}

textH2(BuildContext context, String label,
    {Color? color, bool isbold = false}) {
  final width = MediaQuery.of(context).size.width;
  double size = 24 / 1920;

  return Text(label,
      style: TextStyle(
          fontSize: width * size < 20 ? 20 : width * size,
          color: color,
          fontWeight: isbold ? FontWeight.bold : null));
}

textMenu(BuildContext context, String label, Color? color,
    FontWeight? fontWeight, TextAlign? textAlign) {
  final width = MediaQuery.of(context).size.width;

  if (width <= 480) {
    return TextStyle(fontSize: 10, color: color, fontWeight: fontWeight);
  } else if (width <= 834) {
    return TextStyle(fontSize: 12, color: color, fontWeight: fontWeight);
  } else {
    return TextStyle(fontSize: 14, color: color, fontWeight: fontWeight);
  }
}

textStyleStatus(BuildContext context, Color? color) {
  final width = MediaQuery.of(context).size.width;
  double size = 16 / 1920;

  return TextStyle(
      fontSize: width * size < 12 ? 12 : width * size, color: color);
}

textStyleCustom(BuildContext context, {Color? color}) {
  final width = MediaQuery.of(context).size.width;
  double size = 16 / 1920;
  return TextStyle(
    fontSize: width * size < 10 ? 10 : width * size,
    color: color,
  );
}

textStyleHeader(BuildContext context, Color? color) {
  final width = MediaQuery.of(context).size.width;

  if (width <= 500) {
    return TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.bold);
  } else if (width <= 700) {
    return TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.bold);
  } else if (width <= 900) {
    return TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.bold);
  } else {
    return TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold);
  }
}

textStyleMenu(BuildContext context, Color? color, FontWeight? fontWeight) {
  final width = MediaQuery.of(context).size.width;

  if (width <= 500) {
    return TextStyle(fontSize: 8, color: color, fontWeight: fontWeight);
  }
  if (width <= 700) {
    return TextStyle(fontSize: 10, color: color, fontWeight: fontWeight);
  } else if (width <= 900) {
    return TextStyle(fontSize: 12, color: color, fontWeight: fontWeight);
  } else {
    return TextStyle(fontSize: 14, color: color, fontWeight: fontWeight);
  }
}
