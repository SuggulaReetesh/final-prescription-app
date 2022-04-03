import 'package:flutter/rendering.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<void> saveAndLaunchFile(List<int> bytes, String filename) async {
  final path = (await getExternalStorageDirectory()).path;
  final file = File('$path/$filename');
  await file.writeAsBytes(bytes, flush: true);
  OpenFile.open('$path/$filename');
}

Future<PdfFont> getFont(TextStyle style) async {
  Directory directory = await getApplicationSupportDirectory();
//Create an empty file to write the font data
  File file = File('${directory.path}/${style.fontFamily}.ttf');
  List<int> fontBytes;
  //Check if entity with the path exists
  if (file.existsSync()) {
    fontBytes = await file.readAsBytes();
  }
  if (fontBytes != null && fontBytes.isNotEmpty) {
    //Return the google font
    return PdfTrueTypeFont(fontBytes, 20);
  } else {
    //Return the default font
    return PdfStandardFont(PdfFontFamily.helvetica, 12);
  }
}
