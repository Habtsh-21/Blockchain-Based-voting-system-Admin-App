import 'package:blockchain_based_national_election_admin_app/core/widgets/gradient_button.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/pages/data.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/pages/home_page.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/pages/registry.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/provider.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/provider_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int currentIndex = 0;
  Widget currentPage = const HomePage();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(contractProvider.notifier).fatchAllData();
    });
    super.initState();
  }

  void _buildBody() {
    if (currentIndex == 0) {
      currentPage = const HomePage();
    } else if (currentIndex == 1) {
      currentPage = const Data();
    } else if (currentIndex == 2) {
      currentPage = const Registry();
    } else if (currentIndex == 3) {
      currentPage = const HomePage();
    }  else {
      currentPage = const HomePage();
    }
  }

  List<Widget> pages = const [
    HomePage(),
    Data(),
    Registry(),
    HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    double refWidth = 416;
    final width = MediaQuery.of(context).size.width;
    ContractProviderState contractState = ref.watch(contractProvider);

    if (contractState is ContractAllDataFatchingState) {
    return Scaffold(
  backgroundColor: Colors.transparent,
  body: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.fromARGB(255, 97, 7, 149),
          Color.fromARGB(255, 152, 1, 114),
        ],
      ),
    ),
    child: const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.how_to_vote,
            color: Colors.white,
            size: 72,
          ),
          SizedBox(height: 24),
          Text(
            'Loading Election Data...',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 24),
          CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
        ],
      ),
    ),
  ),
);


    }
    // if (contractState is ContractAllDataFatchedState) {
      return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_box_sharp), label: "Election"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.input), label: "Registry"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.output), label: "Control"),
            ],
            selectedItemColor: Colors.white,
            selectedFontSize: 16 * width / refWidth,
            unselectedItemColor: const Color.fromARGB(255, 167, 165, 165),
            unselectedFontSize: 14 * width / refWidth,
            selectedIconTheme: IconThemeData(
              size: 32 * width / refWidth,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
            unselectedIconTheme: IconThemeData(
                size: 30 * width / refWidth,
                color: const Color.fromARGB(255, 167, 165, 165)),
            currentIndex: currentIndex,
            backgroundColor: const Color.fromARGB(255, 153, 11, 134),
            onTap: (value) {
              currentIndex = value;
              setState(() {
                _buildBody();
              });
            },
          ),
          body: IndexedStack(
            index: currentIndex,
            children: pages,
          ));
    // } else if (contractState is ContractFailureState) {
    //   return Scaffold(
    //     backgroundColor: Colors.white,
    //     body: Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           Text(contractState.message),
    //           const SizedBox(height: 16,),
    //           GradientButton(
    //             onPress: () =>
    //                 ref.read(contractProvider.notifier).fatchAllData(),
    //             text: const Text('Refresh'),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // } else {
    //   return Scaffold(
    //     backgroundColor: Colors.white,
    //     body: Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           const Text('something  wrong'),
    //            const SizedBox(height: 16,),
    //           GradientButton(
    //             onPress: () =>
    //                 ref.read(contractProvider.notifier).fatchAllData(),
    //             text: const Text('Refresh'),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }
  }
}
