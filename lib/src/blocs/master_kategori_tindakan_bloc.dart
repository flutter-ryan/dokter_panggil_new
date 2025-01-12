import 'dart:async';

import 'package:dokter_panggil/src/models/master_kategori_tindakan_model.dart';
import 'package:dokter_panggil/src/repositories/master_kategori_tindakan_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';

class MasterKategoriTindakanBloc {
  final _repo = MasterKategoriTindakanRepo();
  StreamController<ApiResponse<MasterKategoriTindakanModel>>?
      _streamKategoriTindakan;

  StreamSink<ApiResponse<MasterKategoriTindakanModel>>
      get kategoriTindakanSink => _streamKategoriTindakan!.sink;
  Stream<ApiResponse<MasterKategoriTindakanModel>> get kategoriTindakanStream =>
      _streamKategoriTindakan!.stream;

  Future<void> getKategoriTindakan() async {
    _streamKategoriTindakan = StreamController();
    kategoriTindakanSink.add(ApiResponse.loading('Mamuat...'));
    try {
      final res = await _repo.getKategoriTindakan();
      if (_streamKategoriTindakan!.isClosed) return;
      kategoriTindakanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKategoriTindakan!.isClosed) return;
      kategoriTindakanSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamKategoriTindakan?.close();
  }
}
