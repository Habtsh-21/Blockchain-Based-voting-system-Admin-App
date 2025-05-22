import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/widgets/add_party.dart';
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Election"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Add Party"),
              Tab(text: "Add State"),
              Tab(text: "Add Rep"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AddParty(),
            AddState(),
           
          ],
        ),
      ),
    );
  }
}
