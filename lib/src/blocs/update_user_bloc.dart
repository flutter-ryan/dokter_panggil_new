import 'dart:async';

import 'package:dokter_panggil/src/models/update_user_model.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/repositories/update_user_repo.dart';
import 'package:rxdart/subjects.dart';

class UpdateUserBloc {
  final _repo = UpdateUserRepo();
  StreamController<ApiResponse<ResponseUpdateUserModel>>? _streamUpdateUser;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<String> _name = BehaviorSubject();
  final BehaviorSubject<String> _email = BehaviorSubject();
  final BehaviorSubject<String> _password = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _confirmation = BehaviorSubject.seeded('');
  final BehaviorSubject<int> _role = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<String> get nameSink => _name.sink;
  StreamSink<String> get emailSink => _email.sink;
  StreamSink<String> get passwordSink => _password.sink;
  StreamSink<String> get confirmationSink => _confirmation.sink;
  StreamSink<int> get roleSink => _role.sink;
  StreamSink<ApiResponse<ResponseUpdateUserModel>> get updateUserSink =>
      _streamUpdateUser!.sink;
  Stream<ApiResponse<ResponseUpdateUserModel>> get updateUserStream =>
      _streamUpdateUser!.stream;

  Future<void> updateUser() async {
    _streamUpdateUser = StreamController();
    final id = _id.value;
    final name = _name.value;
    final email = _email.value;
    final password = _password.value;
    final confirmation = _confirmation.value;
    final role = _role.value;
    updateUserSink.add(ApiResponse.loading('Memuat...'));
    UpdateUserModel updateUserModel = UpdateUserModel(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: confirmation,
      role: role,
    );
    try {
      final res = await _repo.updateUser(id, updateUserModel);
      if (_streamUpdateUser!.isClosed) return;
      updateUserSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamUpdateUser!.isClosed) return;
      updateUserSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamUpdateUser?.close();
    _id.close();
    _name.close();
    _email.close();
    _password.close();
    _confirmation.close();
  }
}
