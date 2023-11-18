// ignore_for_file: prefer_const_constructors

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/utils/toast.dart';
import 'package:to_do_app/widgets/reusablebutton.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _titleFocusNode = FocusNode();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController DiscriptionContoller = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _selectedDate = DateTime.now();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('post');
  void _pickUserDueDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffff725e),
          automaticallyImplyLeading: false,
          title: Text('Post Screen'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        focusNode: _titleFocusNode,
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
                      SizedBox(height: 20),
                      TextFormField(
                        focusNode: _titleFocusNode,
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
                      TextFormField(
                        focusNode: _titleFocusNode,
                        onTap: () {
                          _pickUserDueDate();
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          // ignore: unnecessary_null_comparison
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
                      Text('Due time', style: TextStyle(color: Colors.green)),
                      TextFormField(
                        focusNode: _titleFocusNode,
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
              ReusableBTN(
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
                      DateFormat('yyyy-MM-dd').format(_selectedDate);
                  String formattedTime = _selectedTime.format(context);
                  String id = DateTime.now().microsecondsSinceEpoch.toString();
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
            ],
          ),
        ),
      ),
    );
  }
}
