import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/widgets/party.dart';
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
      Party(),
      Center(child: Text('Profile Content')),
      Center(child: Text('Settings Content')),
    ]);
  }
}
