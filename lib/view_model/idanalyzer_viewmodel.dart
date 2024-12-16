import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mrz/utils/checksum_helper.dart';

import '../utils/api_keys.dart';

class IdAnalyzerViewModel extends ChangeNotifier with ChecksumHelper {
  String firstName = "";
  String lastName = "";
  String documentNumber = "";
  String gender = "";
  String dob = "";
  String doi = "";
  String doe = "";
  String? extraData;
  int documentNumberChecksum = 0,
      dobChecksum = 0,
      doeChecksum = 0,
      finalChecksum = 0;
  int? extraDataChecksum;
  String mrz = "";
  bool isVerified = false;
  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> processDeviceImage(XFile xfile) async {
    setLoading(true);
    File file = File(xfile.path);
    List<int> imageBytes = await file.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    //convert image to base64
    var client = http.Client();
    try {
      final url = Uri.parse("https://api2.idanalyzer.com/scan");

      var response = await client.post(url,
          headers: {
            "X-API-KEY": ApiKeys.idAnalyzerApiKey,
            "Content-Type": "application/json"
          },
          body: jsonEncode(
              {"document": base64Image, "profile": "security_medium"}));

      var decodedResponse =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      log(decodedResponse.toString());
      setDataFromResponse(decodedResponse);

      if (response.statusCode == 200) {
        print("Response: $decodedResponse");
      } else {
        print("Error: ${response.reasonPhrase}");
      }
    } finally {
      setLoading(false);
      client.close();
    }
  }

  void setDataFromResponse(Map<String, dynamic> response) {
    firstName = response['data']?['firstName']?[0]?['value'] ?? "";
    lastName = response['data']?['lastName']?[0]?['value'] ?? "";
    documentNumber = response['data']?['documentNumber']?[0]?['value'] ?? "";
    gender = response['data']?['sex']?[0]?['value'] ?? "";
    dob = response['data']?['dob']?[0]?['value'] ?? "";
    doi = response['data']?['issued']?[0]?['value'] ?? "";
    doe = response['data']?['expiry']?[0]?['value'] ?? "";
    //P2251480<1IND9006038M2608307<<<<<<<<<<<<<<<8
    String mrz = (response['data']['mrz'][0]['value'] as String).substring(44);
    bool passportNumberCheck =
        calculateChecksum(mrz.substring(0, 9)) == int.parse(mrz[9]);
    bool dobCheck =
        calculateChecksum(mrz.substring(13, 19)) == int.parse(mrz[19]);
    bool doeCheck =
        calculateChecksum(mrz.substring(21, 27)) == int.parse(mrz[27]);
    bool totalCheck = calculateChecksum(mrz.substring(0, 10) +
            mrz.substring(13, 20) +
            mrz.substring(21, 28)) ==
        int.parse(mrz[43]);
    if (passportNumberCheck && dobCheck && doeCheck && totalCheck) {
      isVerified = true;
    }
    notifyListeners();
  }

  String fetchDateFromString(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return "Not Found";
    }
    //1990-06-03
    String year = dateString.substring(0, 4);
    String month = dateString.substring(5, 7);
    String day = dateString.substring(8, 10);
    DateTime dateTime =
        DateTime(int.parse(year), int.parse(month), int.parse(day));
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    final String formatted = formatter.format(dateTime);
    return formatted;
  }
}
