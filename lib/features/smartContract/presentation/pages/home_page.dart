import 'dart:async';

import 'package:blockchain_based_national_election_admin_app/features/auth/presentation/provider/provider.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/party_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/state_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/pages/transfer_ownership_page.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/provider.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/widgets/box_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<PartyModel>? partyList;
  List<StateModel>? stateList;
  late String _currentTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = _getFormattedTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        _currentTime = _getFormattedTime();
      });
    });
  }

  String _getFormattedTime() {
    final now = DateTime.now();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final totalUser = ref.read(authStateProvider.notifier).totalUsers;
    int noOfParties = ref.read(contractProvider.notifier).getTotalNoOfParties();
    int noOfStates = ref.read(contractProvider.notifier).getTotalNoOfStates();
    int totalVotes = ref.read(contractProvider.notifier).getTotalVote();

    return Scaffold(
      appBar:
          AppBar(centerTitle: true, title: const Text('DASHBOARD'), actions: [
        Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.contain,
            ))
      ]),
      drawer: buildDrawer(
        onLogout: () {
          ref.read(authStateProvider.notifier).logout();
        },
        transferOwnership: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const TransferOwnershipPage()));
        },
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
        ),
        physics: const ClampingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hello,Admin",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _currentTime,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 136, 135, 135),
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Overview',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              padding: const EdgeInsets.all(8),
              children: [
                Box1(
                  iconData: Icons.how_to_vote,
                    amount: totalUser,
                    text: 'VOTER'),
                Box1(
                  iconData: Icons.flag,
                    amount: noOfParties,
                    text: 'PARTIES'),
                Box1(
                    iconData: Icons.map,
                    amount: noOfStates,
                    text: 'STATES'),
                Box1(
                    iconData: Icons.how_to_reg,
                    amount: totalVotes,
                    text: 'TOTAL VOTES'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Drawer buildDrawer({
    required VoidCallback onLogout,
    required VoidCallback transferOwnership,
  }) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.zero,
          bottomRight: Radius.zero,
        ),
      ),
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 153, 11, 134),
            ),
            accountName: Row(
              children: [
                Text(
                  "Admin",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(width: 6),
                Icon(
                  Icons.add_moderator_outlined,
                  color: Colors.greenAccent,
                  size: 18,
                )
              ],
            ),
            accountEmail: Text(''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.transfer_within_a_station),
            title: const Text("Transfer Ownership"),
            onTap: transferOwnership,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: onLogout,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About App"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
