import 'package:flutter/material.dart';
import 'package:uni_schedule_app/models/inherited_bloc.dart';
import 'package:uni_schedule_app/models/users/teacher/user_teacher.dart';
import 'package:uni_schedule_app/ui/schedule/student/student_schedule.dart';
import 'package:uni_schedule_app/ui/schedule/teacher/teacher_schedule.dart';

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    final bloc = InheritedBloc.of(context).userBloc;
    return StreamBuilder(
      stream: bloc.currentUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userType =
              snapshot.data.user is UserTeacher ? 'teacher' : 'student';
          final user = snapshot.data.user;
          return StreamBuilder(
              stream: bloc.currentScheduleType,
              builder: (context, snapshot) {
                return FutureBuilder(
                  future: user.getData(snapshot.data),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      var _schedule = snapshot.data;
                      return userType == 'teacher'
                          ? TeacherSchedule(
                              schedule: _schedule,
                            )
                          : StudentSchedule(
                              schedule: _schedule,
                            );
                    } else {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                );
              });
        } else {
          return Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                child: Text(
                  'Nu s-a gasit niciun utilizator. Deschideti meniul din partea dreapta sus si selectati un utilizator.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
