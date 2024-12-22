import 'package:intl/intl.dart';

String formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

 String getCityNameBeforeComma(String cityName) {
    return cityName.split(',').first;
  }

String normalizeFileName(String fileName) {
  return fileName
      .replaceAll(RegExp(r'[^\w\.-]'), '_') 
      .replaceAll(' ', '_'); 
}

bool isSupportedFormat(String fileName, List<String> supportedFormats) {
  final fileExtension = fileName.split('.').last.toLowerCase();
  return supportedFormats.contains(fileExtension);
}
