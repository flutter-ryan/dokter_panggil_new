import 'dart:async';

import 'package:dokter_panggil/src/models/update_sip_dokter_model.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/repositories/update_sip_dokter_repo.dart';
import 'package:rxdart/subjects.dart';

class UpdateSipDokterBloc {
  final _repo = UpdateSipDokterRepo();
  StreamController<ApiResponse<ResponseUpdateSipDokterModel>>? _streamUpdateSip;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<String> _nomor = BehaviorSubject();
  final BehaviorSubject<String> _tanggal = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<String> get nomorSink => _nomor.sink;
  StreamSink<String> get tanggalSink => _tanggal.sink;
  StreamSink<ApiResponse<ResponseUpdateSipDokterModel>> get updateSipSink =>
      _streamUpdateSip!.sink;
  Stream<ApiResponse<ResponseUpdateSipDokterModel>> get updateSipStream =>
      _streamUpdateSip!.stream;

  Future<void> updateSip() async {
    _streamUpdateSip = StreamController();
    final id = _id.value;
    final nomor = _nomor.value;
    final tanggal = _tanggal.value;
    updateSipSink.add(ApiResponse.loading('Memuat...'));
    UpdateSipDokterModel updateSipDokterModel =
        UpdateSipDokterModel(nomor: nomor, tanggal: tanggal);

    try {
      final res = await _repo.updateSip(id, updateSipDokterModel);
      if (_streamUpdateSip!.isClosed) return;
      updateSipSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamUpdateSip!.isClosed) return;
      updateSipSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamUpdateSip?.close();
    _nomor.close();
    _tanggal.close();
    _id.close();
  }
}
