import 'package:flutter/material.dart';
import 'package:uni_schedule_app/models/inherited_bloc.dart';
import 'package:uni_schedule_app/models/users/user.dart';
import 'package:uni_schedule_app/utils/user_selection_info.dart';

class DegreeDropdown extends StatefulWidget {
  @override
  _DegreeDropdownState createState() => _DegreeDropdownState();
}

class _DegreeDropdownState extends State<DegreeDropdown> {
  String userDegree;
  @override
  Widget build(BuildContext context) {
    final bloc = InheritedBloc.of(context).studSelBloc;
    return StreamBuilder(
        stream: bloc.currentStudentSelectionState,
        builder: (context, snapshot) {
          return Container(
            child: DropdownButton(
              value: snapshot.data?.degree ?? userDegree,
              items: <String>['Licenta', 'Master'].map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                bloc.changeStudentDegree.add(value);
              },
              elevation: 1,
              hint: Text(
                'Nivelul',
              ),
            ),
          );
        });
  }
}

class YearDropdown extends StatefulWidget {
  @override
  _YearDropdownState createState() => _YearDropdownState();
}

class _YearDropdownState extends State<YearDropdown> {
  String userYear;

  @override
  Widget build(BuildContext context) {
    final bloc = InheritedBloc.of(context).studSelBloc;
    return StreamBuilder(
        stream: bloc.currentStudentSelectionState,
        builder: (context, snapshot) {
          final List<String> items =
              snapshot.data?.degree == 'Licenta' ? ['1', '2', '3'] : ['1', '2'];
          return Container(
            child: DropdownButton(
              value: snapshot.hasData && snapshot.data.year != null
                  ? '${snapshot.data.year}'
                  : userYear,
              items: items.map((year) {
                return DropdownMenuItem(
                  value: year,
                  child: Text('An $year'),
                );
              }).toList(),
              onChanged: (value) {
                bloc.changeStudentYear.add(int.parse(value));
              },
              elevation: 1,
              hint: Text('Anul'),
            ),
          );
        });
  }
}

class MajorDropdown extends StatefulWidget {
  @override
  _MajorDropdownState createState() => _MajorDropdownState();
}

class _MajorDropdownState extends State<MajorDropdown> {
  String userMajor;
  @override
  Widget build(BuildContext context) {
    final bloc = InheritedBloc.of(context).studSelBloc;
    return StreamBuilder(
      stream: bloc.currentStudentSelectionState,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data.degree != null &&
            snapshot.data.year != null) {
          var studentData = snapshot.data;
          return Container(
            child: FutureBuilder<List<String>>(
              future: getMajors(studentData.degree),
              builder:
                  (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    child: DropdownButton<String>(
                      value: studentData.major != null
                          ? '${studentData.major}'
                          : userMajor,
                      items: snapshot.data.map((major) {
                        return DropdownMenuItem<String>(
                          value: major,
                          child: Text(major),
                        );
                      }).toList(),
                      onChanged: (value) {
                        bloc.changeStudentMajor.add(value);
                        final index = snapshot.data.indexOf(value);
                        getMajorsShort(studentData.degree).then((shorts) => bloc
                            .changeStudentMajorShort
                            .add(shorts.elementAt(index)));
                      },
                      elevation: 1,
                      hint: Text('Sectia'),
                      isExpanded: true,
                    ),
                  );
                } else {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class GroupDropdown extends StatefulWidget {
  @override
  _GroupDropdownState createState() => _GroupDropdownState();
}

class _GroupDropdownState extends State<GroupDropdown> {
  String userGroup;

  @override
  Widget build(BuildContext context) {
    final bloc = InheritedBloc.of(context).studSelBloc;
    return StreamBuilder(
        stream: bloc.currentStudentSelectionState,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data.majorShort != null &&
              snapshot.data.year != null) {
            var studentData = snapshot.data;
            return Container(
              child: FutureBuilder<List<String>>(
                future: getGroups(studentData.majorShort, studentData.year),
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      child: DropdownButton<String>(
                        value: studentData.group != null
                            ? '${studentData.group}'
                            : userGroup,
                        items: snapshot.data.map((group) {
                          return DropdownMenuItem<String>(
                            value: group,
                            child: Text('Gr. $group'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          bloc.changeStudentGroup.add(int.parse(value));
                        },
                        elevation: 1,
                        hint: Text('Grupa'),
                      ),
                    );
                  } else {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            );
          } else {
            return Container();
          }
        });
  }
}

class SubgroupDropdown extends StatefulWidget {
  @override
  _SubgroupDropdownState createState() => _SubgroupDropdownState();
}

class _SubgroupDropdownState extends State<SubgroupDropdown> {
  String userSubgroup;
  @override
  Widget build(BuildContext context) {
    final List<String> items = ['1', '2'];
    final bloc = InheritedBloc.of(context).studSelBloc;
    return StreamBuilder(
        stream: bloc.currentStudentSelectionState,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.group != null) {
            var studentData = snapshot.data;
            return Container(
              child: DropdownButton<String>(
                value: studentData.subgroup != null
                    ? '${studentData.subgroup}'
                    : userSubgroup,
                items: items.map((subgroup) {
                  return DropdownMenuItem<String>(
                    value: subgroup,
                    child: Text('Subgr. $subgroup'),
                  );
                }).toList(),
                onChanged: (value) {
                  bloc.changeStudentSubgroup.add(int.parse(value));
                },
                elevation: 1,
                hint: Text('Subgrupa'),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}

class SubmitBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final blocUser = InheritedBloc.of(context).userBloc;
    final blocStudSel = InheritedBloc.of(context).studSelBloc;
    return StreamBuilder(
      stream: blocStudSel.currentStudentSelectionState,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data.degree != null &&
            snapshot.data.year != null &&
            snapshot.data.major != null &&
            snapshot.data.majorShort != null &&
            snapshot.data.group != null &&
            snapshot.data.subgroup != null) {
          return Container(
            decoration: BoxDecoration(
              border: BorderDirectional(
                bottom: BorderSide(
                  color: Colors.white,
                ),
              ),
            ),
            child: FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: Text(
                'Salveaza',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                User user = blocStudSel.student;
                blocUser.changeUser.add(user);
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
