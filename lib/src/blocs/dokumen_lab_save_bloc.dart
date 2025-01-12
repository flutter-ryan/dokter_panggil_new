import 'dart:async';

import 'package:dokter_panggil/src/models/dokumen_lab_save_model.dart';
import 'package:dokter_panggil/src/repositories/dokumen_lab_save_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class DokumenLabSaveBloc {
  final _repo = DokumenLabSaveRepo();
  StreamController<ApiResponse<DokumenLabSaveModel>>? _streamDokumenLab;
  final BehaviorSubject<int> _idDokumen = BehaviorSubject();
  final BehaviorSubject<int> _idPengantar = BehaviorSubject();
  final BehaviorSubject<String> _image = BehaviorSubject();
  final BehaviorSubject<String> _ext = BehaviorSubject();
  StreamSink<int> get idDokumenSink => _idDokumen.sink;
  StreamSink<int> get idPengantarSink => _idPengantar.sink;
  StreamSink<String> get imageSink => _image.sink;
  StreamSink<String> get extSink => _ext.sink;
  StreamSink<ApiResponse<DokumenLabSaveModel>> get dokumenLabSink =>
      _streamDokumenLab!.sink;
  Stream<ApiResponse<DokumenLabSaveModel>> get dokumenLabStream =>
      _streamDokumenLab!.stream;

  Future<void> simpanDokumenLab() async {
    _streamDokumenLab = StreamController();
    final idPengantar = _idPengantar.value;
    final image = _image.value;
    final ext = _ext.value;
    dokumenLabSink.add(ApiResponse.loading('Memuat...'));
    DokumenLabRequestModel dokumenLabRequestModel =
        DokumenLabRequestModel(image: image, ext: ext);
    try {
      final res =
          await _repo.saveDokumenLab(dokumenLabRequestModel, idPengantar);
      if (_streamDokumenLab!.isClosed) return;
      dokumenLabSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamDokumenLab!.isClosed) return;
      dokumenLabSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> deleteDokumenLab() async {
    _streamDokumenLab = StreamController();
    final idDokumen = _idDokumen.value;
    dokumenLabSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deleteDokumenLab(idDokumen);
      if (_streamDokumenLab!.isClosed) return;
      dokumenLabSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamDokumenLab!.isClosed) return;
      dokumenLabSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamDokumenLab?.close();
    _idDokumen.close();
    _idPengantar.close();
    _image.close();
    _ext.close();
  }
}
