import 'dart:io';

import 'package:blockchain_based_national_election_admin_app/core/widgets/gradient_button.dart';
import 'package:blockchain_based_national_election_admin_app/core/widgets/textfield.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/provider.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/provider_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Party extends ConsumerStatefulWidget {
  const Party({super.key});

  @override
  ConsumerState<Party> createState() => _PartyState();
}

class _PartyState extends ConsumerState<Party> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final idController = TextEditingController();
  late String? symbol;

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

  Future<String?> onTap() async {
    if (pickedFile == null) return null;
    final fileName = basename(pickedFile!.path);
    final mimeType = lookupMimeType(_image!.path);
    final storage = Supabase.instance.client.storage;
    final bucket = storage.from('image');

    final response = await bucket.uploadBinary(
      fileName,
      await _image!.readAsBytes(),
      fileOptions: FileOptions(
        contentType: mimeType,
        upsert: true,
      ),
    );
    print(response);
    final String publicUrl = bucket.getPublicUrl(fileName);
    return publicUrl;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    ContractProviderState contractProviderState = ref.watch(contractProvider);
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
                        String? publicUrl = await onTap();
                        int? id = int.tryParse(idController.text);
                        if (publicUrl != null && id != null) {
                          ref
                              .read(contractProvider.notifier)
                              .addParty(nameController.text, publicUrl, id);
                        }
                      }
                      else{
                        print ('something wrong');
                      }
                    },
                    text: contractProviderState is PartyAddingState
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
                  if (contractProviderState is ContractFailureState)
                    Text(
                      contractProviderState.message,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  if (contractProviderState is PartyAddedState)
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
