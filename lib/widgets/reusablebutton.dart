// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/theam.dart';

// ignore: must_be_immutable
class ReusableBTN extends StatefulWidget {
  final String Title;
  double pading;
  bool loading;
  bool neeanimation;
  final VoidCallback onTap;
  ReusableBTN(
      {super.key,
      this.neeanimation = false,
      required this.pading,
      this.loading = false,
      required this.Title,
      required this.onTap});

  @override
  State<ReusableBTN> createState() => _ReusableBTNState();
}

class _ReusableBTNState extends State<ReusableBTN> {
  late ValueNotifier<bool> isTaskAdded;
  @override
  void initState() {
    super.initState();
    isTaskAdded = ValueNotifier(false);
  }

  @override
  Widget build(BuildContext context) {
    final theamchanger = Provider.of<Theamchanger>(context);

    return InkWell(
        onTap: () {
          setState(() {
            widget.onTap();
            isTaskAdded.value = !isTaskAdded.value;
          });
        },
        child: widget.neeanimation == true
            ? AnimatedContainer(
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 500),
                height: 64.h,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white60),
                    color: isTaskAdded.value
                        ? Colors.green
                        : theamchanger.btncolro,
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: widget.pading),
                    child: Center(
                      child: widget.loading
                          ? CircularProgressIndicator(
                              color: Colors.white60,
                            )
                          : Text(
                              isTaskAdded.value ? 'Task Added' : widget.Title,
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20.sp,
                                  color: theamchanger.textColor),
                            ),
                    ),
                  ),
                ),
              )
            : Container(
                height: 64.h,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white60),
                    color: theamchanger.btncolro,
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: widget.pading),
                    child: Center(
                      child: widget.loading
                          ? CircularProgressIndicator(
                              color: Colors.white60,
                            )
                          : Text(
                              widget.Title,
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20.sp,
                                  color: theamchanger.textColor),
                            ),
                    ),
                  ),
                ),
              ));
  }
}
