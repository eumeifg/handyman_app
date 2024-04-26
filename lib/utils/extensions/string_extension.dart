import 'package:flutter/material.dart';
import 'package:sun3ah_provider/components/app_widgets.dart';
import 'package:sun3ah_provider/main.dart';
import 'package:sun3ah_provider/utils/colors.dart';

extension intExt on String {
  Widget iconImage({double? size, Color? color, BoxFit? fit}) {
    return Image.asset(
      this,
      height: size ?? 24,
      width: size ?? 24,
      fit: fit ?? BoxFit.cover,
      color: color ?? (appStore.isDarkMode ? Colors.white : appTextSecondaryColor),
      errorBuilder: (context, error, stackTrace) => placeHolderWidget(height: size ?? 24, width: size ?? 24, fit: fit ?? BoxFit.cover),
    );
  }
}
