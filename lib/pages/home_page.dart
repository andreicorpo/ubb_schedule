import 'package:flutter/material.dart';
import 'package:uni_schedule_app/models/state/prefs_state_settings.dart';
import 'package:uni_schedule_app/ui/backdrop.dart';
import 'package:uni_schedule_app/models/inherited_bloc.dart';
import 'package:uni_schedule_app/ui/themes.dart';
import 'package:uni_schedule_app/ui/user_selection/student/select_student.dart';
import 'package:uni_schedule_app/ui/user_selection/teacher/search_teachers.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final blocPrefs = InheritedBloc.of(context).prefsBlocSettings;
    final blocUser = InheritedBloc.of(context).userBloc;
    final studentSelection = StudentSelection();
    final teacherSearch = SearchTeachers();

    return StreamBuilder(
        stream: blocPrefs.currentPrefs,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MaterialApp(
              theme: _getTheme(snapshot.data.theme),
              color: Theme.of(context).primaryColor,
              title: 'UBB Schedule',
              home: StreamBuilder(
                  stream: blocUser.currentUserType,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final userType = snapshot.data;
                      return BackdropPage(
                        title: Text('Orar'),
                        panelHeaderHeight: 50.0,
                        base: userType == 'teacher'
                            ? teacherSearch
                            : studentSelection,
                      );
                    } else {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  }),
            );
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  ThemeData _getTheme(ThemeColor theme) {
    return theme == ThemeColor.NORMAL ? normal : dark;
  }

  @override
  void dispose() {
    final bloc = InheritedBloc.of(context).prefsBlocSettings;
    bloc.close();
    super.dispose();
  }
}
