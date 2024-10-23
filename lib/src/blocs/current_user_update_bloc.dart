import 'dart:async';

import 'package:dokter_panggil/src/models/current_user_update_model.dart';
import 'package:dokter_panggil/src/repositories/current_user_update_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class CurrentUserUpdateBloc {
  final _repo = CurrentUserUpdateRepo();
  StreamController<ApiResponse<ResponseCurrentUserUpdateModel>>?
      _streamCurrentUpdate;
  final BehaviorSubject<String> _nama = BehaviorSubject();
  final BehaviorSubject<String> _email = BehaviorSubject();
  final BehaviorSubject<String> _password = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _confirmationPassword = BehaviorSubject();
  StreamSink<String> get namaSink => _nama.sink;
  StreamSink<String> get emailSink => _email.sink;
  StreamSink<String> get passwordSink => _password.sink;
  StreamSink<String> get confirmationPasswordSink => _confirmationPassword.sink;
  StreamSink<ApiResponse<ResponseCurrentUserUpdateModel>>
      get currentUpdateSink => _streamCurrentUpdate!.sink;
  Stream<ApiResponse<ResponseCurrentUserUpdateModel>> get currentUpdateStream =>
      _streamCurrentUpdate!.stream;

  Future<void> updateCurrentUser() async {
    _streamCurrentUpdate = StreamController();
    final nama = _nama.value;
    final email = _email.value;
    final password = _password.value;
    final confirmationPassword = _confirmationPassword.value;
    currentUpdateSink.add(ApiResponse.loading('Memuat...'));
    CurrentUserUpdateModel currentUserUpdateModel = CurrentUserUpdateModel(
        name: nama,
        email: email,
        password: password,
        confirmationPassword: confirmationPassword);

    try {
      final res = await _repo.updateCurrentUser(currentUserUpdateModel);
      if (_streamCurrentUpdate!.isClosed) return;
      currentUpdateSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamCurrentUpdate!.isClosed) return;
      currentUpdateSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamCurrentUpdate?.close();
    _nama.close();
    _email.close();
    _password.close();
    _confirmationPassword.close();
  }
}
