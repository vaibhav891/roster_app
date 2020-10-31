import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class MyDecorationBox extends BoxDecoration {
  MyDecorationBox()
      : super(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            alignment: Alignment.topCenter,
          ),
        );
}
