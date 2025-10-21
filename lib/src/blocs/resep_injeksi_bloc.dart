import 'dart:async';

import 'package:admin_dokter_panggil/src/models/resep_injeksi_model.dart';
import 'package:admin_dokter_panggil/src/repositories/resep_injeksi_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class ResepInjeksiBloc {
  final _repo = ResepInjeksiRepo();
  StreamController<ApiResponse<ResepInjeksiModel>>? _streamResepInjeksi;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  final BehaviorSubject<int> _idDokter = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<int> get idDokterSink => _idDokter.sink;
  StreamSink<ApiResponse<ResepInjeksiModel>> get resepInjeksiSink =>
      _streamResepInjeksi!.sink;
  Stream<ApiResponse<ResepInjeksiModel>> get resepInjeksiStream =>
      _streamResepInjeksi!.stream;

  Future<void> getResepInjeksi() async {
    _streamResepInjeksi = StreamController();
    final idKunjungan = _idKunjungan.value;
    final idDokter = _idDokter.value;
    resepInjeksiSink.add(ApiResponse.loading("Memuat..."));
    ResepInjeksiRequestModel resepInjeksiRequestModel =
        ResepInjeksiRequestModel(idKunjungan: idKunjungan, idDokter: idDokter);
    try {
      final res = await _repo.getResepInjeksi(resepInjeksiRequestModel);
      if (_streamResepInjeksi!.isClosed) return;
      resepInjeksiSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamResepInjeksi!.isClosed) return;
      resepInjeksiSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamResepInjeksi?.close();
    _idKunjungan.close();
    _idDokter.close();
  }
}
