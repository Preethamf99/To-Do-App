// ignore_for_file: prefer_const_constructors

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/providers/theam.dart';
import 'package:to_do_app/utils/toast.dart';
import 'package:to_do_app/widgets/reusablebutton.dart';

class AddPost extends StatefulWidget {
  AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titlecontroller = TextEditingController();
  TextEditingController DiscriptionContoller = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _selectedDate = DateTime.now();

  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('post');
  void _pickUserDueDate() {
    showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime(2020),
            lastDate: DateTime(2030))
        .then((date) {
      if (date == null) {
        return;
      }
      setState(() {
        _selectedDate = date;
      });
    });
  }

  void _pickUserDueTime() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((time) {
      if (time == null) {
        return;
      }
      setState(() {
        _selectedTime = time;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theamchanger = Provider.of<Theamchanger>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffff725e),
          automaticallyImplyLeading: false,
          title: Text('ADD Your Task'),
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Title',
                          style:
                              TextStyle(color: Color(0xffff725e), fontSize: 18),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        InkWell(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: TextFormField(
                            controller: titlecontroller,
                            decoration: InputDecoration(
                                hintText: 'Describe your task',
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Description',
                          style:
                              TextStyle(color: Color(0xffff725e), fontSize: 18),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TextFormField(
                          controller: DiscriptionContoller,
                          decoration: InputDecoration(
                              hintText: 'Describe your in Detail task',
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          ' ByDate',
                          style:
                              TextStyle(color: Color(0xffff725e), fontSize: 18),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TextFormField(
                          onTap: () {
                            _pickUserDueDate();
                          },
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: _selectedDate == null
                                ? 'Provide your due date'
                                : DateFormat.yMMMd()
                                    .format(_selectedDate)
                                    .toString(),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Time',
                          style:
                              TextStyle(color: Color(0xffff725e), fontSize: 18),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TextFormField(
                          onTap: () {
                            _pickUserDueTime();
                          },
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: _selectedTime == null
                                ? 'Provide your due time'
                                : _selectedTime.format(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                ReusableBTN(
                  neeanimation: true,
                  pading: 96,
                  Title: 'ADD TASK',
                  loading: loading,
                  onTap: () {
                    setState(() {
                      loading = true;
                    });
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.save();
                    }
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(_selectedDate);
                    String formattedTime = _selectedTime.format(context);
                    String id =
                        DateTime.now().microsecondsSinceEpoch.toString();
                    databaseRef.child(id).set({
                      'id': id,
                      'title': titlecontroller.text.toString(),
                      'discription': DiscriptionContoller.text.toString(),
                      'date': formattedDate,
                      'time': formattedTime
                    }).then((value) {
                      utils().tostmessage(
                          'Task:${titlecontroller.text.toString()} Added');
                      setState(() {
                        loading = false;
                      });
                    }).onError((error, stackTrace) {
                      utils().tostmessage(error.toString());
                      setState(() {
                        loading = false;
                      });
                    });
                  },
                ),
                // Container(
                //   color: Colors.black,
                //   alignment: Alignment.bottomRight,
                //   child: MaterialButton(
                //     child: Text(
                //       'ADD TASK',
                //       style: TextStyle(
                //           color: Colors.red,
                //           fontFamily: 'Lato',
                //           fontSize: 18,
                //           fontWeight: FontWeight.bold),
                //     ),
                //     onPressed: () {
                //       if (_formKey.currentState!.validate()) {
                //         _formKey.currentState?.save();
                //       }
                //       String formattedDate =
                //           DateFormat('yyyy-MM-dd').format(_selectedDate);
                //       String formattedTime = _selectedTime.format(context);
                //       databaseRef.child('1').set({
                //         'title': titlecontroller.text.toString(),
                //         'discription': DiscriptionContoller.text.toString(),
                //         'date': formattedDate,
                //         'time': formattedTime
                //       }).then((value) {
                //         utils().tostmessage(
                //             'Task:${titlecontroller.text.toString()} Added');
                //       }).onError((error, stackTrace) {
                //         utils().tostmessage(error.toString());
                //       });
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
