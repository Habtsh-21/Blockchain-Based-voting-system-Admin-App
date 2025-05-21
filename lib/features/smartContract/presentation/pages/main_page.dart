import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/pages/data.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/pages/home_page.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/pages/registry.dart';
import 'package:blockchain_based_national_election_admin_app/features/smartContract/presentation/provider/provider.dart';
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
      ref.read(contractProvider.notifier).initialize();
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
    } else if (currentIndex == 4) {
      currentPage = const HomePage();
    } else {
      currentPage = const HomePage();
    }
  }

  List<Widget> pages = const [
    HomePage(),
    Data(),
    Registry(),
    HomePage(),
    HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    double refWidth = 416;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_box_sharp), label: "Election"),
            BottomNavigationBarItem(icon: Icon(Icons.input), label: "Registry"),
            BottomNavigationBarItem(icon: Icon(Icons.output), label: "Result"),
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
            setState(() {
              _buildBody();
            });
          },
        ),
        body: IndexedStack(
          index: currentIndex,
          children: pages,
        ));
  }
}
