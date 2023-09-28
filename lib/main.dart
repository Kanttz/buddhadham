// ignore_for_file: must_be_immutable

import 'package:buddhadham/utils/appcolors.dart';
import 'package:buddhadham/views/screenForRead.dart';
import 'package:buddhadham/views/searchScreen.dart';
import 'package:buddhadham/views/about.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(BuddhadhamApp());
}

class BuddhadhamApp extends StatelessWidget {
  BuddhadhamApp({Key? key}) : super(key: key);
  MaterialColor primary_color = AppColors().primarAppColor;

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        color: Colors.black,
        title: 'BuddhadhamApp',
        theme: ThemeData(
          primarySwatch: primary_color,
        ),
        home: MainScreen(),
      );
    });
  }
}

//-------------------
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainWidget()),
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset(
          'assets/images/cover.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  int _selectedIndex = 0;
  late int initialPage; // Declare a variable to hold the last page index
  late int initialPageSearch; // For the search screen
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      initialPage = prefs.getInt('last_page') ?? 1;
      initialPageSearch = prefs.getInt('last_page_search') ?? 1;
      setState(() {
        isInitialized = true;
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _widgetOptions() {
    if (!isInitialized) {
      return <Widget>[SizedBox.shrink(), SizedBox.shrink(), SizedBox.shrink()];
    }
    return <Widget>[
      ReadScreen(
        initialPage: initialPage,
      ),
      SearchScreen(), // Add initialPage: initialPageSearch, if needed
      AboutScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: GoogleFonts.sarabun(),
        unselectedLabelStyle: GoogleFonts.sarabun(),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.book),
            label: 'อ่าน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'ค้นหา',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'เกี่ยวกับ',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors().textColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        backgroundColor: AppColors().primaryColor,
      ),
    );
  }
}
