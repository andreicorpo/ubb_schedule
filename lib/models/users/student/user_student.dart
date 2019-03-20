import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:uni_schedule_app/models/users/student/user_student_class.dart';
import 'package:uni_schedule_app/models/users/user.dart';
import 'package:uni_schedule_app/utils/day_translation.dart';

class UserStudent implements User {
  final int group;
  final int subgroup;
  final int year;
  final String major;

  UserStudent({this.group, this.subgroup, this.year, this.major});

  @override
  Future<List<UserStudentClass>> getData(
      String scheduleType, int currTime) async {
    List<String> schedule = [];
    List<List<String>> schedules = [];
    List<UserStudentClass> classes = [];
    final response = await http.get(
        'http://www.cs.ubbcluj.ro/files/orar/2018-2/tabelar/$major$year.html');
    if (response.statusCode == 200) {
      int groupNum = group % 10;
      dom.Document document = parser.parse(response.body);
      document
          .getElementsByTagName('table')[groupNum - 1]
          .getElementsByTagName('tr')
          .forEach((child) {
        child.getElementsByTagName('td').forEach((c) {
          schedule.add(c.text);
        });

        schedules.add(schedule);
        schedule = [];
      });
      schedules.removeAt(0);
      schedules.forEach((schedule) {
        classes.add(UserStudentClass(
          day: schedule[0],
          startTime: int.parse(schedule[1].split("-")[0]),
          endTime: int.parse(schedule[1].split("-")[1]),
          reccurence: schedule[2],
          location: schedule[3],
          group: schedule[4],
          classType: schedule[5],
          className: schedule[6],
          teacher: schedule[7],
        ));
      });
      classes.removeWhere(
          (c) => c.group.contains('/') && c.group.split('/')[1] != '$subgroup');
      String weekdayToday = getDay(DateTime.now().weekday);
      String weekdayTommorow = getDay(DateTime.now().weekday + 1);
      switch (scheduleType) {
        case 'full':
          return classes;
        case 'today':
          classes.removeWhere((c) => c.day != weekdayToday);
          classes.removeWhere((c) => currTime >= c.endTime);
          return classes;
        case 'tommorow':
          classes.removeWhere((c) => c.day != weekdayTommorow);
          return classes;
        default:
          return classes;
      }
    } else {
      return null;
    }
  }

  @override
  String toString() {
    return '$group $subgroup $year $major';
  }
}
