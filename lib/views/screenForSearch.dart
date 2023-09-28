import 'package:buddhadham/models/appTextSetting.dart';
import 'package:buddhadham/models/section.dart';
import 'package:buddhadham/utils/appcolors.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
// import 'package:zoom_widget/zoom_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadScreenForSearch extends StatefulWidget {
  final int initialPage;
  final String searchText;
  const ReadScreenForSearch(
      {Key? key, required this.initialPage, required this.searchText})
      : super(key: key);

  @override
  State<ReadScreenForSearch> createState() => _ReadScreenForSearchState();
}

class _ReadScreenForSearchState extends State<ReadScreenForSearch> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final TextEditingController searchTextController = TextEditingController();
  late Future<List<String>> getDataTextListFuture;
  double numAllPage = 2;
  PageController _pageController = PageController(viewportFraction: 1);
  final TextEditingController _controllerTextField = TextEditingController();

  int indexA = 0;

  @override
  void initState() {
    super.initState();
    // Load the last page from shared preferences
    SharedPreferences.getInstance().then((prefs) {
      int lastPage = prefs.getInt('last_page_search') ?? widget.initialPage;
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

  // This function retrieves the list of all text sections
  Future<List<String>>? getData() async {
    try {
      List<String>? listData = await Section.listAllText;
      setState(() {
        numAllPage = listData.length.toDouble();
      });
      return listData;
    } catch (e) {
      // Handle the exception or display an error message
      return [];
    }
  }

  int currentPageIndex = 0; // Add a variable to track the current page index

  Widget expandTextFont() {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 30, right: 30),
      child: Align(
        alignment: Alignment.topCenter,
        child: Card(
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
                max: MediaQuery.of(context).textScaleFactor * 100.0,
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
                            if (AppTextSetting.APP_FONTSIZE_READ_TABLET == 10) {
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
              //------------
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
                // label: AppTextSetting.INDEX_PAGE.toInt().toString(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
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
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
                              } else {
                                // Handle invalid input, such as displaying an error message.
                              }
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().backgroundColor,
      key: _scaffoldKey,
      endDrawer: expandTextFont(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors().textColor,
          ),
        ),
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
                    prefs.setInt('last_page_search', index + 1);
                  });
                });
              },
              itemBuilder: (BuildContext context, int index) {
                final escapedSearchText = RegExp.escape(widget.searchText);
                final regex = RegExp(escapedSearchText, caseSensitive: false);

                String htmlContent = snapshot.data![index];
                htmlContent = htmlContent.replaceAll('<mark>', '');
                htmlContent = htmlContent.replaceAll('</mark>', '');

                bool insideTag = false;
                StringBuffer newHtmlContent = StringBuffer();

                for (int i = 0; i < htmlContent.length; ++i) {
                  if (htmlContent[i] == '<') {
                    insideTag = true;
                  }

                  if (!insideTag) {
                    String substring = htmlContent.substring(i);
                    Match? match = regex.firstMatch(substring);

                    if (match != null && match.start == 0) {
                      newHtmlContent.write('<mark>');
                      newHtmlContent.write(match.group(0));
                      newHtmlContent.write('</mark>');
                      i += match.group(0)!.length - 1;
                      continue;
                    }
                  }

                  newHtmlContent.write(htmlContent[i]);

                  if (htmlContent[i] == '>') {
                    insideTag = false;
                  }
                }

                snapshot.data![index] = newHtmlContent.toString();

                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 10,
                          top: 5,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Wrap(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.025,
                                  right:
                                      MediaQuery.of(context).size.width * 0.025,
                                ),
                                child: Align(
                                  alignment: Alignment.topRight,
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
