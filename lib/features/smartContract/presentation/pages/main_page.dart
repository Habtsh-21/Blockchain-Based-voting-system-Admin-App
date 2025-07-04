import 'package:blockchain_based_national_election_admin_app/features/auth/presentation/provider/provider.dart';
import 'package:blockchain_based_national_election_admin_app/features/auth/presentation/provider/provider_state.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/pages/control.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/pages/register.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/pages/home_page.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/pages/record.dart';
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
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // if (mounted) {
      await ref.read(contractProvider.notifier).fatchAllData();
      await ref.read(authStateProvider.notifier).userData();
      // }
    });
  }

  List<Widget> pages = const [
    HomePage(),
    Register(),
    Record(),
    Control(),
  ];

  @override
  Widget build(BuildContext context) {
    double refWidth = 416;
    final width = MediaQuery.of(context).size.width;
    ContractProviderState contractState = ref.watch(contractProvider);
    AuthProviderState authState = ref.watch(authStateProvider);

    if (contractState is ContractAllDataFetchingState ||
        authState is UsersdataLoadingState) {
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
    if (contractState is ContractAllDataFailureState ||
        authState is UsersdataFailureState) {
      return Scaffold(
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.15),
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 72,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Oops! Something went wrong.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'We couldn’t load the election data.\nPlease check your internet connection.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () {
                      if (contractState is ContractAllDataFailureState) {
                        print('block');
                        ref.read(contractProvider.notifier).fatchAllData();
                      }
                      if (authState is UsersdataFailureState) {
                        print('supa');
                        ref.read(authStateProvider.notifier).userData();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 14.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 97, 7, 149),
                            Color.fromARGB(255, 152, 1, 114),
                          ],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Try Again',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_box_sharp), label: "Register"),
            BottomNavigationBarItem(icon: Icon(Icons.input), label: "Record"),
            BottomNavigationBarItem(icon: Icon(Icons.output), label: "Control"),
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
            setState(() {
              currentIndex = value;
            });
          },
        ),
        body: IndexedStack(
          index: currentIndex,
          children: pages,
        ));
  }
}
