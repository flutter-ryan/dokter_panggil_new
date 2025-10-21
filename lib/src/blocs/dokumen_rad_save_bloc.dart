import 'dart:async';

import 'package:admin_dokter_panggil/src/models/dokumen_rad_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dokumen_rad_save_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class DokumenRadSaveBloc {
  final _repo = DokumenRadSaveRepo();
  StreamController<ApiResponse<DokumenRadSaveModel>>? _streamDokumenRadSave;
  final BehaviorSubject<int> _idPengantar = BehaviorSubject();
  final BehaviorSubject<int> _idDokumen = BehaviorSubject();
  final BehaviorSubject<String> _image = BehaviorSubject();
  final BehaviorSubject<String> _ext = BehaviorSubject();
  StreamSink<int> get idPengantarSink => _idPengantar.sink;
  StreamSink<int> get idDokumenSink => _idDokumen.sink;
  StreamSink<String> get imageSink => _image.sink;
  StreamSink<String> get extSink => _ext.sink;
  StreamSink<ApiResponse<DokumenRadSaveModel>> get dokumenRadSaveSink =>
      _streamDokumenRadSave!.sink;
  Stream<ApiResponse<DokumenRadSaveModel>> get dokumenRadSaveStream =>
      _streamDokumenRadSave!.stream;

  Future<void> uploadDokumenRad() async {
    _streamDokumenRadSave = StreamController();
    final idPengantar = _idPengantar.value;
    final image = _image.value;
    final ext = _ext.value;
    dokumenRadSaveSink.add(ApiResponse.loading('Memuat...'));
    DokumenRadRequestModel dokumenRadRequestModel =
        DokumenRadRequestModel(image: image, ext: ext);
    try {
      final res =
          await _repo.uploadDokumenRad(dokumenRadRequestModel, idPengantar);
      if (_streamDokumenRadSave!.isClosed) return;
      dokumenRadSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamDokumenRadSave!.isClosed) return;
      dokumenRadSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> hapusDokumenRad() async {
    _streamDokumenRadSave = StreamController();
    final idDokumen = _idDokumen.value;
    dokumenRadSaveSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deleteDokumenRad(idDokumen);
      if (_streamDokumenRadSave!.isClosed) return;
      dokumenRadSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamDokumenRadSave!.isClosed) return;
      dokumenRadSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamDokumenRadSave?.close();
    _idDokumen.close();
    _idPengantar.close();
    _image.close();
    _ext.close();
  }
}
