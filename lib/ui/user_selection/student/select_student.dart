import 'package:flutter/material.dart';
import 'package:uni_schedule_app/ui/user_selection/student/select_student_elements.dart';

class StudentSelection extends StatefulWidget {
  @override
  _StudentSelectionState createState() => _StudentSelectionState();
}

class _StudentSelectionState extends State<StudentSelection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Theme.of(context).primaryColor.withOpacity(0.8),
          dividerColor: Colors.white,
          textTheme: TextTheme(
            subhead: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
            opacity: .5,
          ),
          hintColor: Colors.white54,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    DegreeDropdown(),
                    YearDropdown(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: MajorDropdown(),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GroupDropdown(),
                    SubgroupDropdown(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SubmitBtn(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
