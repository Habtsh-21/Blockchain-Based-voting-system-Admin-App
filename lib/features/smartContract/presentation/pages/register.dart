import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/widgets/add_party.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/widgets/add_state.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Add Entry"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Add Party"),
              Tab(text: "Add State"),
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
