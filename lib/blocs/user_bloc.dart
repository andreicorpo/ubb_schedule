import 'dart:async';

import 'package:uni_schedule_app/models/state/user_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uni_schedule_app/models/users/student/user_student.dart';
import 'package:uni_schedule_app/models/users/teacher/user_teacher.dart';
import 'package:uni_schedule_app/models/users/user.dart';

class UserBloc {
  int currHour;

  final _currentUser = BehaviorSubject<UserState>();
  final _changeUser = StreamController<User>();

  final _currentUserType = BehaviorSubject<String>.seeded('student');
  final _changeUserType = StreamController<String>();

  final _currentScheduleType = BehaviorSubject<String>.seeded('today');
  final _changeScheduleType = StreamController<String>();

  final _currentHour = BehaviorSubject<int>.seeded(DateTime.now().hour);
  final _changeHour = StreamController<int>();

  UserBloc() {
    _currentHour.add(DateTime.now().hour);
    Timer.periodic(Duration(minutes: 1), (_) {
      _currentHour.add(DateTime.now().hour);
    });
    _loadPrefs();
    _changeUser.stream.listen((user) {
      _savePrefsUser(user);
      _savePrefsUserType(user is UserTeacher ? 'teacher' : 'student');
    });
    _changeUserType.stream.listen((userType) {
      _savePrefsUserType(userType);
      _loadPrefs();
    });

    _changeScheduleType.stream.listen((scheduleType) {
      _currentScheduleType.add(scheduleType);
    });
  }

  Stream<UserState> get currentUser => _currentUser.stream;

  Sink<User> get changeUser => _changeUser.sink;

  Stream<String> get currentUserType => _currentUserType.stream;

  Sink<String> get changeUserType => _changeUserType.sink;

  Stream<String> get currentScheduleType => _currentScheduleType.stream;

  Sink<String> get changeScheduleType => _changeScheduleType.sink;

  Stream<int> get currentHour => _currentHour.stream;

  void close() {
    _currentUser.close();
    _changeUser.close();
    _currentUserType.close();
    _currentScheduleType.close();
    _changeUserType.close();
    _changeScheduleType.close();
    _currentHour.close();
    _changeHour.close();
  }

  void _savePrefsUserType(String userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userType', userType);
    _currentUserType.add(userType);
  }

  void _savePrefsUser(User user) async {
    final prefs = await SharedPreferences.getInstance();

    if (user is UserTeacher) {
      await prefs.setString('teacherName', user.name);
      await prefs.setString('teacherLink', user.link);
    } else if (user is UserStudent) {
      await prefs.setString('studentMajor', user.major);
      await prefs.setInt('studentYear', user.year);
      await prefs.setInt('studentGroup', user.group);
      await prefs.setInt('studentSubroup', user.subgroup);
    }
    _currentUser.add(UserState(user: user));
  }

  void _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userType = prefs.getString('userType');
    User user;
    switch (userType) {
      case 'teacher':
        final teacherName = prefs.getString('teacherName');
        final teacherLink = prefs.getString('teacherLink');
        user = UserTeacher(
          name: teacherName,
          link: teacherLink,
        );
        _currentUser.add(
          UserState(user: user),
        );
        changeUser.add(user);
        break;
      case 'student':
        final studentMajor = prefs.getString('studentMajor');
        final studentYear = prefs.getInt('studentYear');
        final studentGroup = prefs.getInt('studentGroup');
        final studentSubgroup = prefs.getInt('studentSubroup');
        user = UserStudent(
          group: studentGroup,
          subgroup: studentSubgroup,
          year: studentYear,
          major: studentMajor,
        );
        _currentUser.add(
          UserState(user: user),
        );
        changeUser.add(user);
        break;
      default:
        break;
    }
  }
}
