import 'package:flutter/material.dart';
import 'package:uni_schedule_app/models/inherited_bloc.dart';
import 'package:uni_schedule_app/ui/schedule/student/student_schedule_elements.dart';

class StudentSchedule extends StatefulWidget {
  final schedule;
  final scheduleType;

  const StudentSchedule({Key key, @required this.schedule, this.scheduleType})
      : super(key: key);

  @override
  _StudentScheduleState createState() => _StudentScheduleState();
}

class _StudentScheduleState extends State<StudentSchedule> {
  @override
  Widget build(BuildContext context) {
    final bloc = InheritedBloc.of(context).userBloc;
    return StreamBuilder(
      stream: bloc.currentScheduleType,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: ListView.builder(
              itemCount: widget.schedule.length,
              itemBuilder: (BuildContext context, int index) =>
                  classItem(context, widget.schedule[index], snapshot.data),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
