import 'dart:async';

import 'package:admin_dokter_panggil/src/models/current_user_model.dart';
import 'package:admin_dokter_panggil/src/repositories/current_user_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';

class CurrentUserBloc {
  final _repo = CurrentUserRepo();
  StreamController<ApiResponse<CurrentUserModel>>? _streamCurrentUser;
  StreamSink<ApiResponse<CurrentUserModel>> get currentUserSink =>
      _streamCurrentUser!.sink;
  Stream<ApiResponse<CurrentUserModel>> get currentUserStream =>
      _streamCurrentUser!.stream;

  Future<void> getCurrentUser() async {
    _streamCurrentUser = StreamController();
    currentUserSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getCurrentUser();
      if (_streamCurrentUser!.isClosed) return;
      currentUserSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamCurrentUser!.isClosed) return;
      currentUserSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamCurrentUser?.close();
  }
}
