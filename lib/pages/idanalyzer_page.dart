import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrz/view_model/idanalyzer_viewmodel.dart';
import 'package:provider/provider.dart';

import '../widget/custom_detail_row.dart';
import '../widget/custom_home_button.dart';

class IdAnalyzerPage extends StatefulWidget {
  const IdAnalyzerPage({super.key});

  @override
  State<IdAnalyzerPage> createState() => _IdAnalyzerPageState();
}

class _IdAnalyzerPageState extends State<IdAnalyzerPage> {
  late IdAnalyzerViewModel viewModel;

  @override
  void initState() {
    viewModel = context.read<IdAnalyzerViewModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.purple.shade500,
          title: const Text("IdAnalyzer Scan",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Consumer<IdAnalyzerViewModel>(
                  builder: (context, model, child) => model.isLoading
                      ? const Padding(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: Center(
                            child: Column(
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.purple,
                                ),
                                Text("Scanning the image\nPlease wait...",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20))
                              ],
                            ),
                          ),
                        )
                      : (model.documentNumber != "" &&
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
                                      value: viewModel
                                          .fetchDateFromString(model.dob)),
                                  CustomDetailRow(
                                      propertyName: "Date of issue: ",
                                      value: viewModel
                                          .fetchDateFromString(model.doi)),
                                  CustomDetailRow(
                                      propertyName: "Date of expiry: ",
                                      value: viewModel
                                          .fetchDateFromString(model.doe)),
                                  const SizedBox(height: 20)
                                ],
                              ),
                            )
                          : Container()),
              InkWell(
                  onTap: () async {
                    ImagePicker picker = ImagePicker();
                    XFile? xfile =
                        await picker.pickImage(source: ImageSource.camera);
                    if (xfile != null) {
                      await viewModel.processDeviceImage(xfile);
                    }
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
                      await viewModel.processDeviceImage(xfile);
                    }
                  },
                  child:
                      const CustomHomeButton(text: "Scan image from gallery"))
            ]));
  }
}
