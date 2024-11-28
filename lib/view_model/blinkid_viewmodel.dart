import 'package:blinkid_flutter/microblink_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      license =
          "sRwCAA9jb20uZXhhbXBsZS5tcnoAbGV5SkRjbVZoZEdWa1QyNGlPakUzTXpJM01ERTFOell6TVRJc0lrTnlaV0YwWldSR2IzSWlPaUpsWXpJM1lqZGtZaTAxWXpkbUxUUTNZMkl0T0dNNE9TMDBaRGcwT0dOak56VXdaRE1pZlE9PTf3E+uqMMSSZgXjrLVKziqD9JOMA9oH6BGg/q+VvMEHRCpBh0rA9lgyWs+/coZAGSiuwwOw2QNcsbpD8sbGnWJ+RAAbVzEnjj4ZBpz6RUYbbkdX1CC/h1Yn2KPdOtphCKyOkiWjYY0p3t7M5S9eOhP509+cVRcwgQ==";
    } else if (Theme.of(context).platform == TargetPlatform.android) {
      license =
          "sRwCAA9jb20uZXhhbXBsZS5tcnoAbGV5SkRjbVZoZEdWa1QyNGlPakUzTXpJM01ERTFOell6TVRJc0lrTnlaV0YwWldSR2IzSWlPaUpsWXpJM1lqZGtZaTAxWXpkbUxUUTNZMkl0T0dNNE9TMDBaRGcwT0dOak56VXdaRE1pZlE9PTf3E+uqMMSSZgXjrLVKziqD9JOMA9oH6BGg/q+VvMEHRCpBh0rA9lgyWs+/coZAGSiuwwOw2QNcsbpD8sbGnWJ+RAAbVzEnjj4ZBpz6RUYbbkdX1CC/h1Yn2KPdOtphCKyOkiWjYY0p3t7M5S9eOhP509+cVRcwgQ==";
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
}
