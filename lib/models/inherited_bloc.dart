import 'package:flutter/material.dart';
import 'package:uni_schedule_app/blocs/prefs_bloc_settings.dart';
import 'package:uni_schedule_app/blocs/user_bloc.dart';
import 'package:uni_schedule_app/blocs/student_select_bloc.dart';

class InheritedBloc extends InheritedWidget {
  final PrefsBlocSettings prefsBlocSettings = PrefsBlocSettings();
  final UserBloc userBloc = UserBloc();
  final StudentSelectBloc studSelBloc = StudentSelectBloc();

  InheritedBloc({Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedBloc oldWidget) => true;

  static InheritedBloc of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(InheritedBloc);

  void close() {
    prefsBlocSettings.close();
    userBloc.close();
    studSelBloc.close();
  }
}
