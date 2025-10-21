import 'dart:async';

import 'package:admin_dokter_panggil/src/models/tambah_perawat_model.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/repositories/tambah_perawat_repo.dart';
import 'package:rxdart/rxdart.dart';

class TambahPerawatBloc {
  final _repo = TambahPerawatRepo();
  StreamController<ApiResponse<TambahPerawatModel>>? _streamTambahPerawat;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  final BehaviorSubject<int> _idPetugas = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<int> get idPetugasSink => _idPetugas.sink;
  StreamSink<ApiResponse<TambahPerawatModel>> get tambahPerawatSink =>
      _streamTambahPerawat!.sink;
  Stream<ApiResponse<TambahPerawatModel>> get tambahPerawatStream =>
      _streamTambahPerawat!.stream;

  Future<void> tambahPerawat() async {
    _streamTambahPerawat = StreamController();
    final idKunjungan = _idKunjungan.value;
    final idPetugas = _idPetugas.value;
    tambahPerawatSink.add(ApiResponse.loading('Memuat...'));
    TambahPerawatRequestModel tambahPerawatRequestModel =
        TambahPerawatRequestModel(idPetugas: idPetugas);
    try {
      final res =
          await _repo.tambahPerawat(tambahPerawatRequestModel, idKunjungan);
      if (_streamTambahPerawat!.isClosed) return;
      tambahPerawatSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTambahPerawat!.isClosed) return;
      tambahPerawatSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamTambahPerawat?.close();
    _idKunjungan.close();
    _idPetugas.close();
  }
}
