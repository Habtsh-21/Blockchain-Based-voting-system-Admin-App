import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/state_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/provider.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/provider_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatePage extends ConsumerStatefulWidget {
  const StatePage({super.key});

  @override
  ConsumerState<StatePage> createState() => _StatePageState();
}

class _StatePageState extends ConsumerState<StatePage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    ContractProviderState contractState = ref.watch(contractProvider);
    List<StateModel>? stateList =
        ref.read(contractProvider.notifier).getStates();
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: width * 0.05, vertical: height * 0.02),
        child: stateList != null
            ? ListView.builder(
                itemCount: stateList.length,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                itemBuilder: (BuildContext context, int index) {
                  final state = stateList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      title: Text(
                        state.stateName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text("ID: ${state.stateId}"),
                      trailing: contractState is PartyDeletingState
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : IconButton(
                              icon: const Icon(Icons.delete_forever,
                                  color: Colors.red),
                              onPressed: () async {
                                await ref
                                    .read(contractProvider.notifier)
                                    .deleteParty(state.stateId);
                              },
                            ),
                    ),
                  );
                },
              )
            : const Center(
                child: Text('Data is not Loaded. please Refresh it'),
              ));
  }
}
