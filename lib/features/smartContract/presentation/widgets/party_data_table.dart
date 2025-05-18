import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/party_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PartyDataTable extends ConsumerStatefulWidget {
  const PartyDataTable({super.key, required this.partyList, this.noToList});

  final List<PartyModel>? partyList;
  final int? noToList;

  @override
  ConsumerState<PartyDataTable> createState() => _DisplayTableState();
}

class _DisplayTableState extends ConsumerState<PartyDataTable> {
  int counter = 0;

  @override
  void initState() async {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          widget.partyList == null
              ? const Text('There is no Data')
              : DataTable(
                  headingTextStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  columns: const [
                    DataColumn(
                        label: Text(
                      'Code',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text('Name',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('symbol',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('votes',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: widget.partyList!.take(5).map((party) {
                    return DataRow(cells: [
                      DataCell(Text('${party.partyId}')),
                      DataCell(Text(party.partyName)),
                      DataCell(Text(party.partySymbol)),
                      DataCell(Text('${party.votes}')),
                    ]);
                  }).toList(),
                ),
        ],
      ),
    );
  }
}
