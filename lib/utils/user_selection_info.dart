import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

Future<List<String>> getMajors(String degree) async {
  final degreeNum = degree == "Licenta" ? 0 : 1;
  int semester;
  if (DateTime.now().month >= 2 &&
      DateTime.now().month < 10 &&
      DateTime.now().day >= 15) {
    semester = 2;
  } else {
    semester = 1;
  }
  int year = semester == 1 ? DateTime.now().year : DateTime.now().year - 1;
  List<String> majors = [];
  final response = await http.get(
      'http://www.cs.ubbcluj.ro/files/orar/$year-$semester/tabelar/index.html');
  if (response.statusCode == 200) {
    dom.Document document = parser.parse(response.body);
    document
        .getElementsByTagName('table')[degreeNum]
        .getElementsByTagName('tr')
        .forEach((tr) {
      tr.getElementsByTagName('td').forEach((td) {
        if (!td.text.contains('Anul') && td.text.contains(RegExp(r'\w'))) {
          majors.add(td.text);
        }
      });
    });
  }
  return majors;
}

Future<Set<String>> getMajorsShort(String degree) async {
  final degreeNum = degree == "Licenta" ? 0 : 1;
  int semester;
  if (DateTime.now().month >= 2 &&
      DateTime.now().month < 10 &&
      DateTime.now().day >= 15) {
    semester = 2;
  } else {
    semester = 1;
  }
  int year = semester == 1 ? DateTime.now().year : DateTime.now().year - 1;
  Set<String> majors = Set();
  final response = await http.get(
      'http://www.cs.ubbcluj.ro/files/orar/$year-$semester/tabelar/index.html');
  if (response.statusCode == 200) {
    dom.Document document = parser.parse(response.body);
    document
        .getElementsByTagName('table')[degreeNum]
        .getElementsByTagName('tr')
        .forEach((tr) {
      tr.getElementsByTagName('td').forEach((td) {
        if (td.text.contains('Anul') && td.text.contains(RegExp(r'\w'))) {
          final str =
              td.getElementsByTagName('a')[0].attributes['href'].split('.')[0];
          majors.add(str.substring(0, str.length - 1));
        }
      });
    });
  }
  return majors;
}

Future<List<String>> getGroups(String major, int uniYear) async {
  int semester;
  if (DateTime.now().month >= 2 &&
      DateTime.now().month < 10 &&
      DateTime.now().day >= 15) {
    semester = 2;
  } else {
    semester = 1;
  }
  int year = semester == 1 ? DateTime.now().year : DateTime.now().year - 1;
  List<String> groups = [];
  final response = await http.get(
      'http://www.cs.ubbcluj.ro/files/orar/$year-$semester/tabelar/$major$uniYear.html');
  if (response.statusCode == 200) {
    dom.Document document = parser.parse(response.body);
    document.getElementsByTagName('h1').forEach((h1) {
      if (h1.text.contains('Gr')) {
        final group = h1.text.split(' ')[1];
        groups.add(group);
      }
    });
  }
  return groups;
}
