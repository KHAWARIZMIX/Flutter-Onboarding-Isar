// Helper method to format the date

import 'package:intl/intl.dart';

 formatDate(DateTime date, String locale) {
  try {

    // Format the date with the given locale
    return DateFormat('yyyy MMM dd', locale).format(date);
  } catch (e) {
    // Handle parsing error
    return 'Invalid Date';
  }
}

