import 'package:flutter/material.dart';
import 'package:uni_schedule_app/models/inherited_bloc.dart';
import 'package:uni_schedule_app/models/users/teacher/user_teacher.dart';
import 'package:uni_schedule_app/ui/schedule/schedule.dart';
import 'package:uni_schedule_app/ui/settings.dart';
import 'package:swipedetector/swipedetector.dart';

class BackdropPage extends StatefulWidget {
  final double _panelHeaderHeight;
  final Widget _title;
  final Widget _base;

  const BackdropPage(
      {Key key,
      @required Widget title,
      @required double panelHeaderHeight,
      @required Widget base})
      : _title = title,
        _panelHeaderHeight = panelHeaderHeight,
        _base = base,
        super(key: key);

  @override
  _BackdropPageState createState() => _BackdropPageState();
}

class _BackdropPageState extends State<BackdropPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Widget _currentBase;
  Widget _secondBase = SecondBase();

  @override
  void initState() {
    super.initState();
    _currentBase = widget._base;
    _controller = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this, value: 1.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  Animation<RelativeRect> _getPanelAnimation(BoxConstraints constraints) {
    final double height = constraints.biggest.height;
    final double top = height - widget._panelHeaderHeight;
    final double bottom = -widget._panelHeaderHeight;
    return RelativeRectTween(
      begin: RelativeRect.fromLTRB(0.0, top, 0.0, bottom),
      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = InheritedBloc.of(context).userBloc;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: _isPanelVisible
            ? widget._title
            : _currentBase == widget._base ? Text('Meniu') : Text('Setari'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            if (_currentBase == widget._base || _isPanelVisible == true) {
              _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
            }
            this.setState(() => _currentBase = widget._base);
          },
          icon: Icon(
            Icons.menu,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (_currentBase == _secondBase || _isPanelVisible == true) {
                _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
              }
              this.setState(() => _currentBase = _secondBase);
            },
            icon: Icon(
              Icons.settings,
            ),
          )
        ],
      ),
      bottomNavigationBar: StreamBuilder(
          stream: bloc.currentScheduleType,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final scheduleTypes = <String>['full', 'today', 'tommorow'];
              int currentIndex = scheduleTypes.indexOf(snapshot.data);
              return Theme(
                data: Theme.of(context).copyWith(
                    canvasColor: Theme.of(context).primaryColor,
                    textTheme: Theme.of(context).textTheme.copyWith(
                          caption: TextStyle(color: Colors.white30),
                        )),
                child: BottomNavigationBar(
                  fixedColor: Theme.of(context).accentColor,
                  currentIndex: currentIndex,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.calendar_today,
                        ),
                      ),
                      title: Text(
                        'Complet',
                      ),
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.today,
                        ),
                      ),
                      title: Text(
                        'Azi',
                      ),
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.next_week,
                        ),
                      ),
                      title: Text(
                        'Maine',
                      ),
                    )
                  ],
                  onTap: (index) {
                    bloc.changeScheduleType.add(scheduleTypes[index]);
                  },
                ),
              );
            } else {
              return Container();
            }
          }),
      body: LayoutBuilder(
        builder: _buildStack,
      ),
    );
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final Animation<RelativeRect> animation = _getPanelAnimation(constraints);
    final ThemeData theme = Theme.of(context);
    final bloc = InheritedBloc.of(context).userBloc;
    return Container(
      color: theme.primaryColor,
      child: Stack(
        children: <Widget>[
          _currentBase,
          PositionedTransition(
            rect: animation,
            child: Material(
              borderRadius: const BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0),
              ),
              elevation: 12.0,
              child: Column(
                children: <Widget>[
                  StreamBuilder(
                      stream: bloc.currentUser,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return FlatButton(
                            onPressed: () {
                              _controller.fling(
                                  velocity: _isPanelVisible ? -1.0 : 1.0);
                              this.setState(() => widget._title);
                            },
                            child: Container(
                              height: widget._panelHeaderHeight,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: snapshot.data.user is UserTeacher
                                    ? snapshot.data.user.name != null
                                        ? Text(
                                            '${snapshot.data.user.name ?? ''}',
                                          )
                                        : Text('Select User')
                                    : snapshot.data.user.group != null
                                        ? Text(
                                            'Subgrupa ${snapshot.data.user.group}/${snapshot.data.user.subgroup}',
                                          )
                                        : Text('Select User'),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            height: widget._panelHeaderHeight,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                'Selectati un utilizator',
                              ),
                            ),
                          );
                        }
                      }),
                  Expanded(child: Schedule()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
