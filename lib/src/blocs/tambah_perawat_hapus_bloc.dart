import 'dart:async';

import 'package:dokter_panggil/src/models/tambah_perawat_hapus_model.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/repositories/tambah_perawat_repo.dart';
import 'package:rxdart/rxdart.dart';

class TambahPerawatHapusBloc {
  final _repo = TambahPerawatRepo();
  StreamController<ApiResponse<TambahPerawatHapusModel>>? _streamHapusPerawat;
  final BehaviorSubject<int> _idKofirmasiPerawat = BehaviorSubject();
  StreamSink<int> get idKonfirmasiPerawatSink => _idKofirmasiPerawat.sink;
  StreamSink<ApiResponse<TambahPerawatHapusModel>> get hapusPerawatSink =>
      _streamHapusPerawat!.sink;
  Stream<ApiResponse<TambahPerawatHapusModel>> get hapusPerawatStream =>
      _streamHapusPerawat!.stream;

  Future<void> hapusPerawat() async {
    _streamHapusPerawat = StreamController();
    final idKonfirmasiPerawat = _idKofirmasiPerawat.value;
    hapusPerawatSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.hapusPerawat(idKonfirmasiPerawat);
      if (_streamHapusPerawat!.isClosed) return;
      hapusPerawatSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamHapusPerawat!.isClosed) return;
      hapusPerawatSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamHapusPerawat?.close();
    _idKofirmasiPerawat.close();
  }
}
