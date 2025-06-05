import 'package:blockchain_based_national_election_admin_app/core/widgets/gradient_button.dart';
import 'package:blockchain_based_national_election_admin_app/core/widgets/textfield.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/provider.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/provider_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransferOwnershipPage extends ConsumerStatefulWidget {
  const TransferOwnershipPage({super.key});

  @override
  ConsumerState<TransferOwnershipPage> createState() =>
      _TransferOwnershipPageState();
}

class _TransferOwnershipPageState extends ConsumerState<TransferOwnershipPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  bool _awareOfConsequences = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final contractState = ref.watch(contractProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.08,
                    vertical: height * 0.06,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          'Transfer Ownership Rights',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: height * 0.04),
                        CustomTextField(
                          controller: _addressController,
                          labelText: 'New Owner Address',
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid address';
                            }
                            if (!RegExp(r'^0x[a-fA-F0-9]{40}$')
                                .hasMatch(value)) {
                              return 'Invalid Ethereum address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: height * 0.02),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: const Text(
                            "⚠️ Warning: After transferring ownership, you will no longer be able to perform any admin actions such as adding, deleting, or configuring elections. This action is irreversible.",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Row(
                          children: [
                            Checkbox(
                              value: _awareOfConsequences,
                              onChanged: (value) {
                                setState(() {
                                  _awareOfConsequences = value ?? false;
                                });
                              },
                            ),
                            const Expanded(
                              child: Text(
                                "I understand the consequences of transferring ownership.",
                                style: TextStyle(fontSize: 14),
                              ),
                            )
                          ],
                        ),
                        const Spacer(),
                        GradientButton(
                            text: contractState is TransferingOwnershipState
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : const Text('Submit'),
                            onPress: _awareOfConsequences
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      final newOwner =
                                          _addressController.text.trim();
                                      ref
                                          .read(contractProvider.notifier)
                                          .transferOwnership(newOwner);
                                    }
                                  }
                                : () {}),
                        SizedBox(height: height * 0.02),
                        if (contractState is OwnershipTransferedState)
                          const Text('Ownership transferred successfully!'),
                        if (contractState is OwnershipTransferFailureState)
                          Text(contractState.message,
                              style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
