import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stopwatch_app/fonts/custom_icons_icons.dart';
import 'package:stopwatch_app/stopwatchscreen.dart';
import 'package:stopwatch_app/timerscreen.dart';

void main() {
  runApp(const StopWatchApp());
}

class StopWatchApp extends StatefulWidget {
  const StopWatchApp({Key? key}) : super(key: key);

  @override
  State<StopWatchApp> createState() => _StopWatchAppState();
}

class _StopWatchAppState extends State<StopWatchApp> {
  int _selectedIndex = 0;
  late PageController _pageController;
  static const List<Widget> _pages = [
    StopWatchScreen(),
    TimerScreen(),
  ];
  static const List<String> _pageNames = ['Stopwatch', 'Timer'];
  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _pageNames[_selectedIndex],
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            _pageNames[_selectedIndex],
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings),
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: SafeArea(
          child: PageView(
            children: _pages,
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).colorScheme.primary,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _pageController.jumpToPage(_selectedIndex);
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CustomIcons.timer),
              label: 'Stopwatch',
            ),
            BottomNavigationBarItem(
              icon: Icon(CustomIcons.stopwatch),
              label: 'Timer',
            ),
          ],
        ),
      ),
    );
  }
}
