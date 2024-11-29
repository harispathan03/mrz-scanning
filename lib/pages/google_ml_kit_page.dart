import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrz/view_model/google_ml_kit_viewmodel.dart';
import 'package:provider/provider.dart';

import '../widget/custom_detail_row.dart';
import '../widget/custom_home_button.dart';

class GoogleMlKitPage extends StatefulWidget {
  const GoogleMlKitPage({super.key});

  @override
  State<GoogleMlKitPage> createState() => _GoogleMlKitPageState();
}

class _GoogleMlKitPageState extends State<GoogleMlKitPage> {
  late GoogleMlKitViewmodel viewModel;

  @override
  void initState() {
    viewModel = context.read<GoogleMlKitViewmodel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.purple.shade500,
          title: const Text("ML Kit Passport Scan",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Consumer<GoogleMlKitViewmodel>(
                  builder: (context, model, child) => (model.documentNumber !=
                              "" &&
                          model.documentNumber.isNotEmpty)
                      ? Center(
                          child: Column(
                            children: [
                              Text(
                                model.isVerified
                                    ? "Passport is Valid"
                                    : "Passport is Invalid",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: model.isVerified
                                        ? Colors.green
                                        : Colors.red),
                              ),
                              const SizedBox(height: 20),
                              CustomDetailRow(
                                  propertyName: "First Name: ",
                                  value: model.firstName),
                              CustomDetailRow(
                                  propertyName: "Last Name: ",
                                  value: model.lastName),
                              CustomDetailRow(
                                  propertyName: "Passport Number: ",
                                  value: model.documentNumber),
                              CustomDetailRow(
                                  propertyName: "Gender: ",
                                  value: model.gender),
                              CustomDetailRow(
                                  propertyName: "Date of birth: ",
                                  value:
                                      viewModel.fetchDateFromString(model.dob,true)),
                              CustomDetailRow(
                                  propertyName: "Date of expiry: ",
                                  value:
                                      viewModel.fetchDateFromString(model.doe,false)),
                              const SizedBox(height: 20)
                            ],
                          ),
                        )
                      : Container()),
              InkWell(
                  onTap: () async {
                    log(viewModel.dob);
                    log(viewModel.doe);
                    // ImagePicker picker = ImagePicker();
                    // XFile? xfile =
                    //     await picker.pickImage(source: ImageSource.camera);
                    // if (xfile != null) {
                    //   viewModel.processDeviceImage(xfile.path);
                    // }
                  },
                  child:
                      const CustomHomeButton(text: "Scan image from camera")),
              const SizedBox(height: 10),
              InkWell(
                  onTap: () async {
                    ImagePicker picker = ImagePicker();
                    XFile? xfile =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (xfile != null) {
                      viewModel.processDeviceImage(xfile.path);
                    }
                  },
                  child:
                      const CustomHomeButton(text: "Scan image from gallery"))
            ]));
  }
}
