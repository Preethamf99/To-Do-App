// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';
import 'package:to_do_app/Screens/Settings.dart';

import 'package:to_do_app/Screens/addpostScreen.dart';
import 'package:to_do_app/Screens/searchscreen.dart';
import 'package:to_do_app/utils/toast.dart';
import 'package:to_do_app/widgets/shimmereffect.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final FocusNode _DialogTextFocusNode = FocusNode();
  final FocusNode _DialogFocusNode = FocusNode();
  TextEditingController editTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  final ref = FirebaseDatabase.instance.ref('post');

  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffff725e),
          automaticallyImplyLeading: false,
          title: Text('TO DO LIST'),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  SettingsBottomSheet(context);
                },
                icon: Icon(Icons.settings)),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchScreen()));
                },
                icon: Icon(Icons.search)),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream:
                    ref.onValue, // assuming 'ref' is your Firebase reference
                builder: (context, snapshot) {
                  // Check if the snapshot has data
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Data is still loading, show shimmer effect
                    return ListView.builder(
                      itemCount: 10, // Number of shimmer items you want to show
                      itemBuilder: (context, index) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: ShimmerWidget(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    // If we run into an error, display an error message
                    return Center(child: Text('Error loading data'));
                  } else {
                    // Data is loaded, show the FirebaseAnimatedList
                    return FirebaseAnimatedList(
                        query: ref,
                        itemBuilder: (context, snapshot, animation, index) {
                          final json = snapshot.value as Map<dynamic, dynamic>;
                          final title =
                              json['title']?.toString().toUpperCase() ?? '';
                          final description =
                              json['discription']?.toString() ?? '';
                          final id = snapshot.key; // This is the Firebase ID
                          final date = json['date']?.toString() ?? '';
                          final time = json['time']?.toString() ?? '';
                          return Card(
                            color: Color(0xFFF35843).withOpacity(0.95),
                            child: ListTile(
                              title: Text(
                                title,
                                style: TextStyle(
                                    color: Color(0xff263238),
                                    overflow: TextOverflow.ellipsis),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    description,
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Color(0xff263238)),
                                  ),
                                  Text(
                                    '$date at $time',
                                    style: TextStyle(color: Color(0xffE0E0E0)),
                                  ),
                                ],
                              ),
                              trailing: PopupMenuButton(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    showEditDialog(title, description,
                                        id.toString(), date, time);
                                  } else if (value == 'delete') {
                                    ref.child(id.toString()).remove();
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            ADDTaskbottomshet(context);
          },
          tooltip: 'Add a new item!',
        ),
      ),
    );
  }

  ADDTaskbottomshet(context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double bottomSheetHeight =
        screenHeight * 0.8; // 60% of the screen height
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (context) =>
            Container(height: bottomSheetHeight, child: AddPost()));
  }

  SettingsBottomSheet(context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double bottomSheetHeight =
        screenHeight * 0.4; // 60% of the screen height
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (context) =>
            Container(height: bottomSheetHeight, child: Settingscreen()));
  }

  Future<void> showEditDialog(String title, String description, String id,
      String selectedDateString, String selectedTimeString) async {
    editTitleController.text = title;
    descriptionController.text = description;
    dateController.text = selectedDateString;
    timeController.text = selectedTimeString;

    // Show the dialog
    return showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: AlertDialog(
          title: Text('Edit Task'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  focusNode: _DialogTextFocusNode,
                  controller: editTitleController,
                  decoration: InputDecoration(hintText: 'Title'),
                ),
                TextField(
                  focusNode: _DialogFocusNode,
                  controller: descriptionController,
                  decoration: InputDecoration(hintText: 'Description'),
                ),
                InkWell(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDateString.isNotEmpty
                          ? DateFormat('dd/MM/yyyy').parse(selectedDateString)
                          : DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        dateController.text =
                            DateFormat('dd/MM/yyyy').format(pickedDate);
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      focusNode: _DialogFocusNode,
                      controller: dateController,
                      decoration: InputDecoration(hintText: 'Due Date'),
                      readOnly:
                          true, // Set this to true to prevent keyboard from showing
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedTimeString.isNotEmpty
                          ? TimeOfDay.fromDateTime(
                              DateFormat('HH:mm').parse(selectedTimeString))
                          : TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        timeController.text = pickedTime.format(context);
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      focusNode: _DialogFocusNode,
                      controller: timeController,
                      decoration: InputDecoration(hintText: 'Due Time'),
                      readOnly:
                          true, // Set this to true to prevent keyboard from showing
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Update the database
                ref.child(id).update({
                  'title': editTitleController.text.trim(),
                  'discription': descriptionController.text.trim(),
                  'date': dateController.text.trim(),
                  'time': timeController.text.trim(),
                }).then((_) {
                  utils().tostmessage('Task updated successfully');
                  Navigator.of(context).pop(); // Close the dialog
                }).catchError((error) {
                  utils().tostmessage('Failed to update task: $error');
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
