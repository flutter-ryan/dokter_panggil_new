import 'dart:async';

import 'package:dokter_panggil/src/models/notifikasi_admin_model.dart';
import 'package:dokter_panggil/src/repositories/notifikasi_admin_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';

class NotifikasiAdminBloc {
  final _repo = NotifikasiAdminRepo();
  StreamController<ApiResponse<NotifikasiAdminModel>>? _streamNotifikasiAdmin;
  StreamSink<ApiResponse<NotifikasiAdminModel>> get notifikasiAdminSink =>
      _streamNotifikasiAdmin!.sink;
  Stream<ApiResponse<NotifikasiAdminModel>> get notifikasiAdminStream =>
      _streamNotifikasiAdmin!.stream;
  Future<void> getNotifikasi() async {
    _streamNotifikasiAdmin = StreamController();
    notifikasiAdminSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getNotifikasiAdmin();
      if (_streamNotifikasiAdmin!.isClosed) return;
      notifikasiAdminSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamNotifikasiAdmin!.isClosed) return;
      notifikasiAdminSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamNotifikasiAdmin?.close();
  }
}
