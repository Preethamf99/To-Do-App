// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/Screens/postscreen.dart';
import 'package:to_do_app/on%20boarding%20screens/on%20boarding%20Screen1.dart';
import 'package:to_do_app/on%20boarding%20screens/on%20boarding%20Screen2.dart';
import 'package:to_do_app/on%20boarding%20screens/on%20boarding%20Screen3.dart';
import 'package:to_do_app/on%20boarding%20screens/on%20boarding%20Screen4.dart';
import 'package:to_do_app/providers/pageprovider.dart';
import 'package:to_do_app/widgets/onboardbtn.dart';
import 'package:to_do_app/widgets/reusablebutton.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int pageIndex = 0;
  PageController _pageController = PageController(
    initialPage: 0,
    // Show only one page at a time
  );

  final List<Widget> _pages = [
    OnBoardScreen1(),
    OnBoardScreen2(),
    OnBoardScreen3(),
    OnBoardScreen4(),
  ];

  int currentPage = 0;
  bool firestpage = false;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  _storonboarding() async {
    int isviewed = 0;
    SharedPreferences prfs = await SharedPreferences.getInstance();
    await prfs.setInt('SplashScreen', isviewed);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OnBoardNotifier>(
        builder: (context, OnBoardNotifier, child) => Scaffold(
              body: Stack(
                children: [
                  PageView.builder(
                    physics: OnBoardNotifier.isLastPage
                        ? NeverScrollableScrollPhysics()
                        : AlwaysScrollableScrollPhysics(),

                    controller: _pageController,
                    itemCount: _pages.length,

                    onPageChanged: (value) {
                      setState(() {
                        pageIndex = value;
                        OnBoardNotifier.isLastPage = value == 3;
                      });
                    }, // Set the total number of pages
                    itemBuilder: (context, int index) => _pages[index],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 670),
                          child: currentPage == 3
                              ? Row()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: List.generate(
                                      4,
                                      (dotindicator) => Container(
                                            width: dotindicator == pageIndex
                                                ? 50
                                                : 25,
                                            height: 5,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: dotindicator == pageIndex
                                                    ? Color(0xFF000000)
                                                    : Color(0xFF4C4C4C)
                                                        .withOpacity(0.6)),
                                          )),
                                ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        currentPage == 3
                            ? Row(
                                children: [
                                  ReusableBTN(
                                    pading: 96,
                                    Title: 'Get Strated',
                                    onTap: () {
                                      debugPrint('this is printed');
                                      _storonboarding();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PostScreen(),
                                          ));
                                    },
                                  )
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  currentPage == 0
                                      ? SizedBox()
                                      : InkWell(
                                          onTap: () {
                                            if (currentPage > 0) {
                                              _pageController.previousPage(
                                                duration:
                                                    Duration(milliseconds: 500),
                                                curve: Curves.easeIn,
                                              );
                                            }
                                          },
                                          child: OnBoardButton(
                                            needtext: true,
                                            btntext: 'Previous',
                                          ),
                                        ),
                                  // currentPage < _pages.length - 1
                                  // ?
                                  InkWell(
                                    onTap: () {
                                      _pageController.nextPage(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeIn,
                                      );
                                    },
                                    child: OnBoardButton(
                                      btntext: 'Next',
                                      needtext: true,
                                    ),
                                  )
                                ],
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}
