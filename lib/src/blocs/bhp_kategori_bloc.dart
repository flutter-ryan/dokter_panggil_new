import 'dart:async';

import 'package:dokter_panggil/src/models/bhp_kategori_model.dart';
import 'package:dokter_panggil/src/repositories/bhp_kategori_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';

class BhpKategoriBloc {
  final _repo = BhpKategoriRepo();
  late StreamController<ApiResponse<BhpKategoriModel>> _streamBhpKategori;

  StreamSink<ApiResponse<BhpKategoriModel>> get bhpKategoriSink =>
      _streamBhpKategori.sink;
  Stream<ApiResponse<BhpKategoriModel>> get bhpKategoriStream =>
      _streamBhpKategori.stream;

  Future<void> getBhpKategori() async {
    _streamBhpKategori = StreamController();
    bhpKategoriSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getBhpKategori();
      if (_streamBhpKategori.isClosed) return;
      bhpKategoriSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBhpKategori.isClosed) return;
      bhpKategoriSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamBhpKategori.close();
  }
}
