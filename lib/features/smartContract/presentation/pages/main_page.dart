import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/pages/data.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/pages/home_page.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int currentIndex = 0;

  Widget _buildBody(NavigationState navigationState) {
    if (navigationState is HomePageState) {
      return const HomePage();
    } else if (navigationState is ElectionState) {
      return const Data();
    } else if (navigationState is ResultState) {
      return const HomePage();
    } else if (navigationState is SettingState) {
      return const HomePage();
    } else if (navigationState is VoterState) {
      return const HomePage();
    } else {
      return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigationState = ref.watch(navigationProvider);
    double refWidth = 416;
    final width = MediaQuery.of(context).size.width;
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: navigationState.title != null
                ? AppBar(
                    centerTitle: true,
                    title: Text(
                      navigationState.title!,
                      style: TextStyle(
                        fontSize: 24 * width / refWidth,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 158, 154, 154),
                      ),
                    ),
                    bottom: currentIndex == 1
                        ? const TabBar(tabs: [
                            Tab(
                              text: 'Add Party',
                            ),
                            Tab(
                              text: 'Add State',
                            ),
                            Tab(
                              text: 'Add Rep',
                            ),
                          ])
                        : null,
                    actions: currentIndex == 0
                        ? [
                            Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50)),
                                child: Image.asset(
                                  "assets/images/logo.png",
                                  fit: BoxFit.contain,
                                ))
                          ]
                        : null,
                  )
                : null,
            drawer: currentIndex == 0 ? const Drawer() : null,
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.add_box_sharp), label: "Election"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.input), label: "Voter"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.output), label: "Result"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: "Settings"),
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
                ref.read(navigationProvider.notifier).changeState(value);
              },
            ),
            body: SafeArea(child: _buildBody(navigationState))));
  }
}
