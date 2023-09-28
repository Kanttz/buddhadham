import 'package:buddhadham/models/appTextSetting.dart';
import 'package:buddhadham/models/section.dart';
import 'package:buddhadham/utils/appcolors.dart';
import 'package:buddhadham/views/screenImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
// import 'package:zoom_widget/zoom_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadScreen extends StatefulWidget {
  final int initialPage;
  const ReadScreen({Key? key, required this.initialPage}) : super(key: key);

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchTextController = TextEditingController();
  late Future<List<String>> getDataTextListFuture;
  double numAllPage = 2;
  PageController _pageController = PageController(viewportFraction: 1);
  final TextEditingController _controllerTextField = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load the last page from shared preferences
    SharedPreferences.getInstance().then((prefs) {
      int lastPage = prefs.getInt('last_page') ?? widget.initialPage;
      AppTextSetting.INDEX_PAGE = lastPage.toDouble();
      _pageController = PageController(initialPage: lastPage - 1);
    });
    getDataTextListFuture = getData()!;
  }

  @override
  void dispose() {
    _controllerTextField.dispose();
    super.dispose();
  }

  String thaiNumDigit(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const thai = ['๐', '๑', '๒', '๓', '๔', '๕', '๖', '๗', '๘', '๙'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], thai[i]);
    }

    return input;
  }

  Future<List<String>>? getData() async {
    try {
      List<String>? listData = await Section.listAllText;
      setState(() {
        numAllPage = listData.length.toDouble();
      });
      return listData;
    } catch (e) {
      return [];
    }
  }

  int currentPageIndex = 0;

  Widget expandTextFont() {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 30, right: 30),
      child: Align(
        alignment: Alignment.topCenter,
        child: Card(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    'ขนาดตัวอักษร',
                    style: GoogleFonts.sarabun(
                      fontSize: 18,
                      color: AppColors().readtextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Slider(
                  value: SizerUtil.deviceType == DeviceType.mobile
                      ? AppTextSetting.APP_FONTSIZE_READ
                      : AppTextSetting.APP_FONTSIZE_READ_TABLET,
                  onChanged: (double newValue) {
                    setState(() {
                      SizerUtil.deviceType == DeviceType.mobile
                          ? AppTextSetting.APP_FONTSIZE_READ = newValue
                          : AppTextSetting.APP_FONTSIZE_READ_TABLET = newValue;
                    });
                  },
                  divisions: 90,
                  min: 10.0,
                  max: MediaQuery.of(context).textScaleFactor * 40.0,
                  // label: AppTextSetting.APP_FONTSIZE_READ.toInt().toString(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (SizerUtil.deviceType == DeviceType.mobile) {
                              if (AppTextSetting.APP_FONTSIZE_READ == 10) {
                                AppTextSetting.APP_FONTSIZE_READ = 10;
                              } else {
                                AppTextSetting.APP_FONTSIZE_READ -= 1;
                              }
                            } else {
                              if (AppTextSetting.APP_FONTSIZE_READ_TABLET ==
                                  10) {
                                AppTextSetting.APP_FONTSIZE_READ_TABLET = 10;
                              } else {
                                AppTextSetting.APP_FONTSIZE_READ_TABLET -= 1;
                              }
                            }
                          });
                        },
                      ),
                      Text(
                        thaiNumDigit(
                          SizerUtil.deviceType == DeviceType.mobile
                              ? AppTextSetting.APP_FONTSIZE_READ
                                  .toInt()
                                  .toString()
                              : AppTextSetting.APP_FONTSIZE_READ_TABLET
                                  .toInt()
                                  .toString(),
                        ),
                        style: GoogleFonts.sarabun(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          color: AppColors().readtextColor,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            if (SizerUtil.deviceType == DeviceType.mobile) {
                              if (AppTextSetting.APP_FONTSIZE_READ == 100) {
                                AppTextSetting.APP_FONTSIZE_READ = 100;
                              } else {
                                AppTextSetting.APP_FONTSIZE_READ += 1;
                              }
                            } else {
                              if (AppTextSetting.APP_FONTSIZE_READ_TABLET ==
                                  100) {
                                AppTextSetting.APP_FONTSIZE_READ_TABLET = 100;
                              } else {
                                AppTextSetting.APP_FONTSIZE_READ_TABLET += 1;
                              }
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: const Divider(
                    color: Colors.black,
                    height: 20,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Text(
                        'หน้าที่ ${thaiNumDigit(AppTextSetting.INDEX_PAGE.toInt().toString())}',
                        style: GoogleFonts.sarabun(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Slider(
                  value: AppTextSetting.INDEX_PAGE,
                  onChanged: (double newValue) {
                    setState(() {
                      AppTextSetting.INDEX_PAGE = newValue;
                      _pageController
                          .jumpToPage(AppTextSetting.INDEX_PAGE.toInt());
                    });
                  },
                  divisions: (numAllPage - 1).toInt(),
                  min: 1.0,
                  max: 1300,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_left),
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                            textAlign: TextAlign.center,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            controller: _controllerTextField,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'ไปหน้าที่',
                            ),
                            onSubmitted: (String value) {
                              setState(() {
                                int? pageNumber = int.tryParse(value);
                                if (pageNumber != null && pageNumber >= 1) {
                                  AppTextSetting.INDEX_PAGE = pageNumber - 1;
                                  _pageController.jumpToPage(
                                      AppTextSetting.INDEX_PAGE.toInt());
                                  _controllerTextField.clear();
                                  Navigator.pop(context);
                                } else {}
                              });
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_right),
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().backgroundColor,
      key: _scaffoldKey,
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.65,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors().primaryColor),
              margin: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 60.0,
                          height: 60.0,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              'พุทธธรรม',
                              style: GoogleFonts.sarabun(
                                textStyle: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors().textColor,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              '(ฉบับปรับขยาย)',
                              style: GoogleFonts.sarabun(
                                textStyle: TextStyle(
                                  fontSize: 20,
                                  color: AppColors().textColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '~ สารบัญ ~',
                        style: GoogleFonts.sarabun(
                          fontSize: 20,
                          color: AppColors().textColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: AppColors().backgroundColor,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    //-------------------- ความนำ --------------------
                    ListTile(
                      title: Text(
                        'ความนำ', //thaiNumDigit((index + 1).toString())
                        style: GoogleFonts.sarabun(
                          fontSize: SizerUtil.deviceType == DeviceType.mobile
                              ? AppTextSetting.APP_FONTSIZE_READ + 1
                              : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                          color: AppColors().primaryColor,
                          fontWeight:
                              FontWeight.bold, // Default color for other pages
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex = 0; // Update the current page index
                        });
                        _pageController.jumpToPage(0);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- ภาค ๑ มัชเฌนธรรมเทศนา --------------------
                    ListTile(
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'ภาค ๑ มัชเฌนธรรมเทศนา', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๑ ขันธ์ ๕ --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๑ ขันธ์ ๕ ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              23; // Update the current page index
                        });
                        _pageController.jumpToPage(23);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๒ อายตนะ ๖  --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๒ อายตนะ ๖ ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              38; // Update the current page index
                        });
                        _pageController.jumpToPage(38);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๓ ไตรลักษณ์  --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๓ ไตรลักษณ์', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              73; // Update the current page index
                        });
                        _pageController.jumpToPage(73);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๔ ปฏิจจสมุปบาท  --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๔ ปฏิจจสมุปบาท', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              167; // Update the current page index
                        });
                        _pageController.jumpToPage(167);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๕ กรรม  --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๕ กรรม', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              250; // Update the current page index
                        });
                        _pageController.jumpToPage(250);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๖ วิชชา วิมุตติ วิสุทธิ สันติ นิพพาน  --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๖ วิชชา วิมุตติ วิสุทธิ สันติ นิพพาน', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              344; // Update the current page index
                        });
                        _pageController.jumpToPage(344);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๗ ประเภทและระดับ แห่งนิพพานและผู้บรรลุนิพพาน  --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๗ ประเภทและระดับ แห่งนิพพานและผู้บรรลุนิพพาน', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              406; // Update the current page index
                        });
                        _pageController.jumpToPage(406);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๘ ข้อควรทราบเพิ่มเติม เพื่อเสริมความเข้าใจ  --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๘ ข้อควรทราบเพิ่มเติม เพื่อเสริมความเข้าใจ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              448; // Update the current page index
                        });
                        _pageController.jumpToPage(448);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๙ หลักการสำคัญ ของการบรรลุนิพพาน   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๙ หลักการสำคัญ ของการบรรลุนิพพาน ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              464; // Update the current page index
                        });
                        _pageController.jumpToPage(464);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๑๐ บทสรุป เรื่องเกี่ยวกับนิพพาน  --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๑๐ บทสรุป เรื่องเกี่ยวกับนิพพาน', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              510; // Update the current page index
                        });
                        _pageController.jumpToPage(510);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- ภาค ๒ มัชฌิมาปฏิปทา  --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'ภาค ๒ มัชฌิมาปฏิปทา', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              534; // Update the current page index
                        });
                        _pageController.jumpToPage(534);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๑๑ บทนำ ของมัชฌิมาปฏิปทา   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๑๑ บทนำ ของมัชฌิมาปฏิปทา ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              552; // Update the current page index
                        });
                        _pageController.jumpToPage(552);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๑๒ บุพภาคของการศึกษา ๑: ปรโตโฆสะที่ดี = กัลยาณมิตร    --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๑๒ บุพภาคของการศึกษา ๑: ปรโตโฆสะที่ดี = กัลยาณมิตร  ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              613; // Update the current page index
                        });
                        _pageController.jumpToPage(613);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๑๓ บุพภาคของการศึกษา ๒: โยนิโสมนสิการ     --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๑๓ บุพภาคของการศึกษา ๒: โยนิโสมนสิการ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              661; // Update the current page index
                        });
                        _pageController.jumpToPage(661);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- ๑๔ องค์ประกอบของมัชฌิมาปฏิปทา ๑: หมวดปัญญา      --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๑๔ องค์ประกอบของมัชฌิมาปฏิปทา ๑: หมวดปัญญา', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              745; // Update the current page index
                        });
                        _pageController.jumpToPage(745);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๑๕ องค์ประกอบของมัชฌิมาปฏิปทา ๒: หมวดศีล      --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '    บทที่ ๑๕ องค์ประกอบของมัชฌิมาปฏิปทา ๒: หมวดศีล', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              769; // Update the current page index
                        });
                        _pageController.jumpToPage(769);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๑๖ องค์ประกอบของมัชฌิมาปฏิปทา ๓: หมวดสมาธิ      --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '    บทที่ ๑๖ องค์ประกอบของมัชฌิมาปฏิปทา ๓: หมวดสมาธิ ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              817; // Update the current page index
                        });
                        _pageController.jumpToPage(817);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๑๗ บทสรุป: อริยสัจ ๔      --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '    บทที่ ๑๗ บทสรุป: อริยสัจ ๔ ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              914; // Update the current page index
                        });
                        _pageController.jumpToPage(914);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- ภาค ๓ อารยธรรมวิถี      --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'ภาค ๓ อารยธรรมวิถี ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              949; // Update the current page index
                        });
                        _pageController.jumpToPage(949);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๑๘ บทความประกอบที่ ๑:   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๑๘ บทความประกอบที่ ๑: ชีวิตและคุณธรรมพื้นฐานของอารยชน ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              951; // Update the current page index
                        });
                        _pageController.jumpToPage(951);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๑๙ บทความประกอบที่ ๒:   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๑๙ บทความประกอบที่ ๒: ศีลกับเจตนารมณ์ทางสังคม ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              984; // Update the current page index
                        });
                        _pageController.jumpToPage(984);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๒๐ บทความประกอบที่ ๓:   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๒๐ บทความประกอบที่ ๓: เรื่องเหนือสามัญวิสัย: ปาฏิหาริย์ – เทวดา ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              1011; // Update the current page index
                        });
                        _pageController.jumpToPage(1011);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๒๑ บทความประกอบที่ ๔:   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๒๑ บทความประกอบที่ ๔: ปัญหาเกี่ยวกับแรงจูงใจ ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              1042; // Update the current page index
                        });
                        _pageController.jumpToPage(1042);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๒๒ บทความประกอบที่ ๕:   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๒๒ บทความประกอบที่ ๕: ความสุข ๑: ฉบับแบบแผน ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              1095; // Update the current page index
                        });
                        _pageController.jumpToPage(1095);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๒๓ บทความประกอบที่ ๖:   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๒๓ บทความประกอบที่ ๖: ความสุข ๒: ฉบับประมวลความ ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              1143; // Update the current page index
                        });
                        _pageController.jumpToPage(1143);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บรรณาณุกรม   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'บรรณาณุกรม', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              1212; // Update the current page index
                        });
                        _pageController.jumpToPage(1212);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บันทึกของผู้เขียน   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'บันทึกของผู้เขียน', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              1218; // Update the current page index
                        });
                        _pageController.jumpToPage(1218);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บันทึกการจัดทำข้อมูล   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'บันทึกการจัดทำข้อมูล', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              1227; // Update the current page index
                        });
                        _pageController.jumpToPage(1227);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บันทึกไว้ระลึก   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'บันทึกไว้ระลึก', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              1229; // Update the current page index
                        });
                        _pageController.jumpToPage(1229);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บันทึก (เรื่องทุนพิมพ์)   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'บันทึก (เรื่องทุนพิมพ์)', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? AppTextSetting.APP_FONTSIZE_READ + 1
                                : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              1260; // Update the current page index
                        });
                        _pageController.jumpToPage(1260);
                      },
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      endDrawer: expandTextFont(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors().textColor),
        toolbarHeight: 75,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'พุทธธรรม',
                style: GoogleFonts.sarabun(
                  textStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: AppColors().textColor,
                  ),
                ),
              ),
              TextSpan(
                text: ' (ฉบับปรับขยาย)',
                style: GoogleFonts.sarabun(
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: AppColors().textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.035,
            ),
            child: GestureDetector(
              onTap: () => _scaffoldKey.currentState!.openEndDrawer(),
              child: Icon(
                FontAwesomeIcons.bookOpen,
                // size: 35,
                color: AppColors().textColor,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: getDataTextListFuture,
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return PageView.builder(
              itemCount: snapshot.data!.length,
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  AppTextSetting.INDEX_PAGE = index.toDouble() + 1;
                  // Save the current page index to shared preferences
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.setInt('last_page', index + 1);
                  });
                });
              },
              itemBuilder: (BuildContext context, int index) {
                snapshot.data![index] =
                    snapshot.data![index].replaceAll('<mark>', '');
                snapshot.data![index] =
                    snapshot.data![index].replaceAll('</mark>', '');
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.all(1),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 10,
                          top: 5,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.025,
                                  right:
                                      MediaQuery.of(context).size.width * 0.025,
                                ),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'หน้า ' +
                                        thaiNumDigit((index + 1).toString()),
                                    style: GoogleFonts.sarabun(
                                      fontWeight: FontWeight.w500,
                                      fontSize: SizerUtil.deviceType ==
                                              DeviceType.mobile
                                          ? AppTextSetting.APP_FONTSIZE_READ + 2
                                          : AppTextSetting
                                                  .APP_FONTSIZE_READ_TABLET +
                                              2,
                                      color: AppColors().readtextColor,
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.grey[400],
                                height: 20,
                                thickness: 1,
                                indent:
                                    MediaQuery.of(context).size.width * 0.025,
                                endIndent:
                                    MediaQuery.of(context).size.width * 0.025,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.025,
                                  right:
                                      MediaQuery.of(context).size.width * 0.025,
                                ),
                                child: SelectionArea(
                                  child: HtmlWidget(
                                    snapshot.data![index],
                                    textStyle: GoogleFonts.sarabun(
                                      fontSize: SizerUtil.deviceType ==
                                              DeviceType.mobile
                                          ? AppTextSetting.APP_FONTSIZE_READ
                                          : AppTextSetting
                                              .APP_FONTSIZE_READ_TABLET,
                                      color: AppColors().readtextColor,
                                      height: 1.7,
                                    ),
                                    onTapImage: (p0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ScreenImage(
                                            image: p0.alt,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
