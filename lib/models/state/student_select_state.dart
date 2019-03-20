import 'package:uni_schedule_app/models/users/student/user_student.dart';

class StudentSelectionState {
  String degree;
  int year;
  String major;
  String majorShort;
  int group;
  int subgroup;

  StudentSelectionState();

  UserStudent getStudent() {
    return UserStudent(
        group: group, major: majorShort, subgroup: subgroup, year: year);
  }
}
