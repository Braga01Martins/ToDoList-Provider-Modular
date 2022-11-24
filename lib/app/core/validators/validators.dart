import 'package:flutter/material.dart';

class Validators {
  Validators._(); // contrutor privado não pode ser instanciado.
  static FormFieldValidator compare(
      TextEditingController? valueEC, String message) {
    return (value) {
      final valueCompare = valueEC?.text ?? '';
      if (value == null || (value != null && value != valueCompare)) {
        return message;
      }
    };
  }
}
