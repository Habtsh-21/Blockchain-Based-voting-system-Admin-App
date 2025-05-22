import 'package:blockchain_based_national_election_admin_app/core/widgets/gradient_button.dart';
import 'package:blockchain_based_national_election_admin_app/core/widgets/textfield.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/provider.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/provider_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/quickalert.dart';

class AddState extends ConsumerStatefulWidget {
  const AddState({super.key});

  @override
  ConsumerState<AddState> createState() => _AddStateState();
}

class _AddStateState extends ConsumerState<AddState> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final idController = TextEditingController();
  ContractProviderState? _previousState;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    ContractProviderState contractState = ref.watch(contractProvider);
    if (_previousState != contractState && contractState is StateAddedState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Success!',
          textColor: Colors.black,
          text: 'trxHash:${contractState.trxHash}',
          borderRadius: 0,
          barrierColor: Colors.black.withOpacity(0.2),
        );
        ref.read(contractProvider.notifier).resetState();
      });
    } else if (_previousState != contractState &&
        contractState is ContractFailureState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          textColor: Colors.black,
          text: contractState.message,
          borderRadius: 0,
        );
        ref.read(contractProvider.notifier).resetState();
      });
    }
    return SingleChildScrollView(
      child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
          ),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.1,
                  ),
                  CustomTextField(
                    controller: nameController,
                    labelText: "State Name",
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
                        return 'Enter a valid name (letters and spaces only)';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  CustomTextField(
                    controller: idController,
                    labelText: "State ID",
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Number is required';
                      }
                      final number = int.tryParse(value);
                      if (number == null) {
                        return 'Enter a valid number';
                      }
                      if (number < 0) {
                        return 'Number must be positive';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: height * 0.1,
                  ),
                  GradientButton(
                    onPress: () async {
                      if (_formKey.currentState!.validate()) {
                        int? id = int.tryParse(idController.text);
                        await ref
                            .read(contractProvider.notifier)
                            .addState(nameController.text, id!);
                      }
                    },
                    text: contractState is StateAddingState ||
                            contractState is FileUpoadingState
                        ? const Center(child: CircularProgressIndicator())
                        : const Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
              ))),
    );
  }
}


// https://sepolia.etherscan.io/tx/0xc78719147174c4057cb9db212bb78f8caccaba126bdf4907f3adb05318cb70f5