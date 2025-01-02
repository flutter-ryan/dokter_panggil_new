import 'dart:async';

import 'package:dokter_panggil/src/models/dokumen_rad_model.dart';
import 'package:dokter_panggil/src/repositories/dokumen_rad_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class DokumenRadBloc {
  final _repo = DokumenRadRepo();
  StreamController<ApiResponse<DokumenRadModel>>? _streamDokumenRad;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<ApiResponse<DokumenRadModel>> get dokumenRadSink =>
      _streamDokumenRad!.sink;
  Stream<ApiResponse<DokumenRadModel>> get dokumenRadStream =>
      _streamDokumenRad!.stream;
  Future<void> getDokumenRad() async {
    _streamDokumenRad = StreamController();
    final idKunjungan = _idKunjungan.value;
    dokumenRadSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getDokumenRad(idKunjungan);
      if (_streamDokumenRad!.isClosed) return;
      dokumenRadSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamDokumenRad!.isClosed) return;
      dokumenRadSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamDokumenRad?.close();
    _idKunjungan.close();
  }
}
