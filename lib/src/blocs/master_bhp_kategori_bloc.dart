import 'dart:async';

import 'package:admin_dokter_panggil/src/models/master_bhp_kategori_model.dart';
import 'package:admin_dokter_panggil/src/repositories/master_bhp_kategori_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MasterBhpKategoriBloc {
  final _repo = MasterBhpKategoriRepo();
  StreamController<ApiResponse<MasterBhpKategoriModel>>? _streamBhpKategori;
  final BehaviorSubject<int> _idKategori = BehaviorSubject();
  StreamSink<int> get idKategoriSink => _idKategori.sink;
  StreamSink<ApiResponse<MasterBhpKategoriModel>> get bhpKategoriSink =>
      _streamBhpKategori!.sink;
  Stream<ApiResponse<MasterBhpKategoriModel>> get bhpKategoriStream =>
      _streamBhpKategori!.stream;

  Future<void> getBhpKategori() async {
    _streamBhpKategori = StreamController();
    final idKategori = _idKategori.value;
    bhpKategoriSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getBhpKategori(idKategori);
      if (_streamBhpKategori!.isClosed) return;
      bhpKategoriSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBhpKategori!.isClosed) return;
      bhpKategoriSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamBhpKategori?.close();
  }
}
