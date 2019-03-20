import 'package:flutter/material.dart';

class ClassInfo extends StatelessWidget {
  final index;
  final userClass;
  const ClassInfo({
    Key key,
    List schedule,
    this.index,
    @required this.userClass,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.access_time,
                  color: classTypeColor(userClass.classType[0]),
                ),
                SizedBox(width: 6.0),
                Text('${userClass.startTime}:00'),
                Text(' - '),
                Text('${userClass.endTime}:00'),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.calendar_today,
                  color: classTypeColor(userClass.classType[0]),
                ),
                SizedBox(width: 6.0),
                Text('${userClass.day}')
              ],
            ),
          ),
          !userClass.reccurence.contains('sapt')
              ? Container()
              : Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.autorenew,
                        color: classTypeColor(userClass.classType[0]),
                      ),
                      SizedBox(width: 6.0),
                      Text('${userClass.reccurence}'),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class TeacherInfo extends StatelessWidget {
  final index;
  final userClass;
  const TeacherInfo({
    Key key,
    List schedule,
    this.index,
    @required this.userClass,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12.0),
      child: Container(
        child: Row(
          children: <Widget>[
            Icon(
              Icons.person,
              color: classTypeColor(userClass.classType[0]),
            ),
            SizedBox(width: 6.0),
            Text('${userClass.teacher}'),
          ],
        ),
      ),
    );
  }
}

Color classTypeColor(String firstLetter) {
  switch (firstLetter) {
    case 'C':
      return Colors.lightGreen;
    case 'S':
      return Colors.lightBlue;
    case 'L':
      return Colors.redAccent;
    default:
      return Colors.grey;
  }
}

Widget classItem(BuildContext context, var userClass, String scheduleType) {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Container(
      decoration: BoxDecoration(
          color:
              Theme.of(context).primaryColor == Color.fromARGB(255, 29, 66, 113)
                  ? Colors.white
                  : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(18.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: Offset(0.0, 3.0),
              blurRadius: 4.0,
            )
          ]),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          dividerColor: Colors.transparent,
          accentColor: classTypeColor(userClass.classType[0]),
        ),
        child: ExpansionTile(
          title: ListTile(
            title: Text(
              '${userClass.className}',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            subtitle: Opacity(
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    size: 14.0,
                    color: classTypeColor(userClass.classType[0]),
                  ),
                  SizedBox(width: 4.0),
                  Text('${userClass.location}'),
                ],
              ),
              opacity: 0.8,
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: classTypeColor(userClass.classType[0]),
            foregroundColor: Colors.white,
            child: Text('${userClass.classType[0]}'),
          ),
          children: <Widget>[
            Divider(
              color: Colors.black.withOpacity(0.5),
              indent: 32,
            ),
            ClassInfo(
              userClass: userClass,
            ),
            TeacherInfo(
              userClass: userClass,
            )
          ],
        ),
      ),
    ),
  );
}
