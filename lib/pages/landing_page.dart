import 'package:flutter/material.dart';
import 'package:uni_schedule_app/models/inherited_bloc.dart';
import 'package:uni_schedule_app/models/state/prefs_state_settings.dart';
import 'package:uni_schedule_app/pages/home_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final blocUser = InheritedBloc.of(context).userBloc;
    final blocPrefs = InheritedBloc.of(context).prefsBlocSettings;
    return StreamBuilder(
      stream: blocUser.currentUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Navigator.of(context).pushAndRemoveUntil(
              (MaterialPageRoute(
                builder: (BuildContext context) => HomePage(),
              )),
              (Route route) => route == null);
          return Container();
        } else {
          return StreamBuilder(
              stream: blocPrefs.currentPrefs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return MaterialApp(
                      theme: _getTheme(snapshot.data.theme),
                      color: Theme.of(context).primaryColor,
                      title: 'UBB Schedule',
                      home: Container(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      (MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            HomePage(),
                                      )),
                                      (Route route) => route == null);
                                },
                                child: Text('Start'),
                              )
                            ],
                          ),
                        ),
                      ));
                } else {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              });
        }
      },
    );
  }
}

ThemeData _getTheme(ThemeColor theme) {
  return theme == ThemeColor.NORMAL
      ? ThemeData(primaryColor: Color.fromARGB(255, 29, 66, 113))
      : ThemeData.dark();
}
