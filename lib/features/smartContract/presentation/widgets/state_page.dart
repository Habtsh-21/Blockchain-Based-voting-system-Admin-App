import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/state_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/provider.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/provider_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/quickalert.dart';

class StatePage extends ConsumerStatefulWidget {
  const StatePage({super.key});

  @override
  ConsumerState<StatePage> createState() => _StatePageState();
}

class _StatePageState extends ConsumerState<StatePage> {
  List<StateModel>? stateList;
  ContractProviderState? _previousState;
  int? currentDeletingState;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    ContractProviderState contractState = ref.watch(contractProvider);
    stateList = ref.read(contractProvider.notifier).getStates();

    if (_previousState != contractState && contractState is StateDeletedState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Success!',
          textColor: Colors.black,
          text: 'trxHash:${contractState.message}',
          borderRadius: 0,
          barrierColor: Colors.black.withOpacity(0.2),
        );
        ref.read(contractProvider.notifier).resetState();
      });
    } else if (_previousState != contractState &&
        contractState is StateDeleteFailureState) {
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
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: width * 0.05, vertical: height * 0.02),
        child: stateList != null
            ? ListView.builder(
                itemCount: stateList!.length,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                itemBuilder: (BuildContext context, int index) {
                  final state = stateList![index];
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
                      trailing: contractState is StateDeletingState && currentDeletingState == state.stateId
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : IconButton(
                              icon: const Icon(Icons.delete_forever,
                                  color: Colors.red),
                              onPressed: () async {
                                currentDeletingState = state.stateId;
                                await ref
                                    .read(contractProvider.notifier)
                                    .deleteState(state.stateId);
                              },
                            ),
                    ),
                  );
                },
              )
            : contractState is StateFetchingState
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const Center(child: Text('Data is not Loaded, Refresh it.')));
  }
}
