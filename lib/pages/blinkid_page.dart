import 'package:flutter/material.dart';
import 'package:mrz/view_model/blinkid_viewmodel.dart';
import 'package:mrz/widget/custom_detail_row.dart';
import 'package:mrz/widget/custom_home_button.dart';
import 'package:provider/provider.dart';

class BlinkidPage extends StatefulWidget {
  const BlinkidPage({super.key});

  @override
  State<BlinkidPage> createState() => _BlinkidPageState();
}

class _BlinkidPageState extends State<BlinkidPage> {
  late BlinkidViewModel viewModel;

  @override
  void initState() {
    viewModel = context.read<BlinkidViewModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple.shade500,
        title: const Text("BlinkId Passport Scan",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Consumer<BlinkidViewModel>(
              builder: (context, model, child) => (model.documentNumber != "" &&
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
                              propertyName: "Gender: ", value: model.gender),
                          CustomDetailRow(
                              propertyName: "Date of birth: ",
                              value: viewModel
                                  .fetchBirthDateFromString(model.dob)),
                          CustomDetailRow(
                              propertyName: "Date of expiry: ",
                              value: viewModel
                                  .fetchExpiryDateFromString(model.doe)),
                          const SizedBox(height: 20)
                        ],
                      ),
                    )
                  : Container()),
          InkWell(
              onTap: () {
                context.read<BlinkidViewModel>().scan(context);
              },
              child: const CustomHomeButton(text: "Scan Now"))
        ],
      ),
    );
  }
}
