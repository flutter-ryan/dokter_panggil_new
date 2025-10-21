import 'dart:async';

import 'package:admin_dokter_panggil/src/models/update_kunjungan_resep_tagihan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/repositories/update_kunjungan_resep_racikan_tagihan_repo.dart';
import 'package:rxdart/subjects.dart';

class UpdateKunjunganResepRacikanTagihanBloc {
  final _repo = UpdateKunjunganResepRacikanTagihanRepo();
  StreamController<ApiResponse<ResponseUpdateKunjunganResepTagihanModel>>?
      _streaUpdateTagihanResepRacikan;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<int> _jumlah = BehaviorSubject();
  StreamSink<int> get jumlahSink => _jumlah.sink;
  StreamSink<int> get idSink => _id.sink;
  StreamSink<ApiResponse<ResponseUpdateKunjunganResepTagihanModel>>
      get updateTagihanResepRacikanSink =>
          _streaUpdateTagihanResepRacikan!.sink;
  Stream<ApiResponse<ResponseUpdateKunjunganResepTagihanModel>>
      get updateTagihanResepRacikanStream =>
          _streaUpdateTagihanResepRacikan!.stream;

  Future<void> updateTagihanResepRacikan() async {
    _streaUpdateTagihanResepRacikan = StreamController();
    final jumlah = _jumlah.value;
    final id = _id.value;
    updateTagihanResepRacikanSink.add(ApiResponse.loading('Memuat...'));
    UpdateKunjunganResepTagihanModel updateKunjunganResepTagihanModel =
        UpdateKunjunganResepTagihanModel(jumlah: jumlah);
    try {
      final res = await _repo.updateTagihanResepRacikan(
          id, updateKunjunganResepTagihanModel);
      if (_streaUpdateTagihanResepRacikan!.isClosed) return;
      updateTagihanResepRacikanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streaUpdateTagihanResepRacikan!.isClosed) return;
      updateTagihanResepRacikanSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streaUpdateTagihanResepRacikan?.close();
    _id.close();
    _jumlah.close();
  }
}
