import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> showCustomDatePicker(
  BuildContext context,
  TextEditingController controller, {
  required Function(DateTime) onDateSelected,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  String? helpText,
  String? fieldLabelText,
  Locale? locale,
}) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: firstDate ?? DateTime(2000),
    lastDate: lastDate ?? DateTime(2101),
    helpText: helpText,
    fieldLabelText: fieldLabelText,
    locale: locale,
  );

  if (picked != null) {
    onDateSelected(picked);
    controller.text = DateFormat('dd/MM/yyyy').format(picked);
  }
}
