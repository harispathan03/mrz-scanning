import 'package:flutter/material.dart';
import 'package:mrz/pages/blinkid_page.dart';
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
          const CustomHomeButton(text: "Google ML Kit Passport Scan"),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
