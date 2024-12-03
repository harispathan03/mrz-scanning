import 'package:blinkid_flutter/microblink_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mrz/utils/api_keys.dart';

class BlinkidViewModel extends ChangeNotifier {
  String license = "";
  String firstName = "";
  String lastName = "";
  String documentNumber = "";
  String gender = "";
  String dob = "";
  String doe = "";
  bool isVerified = false;
  Future<void> scan(BuildContext context) async {
    List<RecognizerResult> results;

    Recognizer recognizer = BlinkIdMultiSideRecognizer();
    OverlaySettings settings = BlinkIdOverlaySettings();

    // set your license
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      license = ApiKeys.blinkIdLicenseKeyIos;
    } else if (Theme.of(context).platform == TargetPlatform.android) {
      license = ApiKeys.blinkIdLicenseKeyAndroid;
    }

    try {
      // perform scan and gather results
      results = await MicroblinkScanner.scanWithCamera(
          RecognizerCollection([recognizer]), settings, license);
      for (var result in results) {
        if (result is BlinkIdMultiSideRecognizerResult) {
          if (result.mrzResult?.documentType == MrtdDocumentType.Passport) {
            getPassportResultString(result);
          }
          notifyListeners();
        }
      }
    } on PlatformException {
      // handle exception
    }
  }

  void getPassportResultString(BlinkIdMultiSideRecognizerResult? result) {
    if (result == null) {
      return;
    }

    var dateOfBirth = "";
    if (result.mrzResult?.dateOfBirth != null) {
      dateOfBirth = "Date of birth: ${result.mrzResult!.dateOfBirth?.day}."
          "${result.mrzResult!.dateOfBirth?.month}."
          "${result.mrzResult!.dateOfBirth?.year}\n";
    }

    var dateOfExpiry = "";
    if (result.mrzResult?.dateOfExpiry != null) {
      dateOfExpiry = "Date of expiry: ${result.mrzResult?.dateOfExpiry?.day}."
          "${result.mrzResult?.dateOfExpiry?.month}."
          "${result.mrzResult?.dateOfExpiry?.year}\n";
    }
    isVerified = result.mrzResult?.mrzVerified ?? false;
    gender = result.mrzResult?.gender ?? "";
    firstName = result.mrzResult?.secondaryId ?? "";
    lastName = result.mrzResult?.primaryId ?? "";
    documentNumber = result.mrzResult?.documentNumber ?? "";
    dob = dateOfBirth;
    doe = dateOfExpiry;
  }

  String fetchBirthDateFromString(String dateString) {
    String date = dateString.substring(15, 24);
    List<String> arr = date.split(".");
    DateTime dateTime =
        DateTime(int.parse(arr[2]), int.parse(arr[1]), int.parse(arr[0]));
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    final String formatted = formatter.format(dateTime);
    return formatted;
  }

  String fetchExpiryDateFromString(String dateString) {
    String date = dateString.substring(16);
    List<String> arr = date.split(".");
    DateTime dateTime =
        DateTime(int.parse(arr[2]), int.parse(arr[1]), int.parse(arr[0]));
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    final String formatted = formatter.format(dateTime);
    return formatted;
  }
}
