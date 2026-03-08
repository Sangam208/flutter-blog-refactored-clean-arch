import 'package:intl/intl.dart';

String formatDateByddMMYYYY(DateTime dateTime) =>
    DateFormat('dd MMM, yyyy').format(dateTime);
