import 'package:flutter/material.dart';

ThemeData normal = ThemeData(
            primaryColor: Color.fromARGB(255, 29, 66, 113),
            fontFamily: 'Quicksand',
            accentColor: Colors.amber,
          );

ThemeData dark = ThemeData.dark().copyWith(
            textTheme: TextTheme(
              display1: TextStyle(fontFamily: 'Quicksand'),
              display2: TextStyle(fontFamily: 'Quicksand'),
              display3: TextStyle(fontFamily: 'Quicksand'),
              display4: TextStyle(fontFamily: 'Quicksand'),
              headline: TextStyle(fontFamily: 'Quicksand'),
              body1: TextStyle(fontFamily: 'Quicksand'),
              body2: TextStyle(fontFamily: 'Quicksand'),
              button: TextStyle(fontFamily: 'Quicksand'),
              caption: TextStyle(fontFamily: 'Quicksand'),
              overline: TextStyle(fontFamily: 'Quicksand'),
              title: TextStyle(fontFamily: 'Quicksand'),
              subhead: TextStyle(fontFamily: 'Quicksand'),
              subtitle: TextStyle(fontFamily: 'Quicksand'),
            ),
            primaryTextTheme: TextTheme(
              display1: TextStyle(fontFamily: 'Quicksand'),
              display2: TextStyle(fontFamily: 'Quicksand'),
              display3: TextStyle(fontFamily: 'Quicksand'),
              display4: TextStyle(fontFamily: 'Quicksand'),
              headline: TextStyle(fontFamily: 'Quicksand'),
              body1: TextStyle(fontFamily: 'Quicksand'),
              body2: TextStyle(fontFamily: 'Quicksand'),
              button: TextStyle(fontFamily: 'Quicksand'),
              caption: TextStyle(fontFamily: 'Quicksand'),
              overline: TextStyle(fontFamily: 'Quicksand'),
              title: TextStyle(fontFamily: 'Quicksand'),
              subhead: TextStyle(fontFamily: 'Quicksand'),
              subtitle: TextStyle(fontFamily: 'Quicksand'),
            ),
          );