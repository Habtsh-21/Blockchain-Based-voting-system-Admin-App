import 'dart:io';
import 'package:blockchain_based_national_election_admin_app/core/widgets/gradient_button.dart';
import 'package:blockchain_based_national_election_admin_app/core/widgets/textfield.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/provider.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/provider_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';

class AddRepresentative extends ConsumerStatefulWidget {
  const AddRepresentative({super.key});

  @override
  ConsumerState<AddRepresentative> createState() => _AddRepState();
}

class _AddRepState extends ConsumerState<AddRepresentative> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final partyIdController = TextEditingController();
  final stateIdController = TextEditingController();
  late String? photo;

  ContractProviderState? _previousState;

  File? _image;
  XFile? pickedFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile!.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    ContractProviderState contractState = ref.watch(contractProvider);

    if (_previousState != contractState && contractState is RepAddedState) {
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
    _previousState = contractState;
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
                    labelText: "Represetative Name",
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
                    controller: partyIdController,
                    labelText: "party ID",
                    keyboardType: TextInputType.name,
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
                    height: height * 0.03,
                  ),
                  CustomTextField(
                    controller: stateIdController,
                    labelText: "State ID",
                    keyboardType: TextInputType.name,
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
                    height: height * 0.03,
                  ),
                  InkWell(
                    onTap: () async {
                      await _pickImage();
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        child: Center(
                          child: _image != null
                              ? Image.file(_image!, height: 200)
                              : const Column(
                                  children: [
                                    Icon(
                                      Icons.image,
                                      size: 116,
                                    ),
                                    Text('Picker a Representative Photo')
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.1,
                  ),
                  GradientButton(
                    onPress: () async {
                      if (_formKey.currentState!.validate()) {
                        print('a1');
                        if (_image == null) return;
                        int? partyId = int.tryParse(partyIdController.text);
                        int? stateId = int.tryParse(stateIdController.text);

                        final timestamp = DateTime.now().microsecondsSinceEpoch;
                        final fileName =
                            "${nameController.text} - $partyId -$stateId - $timestamp";
                        photo = await ref
                            .read(contractProvider.notifier)
                            .uploadImage(_image!, fileName);
                        print('a2');
                        print(photo);
                        if (photo != null &&
                            partyId != null &&
                            stateId != null) {
                          ref.read(contractProvider.notifier).addRep(
                              nameController.text, photo!, partyId, stateId);
                        } else {
                          print('something wrong');

                          ref.watch(contractProvider.notifier).resetState();
                        }
                      }
                    },
                    text: contractState is RepAddingState
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
