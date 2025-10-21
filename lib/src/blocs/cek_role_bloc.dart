import 'dart:async';

import 'package:admin_dokter_panggil/src/models/cek_role_model.dart';
import 'package:admin_dokter_panggil/src/repositories/cek_role_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';

class CekRoleBloc {
  final _repo = CekRoleRepo();
  StreamController<ApiResponse<CekRoleModel>>? _streamCekRole;

  StreamSink<ApiResponse<CekRoleModel>> get cekRoleSink => _streamCekRole!.sink;
  Stream<ApiResponse<CekRoleModel>> get cekRoleStream => _streamCekRole!.stream;

  Future<void> cekRole() async {
    _streamCekRole = StreamController();
    cekRoleSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.cekRole();
      if (_streamCekRole!.isClosed) return;
      cekRoleSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamCekRole!.isClosed) return;
      cekRoleSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamCekRole?.close();
  }
}
