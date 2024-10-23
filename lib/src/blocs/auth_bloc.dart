import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc {
  final PublishSubject<bool> _isSessionValid = PublishSubject();

  Stream<bool> get isSessionValid => _isSessionValid.stream;

  void openSession(
      int? id, String? name, String? token, int? role, String? tokenFcm,
      {int? idPegawai}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', id!);
    prefs.setString('token', token!);
    prefs.setString('name', name!);
    prefs.setInt('role', role!);
    if (idPegawai != null) prefs.setInt('idPegawai', idPegawai);
    _isSessionValid.sink.add(true);
  }

  void closedSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _isSessionValid.sink.add(false);
  }

  void restoreSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      _isSessionValid.sink.add(true);
    } else {
      _isSessionValid.sink.add(false);
    }
  }

  dispose() {
    _isSessionValid.close();
  }
}

final authbloc = AuthBloc();
