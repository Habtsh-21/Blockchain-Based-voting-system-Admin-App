import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/party_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/rep_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/data/model/state_model.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/provider.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/widgets/box_widget.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/widgets/party_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<PartyModel>? partyList;
  List<StateModel>? stateList;
  List<RepresentativeModel>? repList;

  @override
  void initState() {
    super.initState();

  }
  // void init() async{
  //     partyList = await ref.read(contractProvider.notifier).getParties();
  //     stateList = await ref.read(contractProvider.notifier).getStates();
  //     repList = await ref.read(contractProvider.notifier).getReps();
  // }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    //  init();
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.05,
      ),
      physics: const ClampingScrollPhysics(),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello,Admin",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Jan 12,2025",
                  style: TextStyle(
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
            children: const [
              Box1(
                  iconData: Icons.people_sharp,
                  amount: 12000000,
                  text: 'VOTER'),
              Box1(
                  iconData: Icons.group_work_outlined,
                  amount: 112,
                  text: 'PARTIES'),
              Box1(iconData: Icons.countertops, amount: 85, text: 'STATES'),
              Box1(
                  iconData: Icons.person, amount: 1450, text: 'REPRESENTATIVE'),
            ],
          ),
        ),
        // Container(
        //     padding: const EdgeInsets.all(8),
        //     decoration: BoxDecoration(boxShadow: [
        //       BoxShadow(
        //         color: Colors.grey.withOpacity(0.5),
        //         spreadRadius: 2,
        //         blurRadius: 5,
        //         offset: const Offset(0, 3),
        //       ),
        //     ]),
        //     child: Column(
        //       children: [
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             const Text(
        //               'Parties',
        //               style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //             MaterialButton(
        //               onPressed: () {},
        //               shape: const BeveledRectangleBorder(
        //                   side: BorderSide(width: 0.2)),
        //               child: const Text('Add New'),
        //             )
        //           ],
        //         ),
        //         PartyDataTable(partyList: partyList),
        //         const SizedBox(
        //           height: 16,
        //         ),
        //         TextButton(
        //             onPressed: () {},
        //             child: const Text('see all',
        //                 style: TextStyle(
        //                     fontWeight: FontWeight.bold, color: Colors.red))),
        //       ],
        //     )),
        // Container(
        //     padding: const EdgeInsets.all(8),
        //     decoration: BoxDecoration(boxShadow: [
        //       BoxShadow(
        //         color: Colors.grey.withOpacity(0.5),
        //         spreadRadius: 2,
        //         blurRadius: 5,
        //         offset: const Offset(0, 3),
        //       ),
        //     ]),
        //     child: Column(
        //       children: [
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             const Text(
        //               'States',
        //               style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //             MaterialButton(
        //               onPressed: () {},
        //               shape: const BeveledRectangleBorder(
        //                   side: BorderSide(width: 0.2)),
        //               child: const Text('Add New'),
        //             )
        //           ],
        //         ),
        //         PartyDataTable(partyList: partyList),
        //          const SizedBox(
        //     height: 16,
        //   ),
        //   TextButton(
        //       onPressed: () {},
        //       child: const Text('see all',
        //           style: TextStyle(
        //               fontWeight: FontWeight.bold, color: Colors.red))),
        //       ],
        //     )),
        //      Container(
        //     padding: const EdgeInsets.all(8),
        //     decoration: BoxDecoration(boxShadow: [
        //       BoxShadow(
        //         color: Colors.grey.withOpacity(0.5),
        //         spreadRadius: 2,
        //         blurRadius: 5,
        //         offset: const Offset(0, 3),
        //       ),
        //     ]),
        //     child: Column(
        //       children: [
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             const Text(
        //               'Representatives',
        //               style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //             MaterialButton(
        //               onPressed: () {},
        //               shape: const BeveledRectangleBorder(
        //                   side: BorderSide(width: 0.2)),
        //               child: const Text('Add New'),
        //             )
        //           ],
        //         ),
        //         PartyDataTable(partyList: partyList),
        //          const SizedBox(
        //     height: 16,
        //   ),
        //   TextButton(
        //       onPressed: () {},
        //       child: const Text('see all',
        //           style: TextStyle(
        //               fontWeight: FontWeight.bold, color: Colors.red))),
        //       ],
        //     )),
      ],
    );
  }
}
