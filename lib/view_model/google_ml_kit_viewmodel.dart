import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';

class GoogleMlKitViewmodel extends ChangeNotifier {
  String firstName = "";
  String lastName = "";
  String documentNumber = "";
  String gender = "";
  String dob = "";
  String doe = "";
  String? extraData;
  int documentNumberChecksum = 0,
      dobChecksum = 0,
      doeChecksum = 0,
      finalChecksum = 0;
  int? extraDataChecksum;
  bool isVerified = false;
  List<String> mrz = [];
  TextRecognizer textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  void processDeviceImage(String path) async {
    clearData();
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
    log('First MRZ: $firstMRZ');
    log('Second MRZ: $secondMRZ');
    extractDataOfFirstLine(firstMRZ);
    extractDataOfSecondLine(secondMRZ);
  }

  void extractDataOfFirstLine(String text) {
    text = text.substring(5);
    int indexOfFirstSign = text.indexOf("<");
    lastName = text.substring(0, indexOfFirstSign);
    text = text.replaceFirst(lastName, "");
    text = text.replaceAll("<", " ");
    text = text.replaceAll("«", " ");
    firstName = text;
    firstName = text.trim();
  }

  void extractDataOfSecondLine(String text) {
    text = text.replaceAll("«", "<");
    text = text.replaceAll(" ", "");
    documentNumber = text.substring(0, 9);
    documentNumberChecksum = int.parse(text[9]);
    dob = text.substring(13, 19);
    dobChecksum = int.parse(text[19]);
    gender = text[20];
    doe = text.substring(21, 27);
    doeChecksum = int.parse(text[27]);
    if (text[28] != "<") {
      int lastIndex = text.lastIndexOf("<");
      if (lastIndex == -1) {
        lastIndex = 42;
      }
      extraData = text.substring(28, lastIndex);
      extraDataChecksum = int.parse(text[lastIndex + 1]);
    }
    finalChecksum = int.parse(text[text.length - 1]);
    String extraDataString =
        extraData != null ? (extraData! + extraDataChecksum.toString()) : "";

    //Verify Authenticity
    int passportResult = calculateChecksum(documentNumber);
    int dobResult = calculateChecksum(dob);
    int doeResult = calculateChecksum(doe);
    int finalResult = calculateChecksum(documentNumber.replaceAll("<", "") +
        documentNumberChecksum.toString() +
        dob +
        dobChecksum.toString() +
        doe +
        doeChecksum.toString() +
        extraDataString);
    log("final result: $finalResult");
    if (passportResult == documentNumberChecksum &&
        dobResult == dobChecksum &&
        doeResult == doeChecksum &&
        finalResult == finalChecksum) {
      isVerified = true;
    }
    log("passportResult: ${passportResult == documentNumberChecksum}");
    log("dobResult: ${dobResult == dobChecksum}");
    log("doeResult: ${doeResult == doeChecksum}");
    log("finalChecksum: ${finalResult == finalChecksum}");
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

  int calculateChecksum(String input) {
    final weights = [7, 3, 1];
    int checksum = 0;

    for (int i = 0; i < input.length; i++) {
      final char = input[i];
      int value;
      if (RegExp(r'[0-9]').hasMatch(char)) {
        value = int.parse(char); // Numeric value for digits
      } else if (RegExp(r'[A-Z]').hasMatch(char)) {
        value = char.codeUnitAt(0) - 'A'.codeUnitAt(0) + 10;
      } else if (char == '<') {
        value = 0;
      } else {
        throw Exception("Invalid character in MRZ: $char");
      }
      checksum += value * weights[i % weights.length];
    }
    return checksum % 10;
  }

  void clearData() {
    mrz.clear();
    firstName = "";
    lastName = "";
    documentNumber = "";
    gender = "";
    dob = "";
    doe = "";
    isVerified = false;
    notifyListeners();
  }
}
