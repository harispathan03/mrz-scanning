import 'package:flutter/material.dart';
import 'package:mrz/view_model/blinkid_viewmodel.dart';
import 'package:mrz/widget/custom_home_button.dart';
import 'package:provider/provider.dart';

class BlinkidPage extends StatelessWidget {
  const BlinkidPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple.shade500,
        title:
            const Text("Blinkid Scan", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<BlinkidViewModel>(
              builder: (context, model, child) => (model.documentNumber != "" &&
                      model.documentNumber.isNotEmpty)
                  ? Column(
                      children: [
                        Text(
                          model.isVerified
                              ? "Document is verified successfully!"
                              : "Document verification failed!",
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        Text("First Name: ${model.firstName}",
                            style: const TextStyle(fontSize: 16)),
                        Text("Last Name: ${model.lastName}",
                            style: const TextStyle(fontSize: 16)),
                        Text("Document Number: ${model.documentNumber}",
                            style: const TextStyle(fontSize: 16)),
                        Text("Gender: ${model.gender}",
                            style: const TextStyle(fontSize: 16)),
                        Text(model.dob, style: const TextStyle(fontSize: 16)),
                        Text(model.doe, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 20)
                      ],
                    )
                  : Container()),
          InkWell(
              onTap: () {
                context.read<BlinkidViewModel>().scan(context);
              },
              child: const CustomHomeButton(text: "Select image from gallery"))
        ],
      ),
    );
  }
}
