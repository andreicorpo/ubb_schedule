import 'package:flutter/material.dart';
import 'package:uni_schedule_app/models/inherited_bloc.dart';
import 'package:uni_schedule_app/models/state/prefs_state_settings.dart';

class SecondBase extends StatefulWidget {
  @override
  _SecondBaseState createState() => _SecondBaseState();
}

class _SecondBaseState extends State<SecondBase> {
  @override
  Widget build(BuildContext context) {
    final blocPrefs = InheritedBloc.of(context).prefsBlocSettings;
    final blocUser = InheritedBloc.of(context).userBloc;
    return StreamBuilder(
      stream: blocPrefs.currentPrefs,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: EdgeInsets.all(22.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Setati tema intunecata',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                        Switch(
                          value: snapshot.data.theme == ThemeColor.DARK,
                          onChanged: (useDarkTheme) {
                            useDarkTheme
                                ? blocPrefs.changeTheme.add(ThemeColor.DARK)
                                : blocPrefs.changeTheme.add(ThemeColor.NORMAL);
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder(
                      stream: blocUser.currentUserType,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Schimbati modul userului',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                              FlatButton(
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Text(
                                    'Mod curent: ${snapshot.data == "teacher" ? "Profesor" : "Student"}',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  snapshot.data == "teacher"
                                      ? blocUser.changeUserType.add('student')
                                      : blocUser.changeUserType.add('teacher');
                                },
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  // @override
  // void dispose() {
  //   final bloc = InheritedBloc.of(context).prefsBlocSettings;
  //   bloc.close();
  //   super.dispose();
  // }
}
