import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_schedule_app/models/state/student_select_state.dart';
import 'package:uni_schedule_app/models/users/student/user_student.dart';

class StudentSelectBloc {
  StudentSelectionState _studentSelectionState = StudentSelectionState();

  //Streams
  final _currentStudentSelectionState =
      BehaviorSubject<StudentSelectionState>.seeded(StudentSelectionState());

  //Sinks
  final _changeStudentSelectionState = StreamController<StudentSelectBloc>();
  final _changeStudentDegree = StreamController<String>();
  final _changeStudentYear = StreamController<int>();
  final _changeStudentMajor = StreamController<String>();
  final _changeStudentMajorShort = StreamController<String>();
  final _changeStudentGroup = StreamController<int>();
  final _changeStudentSubgroup = StreamController<int>();

  StudentSelectBloc() {
    _loadPrefs();
    _changeStudentDegree.stream.listen((degree) {
      _studentSelectionState.degree = degree;
      _studentSelectionState.year = null;
      _studentSelectionState.major = null;
      _studentSelectionState.majorShort = null;
      _studentSelectionState.group = null;
      _studentSelectionState.subgroup = null;
      _savePrefs();
    });
    _changeStudentYear.stream.listen((year) {
      _studentSelectionState.year = year;
      _studentSelectionState.major = null;
      _studentSelectionState.majorShort = null;
      _studentSelectionState.group = null;
      _studentSelectionState.subgroup = null;
      _savePrefs();
    });
    _changeStudentMajor.stream.listen((major) {
      _studentSelectionState.major = major;
      _studentSelectionState.group = null;
      _studentSelectionState.subgroup = null;
      _savePrefs();
    });
    _changeStudentMajorShort.stream.listen((majorShort) {
      _studentSelectionState.majorShort = majorShort;
      _studentSelectionState.group = null;
      _studentSelectionState.subgroup = null;
      _savePrefs();
    });
    _changeStudentGroup.stream.listen((group) {
      _studentSelectionState.group = group;
      _studentSelectionState.subgroup = null;
      _savePrefs();
    });
    _changeStudentSubgroup.stream.listen((subgroup) {
      _studentSelectionState.subgroup = subgroup;
      _savePrefs();
    });
  }

  UserStudent get student => _studentSelectionState.getStudent();

  Stream<StudentSelectionState> get currentStudentSelectionState =>
      _currentStudentSelectionState.stream;

  Sink<String> get changeStudentDegree => _changeStudentDegree.sink;
  Sink<int> get changeStudentYear => _changeStudentYear.sink;
  Sink<String> get changeStudentMajor => _changeStudentMajor.sink;
  Sink<String> get changeStudentMajorShort => _changeStudentMajorShort.sink;
  Sink<int> get changeStudentGroup => _changeStudentGroup.sink;
  Sink<int> get changeStudentSubgroup => _changeStudentSubgroup.sink;

  void close() {
    _currentStudentSelectionState.close();
    _changeStudentSelectionState.close();
    _changeStudentDegree.close();
    _changeStudentYear.close();
    _changeStudentMajor.close();
    _changeStudentMajorShort.close();
    _changeStudentGroup.close();
    _changeStudentSubgroup.close();
  }

  void _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final String degree = prefs.getString('studentDegree');
    _studentSelectionState.degree = degree;
    _currentStudentSelectionState.add(_studentSelectionState);

    final int year = prefs.getInt('studentYear');
    _studentSelectionState.year = year;
    _currentStudentSelectionState.add(_studentSelectionState);

    final String major = prefs.getString('studentMajorLong');
    _studentSelectionState.major = major;
    _currentStudentSelectionState.add(_studentSelectionState);

    final String majorShort = prefs.getString('studentMajor');
    _studentSelectionState.majorShort = majorShort;
    _currentStudentSelectionState.add(_studentSelectionState);

    final int group = prefs.getInt('studentGroup');
    _studentSelectionState.group = group;
    _currentStudentSelectionState.add(_studentSelectionState);

    final int subgroup = prefs.getInt('studentSubgroup');
    _studentSelectionState.subgroup = subgroup;
    _currentStudentSelectionState.add(_studentSelectionState);
  }

  void _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('studentDegree', _studentSelectionState.degree);
    await prefs.setString('studentMajorLong', _studentSelectionState.major);
    await prefs.setString(
        'studentMajorShort', _studentSelectionState.majorShort);
    await prefs.setInt('studentYear', _studentSelectionState.year);
    await prefs.setInt('studentGroup', _studentSelectionState.group);
    await prefs.setInt('studentSubgroup', _studentSelectionState.subgroup);

    _currentStudentSelectionState.add(_studentSelectionState);
  }
}
