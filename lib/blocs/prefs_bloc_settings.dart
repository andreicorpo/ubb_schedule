import 'dart:async';

import 'package:uni_schedule_app/models/state/prefs_state_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

class PrefsBlocSettings {
  final _currentPrefs = BehaviorSubject<PrefsStateSettings>.seeded(
      PrefsStateSettings(theme: ThemeColor.NORMAL));

  final _changeTheme = StreamController<ThemeColor>();

  PrefsBlocSettings() {
    _loadPrefs();
    _changeTheme.stream.listen((ThemeColor theme) {
      switch (theme) {
        case ThemeColor.DARK:
          _savePrefs('dark', PrefsStateSettings(theme: ThemeColor.DARK));
          break;
        case ThemeColor.NORMAL:
          _savePrefs('normal', PrefsStateSettings(theme: ThemeColor.NORMAL));
          break;
        default:
          break;
      }
    });
  }

  Stream<PrefsStateSettings> get currentPrefs => _currentPrefs.stream;

  Sink<ThemeColor> get changeTheme => _changeTheme.sink;

  void close() {
    _currentPrefs.close();
    _changeTheme.close();
  }

  Future<void> _loadPrefs() async {
    final _prefs = await SharedPreferences.getInstance();
    final String _theme = _prefs.getString('theme') ?? 'normal';
    switch (_theme) {
      case 'normal':
        _currentPrefs.add(PrefsStateSettings(theme: ThemeColor.NORMAL));
        break;
      case 'dark':
        _currentPrefs.add(PrefsStateSettings(theme: ThemeColor.DARK));
        break;
      default:
        _currentPrefs.add(PrefsStateSettings(theme: ThemeColor.NORMAL));
        break;
    }
  }

  Future<void> _savePrefs(String theme, PrefsStateSettings newState) async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('theme', theme);
    _currentPrefs.add(newState);
  }
}
