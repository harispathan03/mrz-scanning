import 'package:flutter/material.dart';
import 'package:mrz/pages/blinkid_page.dart';
import 'package:mrz/pages/google_ml_kit_page.dart';
import 'package:mrz/pages/idanalyzer_page.dart';
import 'package:mrz/widget/custom_home_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade500,
        title: const Text("MRZ", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(),
          InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const BlinkidPage()));
              },
              child: const CustomHomeButton(text: "BlinkId Passport Scan")),
          const SizedBox(height: 10),
          InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const GoogleMlKitPage()));
              },
              child:
                  const CustomHomeButton(text: "Google ML Kit Passport Scan")),
          const SizedBox(height: 10),
          InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const IdAnalyzerPage()));
              },
              child: const CustomHomeButton(text: "IdAnalyzer Scan")),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
