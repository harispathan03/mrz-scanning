import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';

class GoogleMlKitViewmodel extends ChangeNotifier {
  String license = "";
  String firstName = "";
  String lastName = "";
  String documentNumber = "";
  String gender = "";
  String dob = "";
  String doe = "";
  bool isVerified = false;
  List<String> mrz = [];
  TextRecognizer textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  void processDeviceImage(String path) async {
    final RecognizedText recognizedText =
        await textRecognizer.processImage(InputImage.fromFilePath(path));

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        if (line.text.contains("<")) {
          mrz.add(line.text);
        }
      }
    }
    var firstMRZ = mrz.first.replaceAll(" ", "");
    var secondMRZ = mrz.last.replaceAll(" ", "");
    extractDataOfSecondLine(secondMRZ);
    log('First MRZ: $firstMRZ');
    log('Second MRZ: $secondMRZ');
  }

  void extractDataOfSecondLine(String text) {
    documentNumber = text.substring(0, 9);
    gender = text[20];
    dob = text.substring(13, 19);
    doe = text.substring(21, 27);
    notifyListeners();
  }

  String fetchDateFromString(String dateString, bool isDob) {
    int year = int.parse(dateString.substring(0, 2));
    int currentYearSuffix =
        int.parse(DateTime.now().year.toString().substring(2, 4));
    int currentYearPrefix =
        int.parse(DateTime.now().year.toString().substring(0, 2));
    if (isDob) {
      //2024 -- 2002 - 1995
      if (year > currentYearSuffix) {
        currentYearPrefix--;
      }
    } else {
      //2024 -- 2048, 1998 -- 2015
      if (year < currentYearSuffix) {
        currentYearPrefix++;
      }
    }
    String month = dateString.substring(2, 4);
    String day = dateString.substring(4, 6);
    DateTime dateTime = DateTime(
        (currentYearPrefix * 100) + year, int.parse(month), int.parse(day));
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    final String formatted = formatter.format(dateTime);
    return formatted;
  }
}
