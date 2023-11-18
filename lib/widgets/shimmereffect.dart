// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ShimmerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: ShimmerContainer(width: double.infinity, height: 20.0),
      subtitle: ShimmerContainer(width: double.infinity, height: 15.0),
      trailing: Icon(Icons.more_vert, color: Colors.grey),
    );
  }
}

class ShimmerContainer extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerContainer({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.white,
    );
  }
}
