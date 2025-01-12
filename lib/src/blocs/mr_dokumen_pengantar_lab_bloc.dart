import 'dart:async';

import 'package:dokter_panggil/src/models/mr_dokumen_pengantar_lab_model.dart';
import 'package:dokter_panggil/src/repositories/mr_dokumen_pengantar_lab_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrDokumenPengantarLabBloc {
  final _repo = MrDokumenPengantarLabRepo();
  StreamController<ApiResponse<MrDokumenPengantarLabModel>>?
      _streamDokumenPengantarLab;

  final BehaviorSubject<int> _idPengantar = BehaviorSubject();
  StreamSink<int> get idPengantarSink => _idPengantar.sink;
  StreamSink<ApiResponse<MrDokumenPengantarLabModel>>
      get dokumenPengantarLabSink => _streamDokumenPengantarLab!.sink;
  Stream<ApiResponse<MrDokumenPengantarLabModel>>
      get dokumenPengantarLabStream => _streamDokumenPengantarLab!.stream;

  Future<void> getDokumenPengantarLab() async {
    _streamDokumenPengantarLab = StreamController();
    final idPengantar = _idPengantar.value;
    dokumenPengantarLabSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getDokumenPengantarLab(idPengantar);
      if (_streamDokumenPengantarLab!.isClosed) return;
      dokumenPengantarLabSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamDokumenPengantarLab!.isClosed) return;
      dokumenPengantarLabSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamDokumenPengantarLab?.close();
    _idPengantar.close();
  }
}
