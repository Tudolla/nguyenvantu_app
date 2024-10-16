import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final spinkit = Center(
  child: SpinKitThreeInOut(
    size: 35,
    itemBuilder: (_, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: index.isEven ? Color(0xFF7a9ee6) : Colors.grey,
        ),
      );
    },
  ),
);
