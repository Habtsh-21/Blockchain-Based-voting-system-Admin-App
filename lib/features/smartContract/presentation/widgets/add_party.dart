import 'dart:io';
import 'package:blockchain_based_national_election_admin_app/core/widgets/gradient_button.dart';
import 'package:blockchain_based_national_election_admin_app/core/widgets/textfield.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/provider.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/provider_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AddParty extends ConsumerStatefulWidget {
  const AddParty({super.key});

  @override
  ConsumerState<AddParty> createState() => _AddPartyState();
}

class _AddPartyState extends ConsumerState<AddParty> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final idController = TextEditingController();
  late String? symbol;
  ContractProviderState? _previousState;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    idController.dispose();
  }

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

    // Detect change to PartyAddedState
    if (_previousState != contractState && contractState is PartyAddedState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          backgroundColor: const Color.fromARGB(255, 34, 198, 91),
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
                    labelText: "party Name",
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
                    labelText: "party ID",
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
                                    Text('Picker  a symbol')
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
                        int? id = int.tryParse(idController.text);
                        if (_image == null) return;
                        final timestamp = DateTime.now().microsecondsSinceEpoch;
                        final fileName =
                            "${nameController.text} - ${idController.text} - $timestamp";
                        symbol = await ref
                            .read(contractProvider.notifier)
                            .uploadImage(_image!, fileName);
                        print('a2');
                        print(symbol);
                        if (symbol != null && id != null) {
                          await ref
                              .read(contractProvider.notifier)
                              .addParty(nameController.text, symbol!, id);

                          print('after after');
                        } else {
                          print('something wrong');

                          ref
                              .watch(contractProvider.notifier)
                              .setFailure(contractState);
                        }
                      }
                    },
                    text: contractState is PartyAddingState ||
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
                  SizedBox(height: height * 0.02),
                  if (contractState is ContractFailureState)
                    Text(
                      contractState.message,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  if (contractState is PartyAddedState)
                    const Text(
                      'Party Added successfully',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                      ),
                    )
                ],
              ))),
    );
  }
}
