// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:to_do_app/widgets/shimmereffect.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController SearchContoller = TextEditingController();
  final ref = FirebaseDatabase.instance.ref('post');
  bool isSearching = false;
  @override
  @override
  Widget build(BuildContext context) {
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
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: TextFormField(
                  controller: SearchContoller,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      isSearching = value.isNotEmpty;
                    });
                  },
                ),
              ),
              Expanded(
                child: isSearching
                    ? FirebaseAnimatedList(
                        defaultChild: ListView.builder(
                          itemCount:
                              10, // Number of shimmer items you want to show
                          itemBuilder: (context, index) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            period: Duration(seconds: 5),
                            child: ShimmerWidget(),
                          ),
                        ),
                        query: ref,
                        itemBuilder: (context, snapshot, animation, index) {
                          final title =
                              snapshot.child('title').value.toString();
                          if (SearchContoller.text.isEmpty) {
                            return SizedBox(); // Return an empty box if the search text is empty.
                          } else if (title
                              .toLowerCase()
                              .contains(SearchContoller.text.toLowerCase())) {
                            return Card(
                              shadowColor: Colors.black87,
                              color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(snapshot
                                        .child('title')
                                        .value
                                        .toString()),
                                    SizedBox(height: 10),
                                    Text(snapshot
                                        .child('date')
                                        .value
                                        .toString()),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            // Check if it's the last item and no results are found.
                            if (title == snapshot.children.length - 1 &&
                                !title.toLowerCase().contains(
                                    SearchContoller.text.toString())) {
                              return Center(
                                  child: Text(
                                'No results found',
                              ));
                            } else {
                              return Image.asset(
                                'assets/images/No data-amico.png',
                              ); // Otherwise, don't return anything for non-matching items.
                            }
                          }
                        },
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Text(
                              'Search Your Task',
                              style: TextStyle(
                                  color: Color(0xffff725e), fontSize: 24),
                            ),
                            Image.asset('assets/images/Web search-pana.png'),
                          ],
                        ),
                      ), // Return an empty container if not searching.
              ),
            ],
          ),
        ),
      ),
    );
  }
}
