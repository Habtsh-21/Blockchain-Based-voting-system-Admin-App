import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/widgets/add_party.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/widgets/add_rep.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/widgets/add_state.dart';
import 'package:flutter/material.dart';

class Data extends StatefulWidget {
  const Data({super.key});

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  @override
  Widget build(BuildContext context) {
    return const TabBarView(children: [
      AddParty(),
      AddState(),
      AddRepresentative(),
    ]);
  }
}
