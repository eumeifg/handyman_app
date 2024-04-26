import 'package:flutter/material.dart';
import 'package:sun3ah_provider/locale/base_language.dart';

extension ContextExt on BuildContext {
  Languages get translate => Languages.of(this);
}
