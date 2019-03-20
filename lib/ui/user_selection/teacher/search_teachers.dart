import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:flutter/material.dart';
import 'package:uni_schedule_app/models/inherited_bloc.dart';
import 'package:uni_schedule_app/models/users/teacher/user_teacher.dart';

class SearchTeachers extends StatefulWidget {
  const SearchTeachers({Key key, onTap}) : super(key: key);

  @override
  _SearchTeachersState createState() => _SearchTeachersState();
}

class _SearchTeachersState extends State<SearchTeachers> {
  TextEditingController editingController = TextEditingController();
  Map<String, String> _teachers = {};
  List<String> duplicateItems = [];
  var items = List<String>();

  @override
  void initState() {
    super.initState();
    _getNames().then((teachers) {
      _teachers = teachers;
      duplicateItems = teachers.keys.toList();
      items.addAll(duplicateItems);
    });
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = [];
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<String> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = InheritedBloc.of(context).userBloc;
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: TextStyle(
                color: Colors.white,
              ),
              onChanged: (value) {
                filterSearchResults(value);
              },
              controller: editingController,
              decoration: InputDecoration(
                hintText: "Cautare profesor...",
                hintStyle: TextStyle(
                    color: Colors.white54, fontStyle: FontStyle.italic),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListTile(
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      final teacherName = items[index];
                      UserTeacher userTeacher = UserTeacher(
                          name: teacherName, link: _teachers[teacherName]);
                      bloc.changeUser.add(userTeacher);
                    },
                    leading: Icon(
                      Icons.account_circle,
                      color: Colors.white70,
                    ),
                    title: Text(
                      '${items[index]}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, String>> _getNames() async {
    final Map<String, String> teachers = {};
    final response = await http
        .get('http://www.cs.ubbcluj.ro/files/orar/2018-2/cadre/index.html');
    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);
      document.getElementsByTagName('tr').forEach((tr) {
        tr.getElementsByTagName('td').forEach((td) {
          try {
            final name = td.text;
            final link = td.getElementsByTagName('a').first.attributes['href'];
            teachers[name] = link;
          } catch (e) {}
        });
      });
      return teachers;
    } else {
      return null;
    }
  }
}
