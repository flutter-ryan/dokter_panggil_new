import 'dart:async';

import 'package:admin_dokter_panggil/src/models/tindakan_lab_tagihan_modal.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/repositories/tindakan_lab_tagihan_repo.dart';

class TindakanLabTagihanBloc {
  final _repo = TindakanLabTagihanRepo();
  StreamController<ApiResponse<TindakanLabTagihanModel>>?
      _streamTindakanLabTagihan;
  StreamSink<ApiResponse<TindakanLabTagihanModel>> get tindakanLabTagihanSink =>
      _streamTindakanLabTagihan!.sink;
  Stream<ApiResponse<TindakanLabTagihanModel>> get tindakanLabTagihanStream =>
      _streamTindakanLabTagihan!.stream;

  Future<void> getTindakanLabTagihan() async {
    _streamTindakanLabTagihan = StreamController();
    tindakanLabTagihanSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getTindakanLabTagihan();
      if (_streamTindakanLabTagihan!.isClosed) return;
      tindakanLabTagihanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTindakanLabTagihan!.isClosed) return;
      tindakanLabTagihanSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamTindakanLabTagihan?.close();
  }
}
