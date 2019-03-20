import 'package:flutter/material.dart';
import 'package:uni_schedule_app/models/inherited_bloc.dart';
import 'package:uni_schedule_app/ui/empty_schedule.dart';
import 'package:uni_schedule_app/ui/schedule/teacher/teacher_schedule_elements.dart';

class TeacherSchedule extends StatefulWidget {
  final schedule;
  final scheduleType;

  const TeacherSchedule({Key key, @required this.schedule, this.scheduleType})
      : super(key: key);

  @override
  _TeacherScheduleState createState() => _TeacherScheduleState();
}

class _TeacherScheduleState extends State<TeacherSchedule> {
  @override
  Widget build(BuildContext context) {
    final bloc = InheritedBloc.of(context).userBloc;
    if (widget.schedule.length > 0) {
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
    } else {
      return EmptySchedule();
    }
  }
}
