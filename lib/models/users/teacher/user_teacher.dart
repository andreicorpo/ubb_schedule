import 'package:uni_schedule_app/models/users/teacher/user_teacher_class.dart';
import 'package:uni_schedule_app/models/users/user.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:uni_schedule_app/utils/day_translation.dart';

class UserTeacher implements User {
  String name;
  String link;

  UserTeacher({this.name, this.link});

  @override
  Future<List<UserTeacherClass>> getData(
      String scheduleType, int currTime) async {
    List<String> schedule = [];
    List<List<String>> schedules = [];
    List<UserTeacherClass> classes = [];
    final response = await http
        .get('http://www.cs.ubbcluj.ro/files/orar/2018-2/cadre/$link');
    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);
      document
          .getElementsByTagName('table')[0]
          .getElementsByTagName('tr')
          .forEach(
        (child) {
          child.getElementsByTagName('td').forEach(
            (c) {
              schedule.add(c.text);
            },
          );

          schedules.add(schedule);
          schedule = [];
        },
      );
      schedules.removeAt(0);
      schedules.forEach(
        (schedule) {
          classes.add(
            UserTeacherClass(
              day: schedule[0],
              startTime: int.parse(schedule[1].split("-")[0]),
              endTime: int.parse(schedule[1].split("-")[1]),
              reccurence: schedule[2],
              location: schedule[3],
              year: schedule[4],
              group: schedule[5],
              classType: schedule[6],
              className: schedule[7],
            ),
          );
        },
      );
      String weekdayToday = getDay(DateTime.now().weekday);
      String weekdayTommorow = getDay((DateTime.now().weekday + 1) % 7);
      switch (scheduleType) {
        case 'full':
          return classes;
        case 'today':
          if (classes.isNotEmpty) {
            classes.removeWhere((c) => c.day != weekdayToday);
          }
          if (classes.isNotEmpty) {
            classes.removeWhere((c) => currTime >= c.endTime);
          }
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
}
