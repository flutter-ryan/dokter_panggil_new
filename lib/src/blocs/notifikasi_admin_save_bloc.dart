import 'dart:async';

import 'package:dokter_panggil/src/models/notifikasi_admin_save_model.dart';
import 'package:dokter_panggil/src/repositories/notifikasi_admin_save_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class NotifikasiAdminSaveBloc {
  final _repo = NotifikasiAdminSaveRepo();
  StreamController<ApiResponse<NotifikasiAdminSaveModel>>?
      _streamNotifikasiSave;
  final BehaviorSubject<int> _idNotifikasi = BehaviorSubject();
  StreamSink<int> get idNotifikasiSink => _idNotifikasi.sink;
  StreamSink<ApiResponse<NotifikasiAdminSaveModel>> get notifikasiSaveSink =>
      _streamNotifikasiSave!.sink;
  Stream<ApiResponse<NotifikasiAdminSaveModel>> get notifikasiSaveStream =>
      _streamNotifikasiSave!.stream;

  Future<void> updateNotifikasi() async {
    _streamNotifikasiSave = StreamController();
    final idNotifikasi = _idNotifikasi.value;
    notifikasiSaveSink.add(ApiResponse.loading('Memuat...'));
    NotifikasiAdminSaveRequestModel notifikasiAdminSaveRequestModel =
        NotifikasiAdminSaveRequestModel(isRead: 1);
    try {
      final res = await _repo.updateNotifikasi(
          notifikasiAdminSaveRequestModel, idNotifikasi);
      if (_streamNotifikasiSave!.isClosed) return;
      notifikasiSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamNotifikasiSave!.isClosed) return;
      notifikasiSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamNotifikasiSave?.close();
    _idNotifikasi.close();
  }
}
