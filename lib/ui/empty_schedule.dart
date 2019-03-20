import 'package:flutter/material.dart';

class EmptySchedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Opacity(
          opacity: 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.calendar_today,
                size: MediaQuery.of(context).size.width / 5,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Orarul este gol',
                style: TextStyle(fontSize: 20.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
