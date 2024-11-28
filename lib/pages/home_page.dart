import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/home_viewmodel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MRZ Scan"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<HomeViewmodel>(
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
                        Text("Last Name: ${model.firstName}",
                            style: const TextStyle(fontSize: 16)),
                        Text("Document Number: ${model.documentNumber}",
                            style: const TextStyle(fontSize: 16)),
                        Text("Date of birth: ${model.dob}",
                            style: const TextStyle(fontSize: 16)),
                        Text("Date of expiry: ${model.doe}",
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 20)
                      ],
                    )
                  : Container()),
          Center(
            child: ElevatedButton(
              onPressed: () => context.read<HomeViewmodel>().scan(context),
              child: const Text("Select image from gallery"),
            ),
          ),
        ],
      ),
    );
  }
}
