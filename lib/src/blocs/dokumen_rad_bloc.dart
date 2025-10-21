import 'dart:async';

import 'package:admin_dokter_panggil/src/models/dokumen_rad_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dokumen_rad_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class DokumenRadBloc {
  final _repo = DokumenRadRepo();
  StreamController<ApiResponse<DokumenRadModel>>? _streamDokumenRad;
  final BehaviorSubject<int> _idPengantar = BehaviorSubject();
  StreamSink<int> get idPengantarSink => _idPengantar.sink;
  StreamSink<ApiResponse<DokumenRadModel>> get dokumenRadSink =>
      _streamDokumenRad!.sink;
  Stream<ApiResponse<DokumenRadModel>> get dokumenRadStream =>
      _streamDokumenRad!.stream;
  Future<void> getDokumenRad() async {
    _streamDokumenRad = StreamController();
    final idPengantar = _idPengantar.value;
    dokumenRadSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getDokumenRad(idPengantar);
      if (_streamDokumenRad!.isClosed) return;
      dokumenRadSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamDokumenRad!.isClosed) return;
      dokumenRadSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamDokumenRad?.close();
    _idPengantar.close();
  }
}
