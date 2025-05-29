import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/party_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/provider.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/provider_state.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/widgets/detail_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/quickalert.dart';

class PartyPage extends ConsumerStatefulWidget {
  const PartyPage({super.key});

  @override
  ConsumerState<PartyPage> createState() => _PartyPageState();
}

class _PartyPageState extends ConsumerState<PartyPage> {
  List<PartyModel>? partyList;
  ContractProviderState? _previousState;
  int? currentDeletingParty;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    ContractProviderState contractState = ref.watch(contractProvider);
    partyList = ref.read(contractProvider.notifier).getParties();

    if (_previousState != contractState && contractState is PartyDeletedState) {
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
        contractState is PartyDeleteFailureState) {
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
        child: partyList != null
            ? ListView.builder(
                itemCount: partyList!.length,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                itemBuilder: (BuildContext context, int index) {
                  final party = partyList![index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      leading: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: party.partySymbol,
                          placeholder: (context, url) => Image.asset(
                              'assets/images/placeholder.png',
                              width: 50,
                              height: 50),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error, size: 50),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        party.partyName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ID: ${party.partyId}"),
                          Text(
                            "Total Votes: ${party.votes}",
                            style: const TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      trailing: contractState is PartyDeletingState && currentDeletingParty == party.partyId
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : IconButton(
                              icon: const Icon(Icons.delete_forever,
                                  color: Colors.red),
                              onPressed: () async {
                                currentDeletingParty = party.partyId;
                                await ref
                                    .read(contractProvider.notifier)
                                    .deleteParty(party.partyId);
                              },
                            ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(party: party),
                        ),
                      ),
                    ),
                  );
                },
              )
            : contractState is PartyFetchingState
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const Center(child: Text('Data is not Loaded, Refresh it.')));
  }
}
