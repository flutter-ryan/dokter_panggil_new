import 'dart:async';

import 'package:dokter_panggil/src/models/update_kunjungan_resep_tagihan_model.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/repositories/update_kunjungan_resep_tagihan_repo.dart';
import 'package:rxdart/subjects.dart';

class UpdateKunjunganResepTagihanBloc {
  final _repo = UpdateKunjunganResepTagihanRepo();
  StreamController<ApiResponse<ResponseUpdateKunjunganResepTagihanModel>>?
      _streaUpdateTagihanResep;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<int> _jumlah = BehaviorSubject();
  StreamSink<int> get jumlahSink => _jumlah.sink;
  StreamSink<int> get idSink => _id.sink;
  StreamSink<ApiResponse<ResponseUpdateKunjunganResepTagihanModel>>
      get updateTagihanResepSink => _streaUpdateTagihanResep!.sink;
  Stream<ApiResponse<ResponseUpdateKunjunganResepTagihanModel>>
      get updateTagihanResepStream => _streaUpdateTagihanResep!.stream;

  Future<void> updateTagihanResep() async {
    _streaUpdateTagihanResep = StreamController();
    final jumlah = _jumlah.value;
    final id = _id.value;
    updateTagihanResepSink.add(ApiResponse.loading('Memuat...'));
    UpdateKunjunganResepTagihanModel updateKunjunganResepTagihanModel =
        UpdateKunjunganResepTagihanModel(jumlah: jumlah);
    try {
      final res =
          await _repo.updateTagihanResep(id, updateKunjunganResepTagihanModel);
      if (_streaUpdateTagihanResep!.isClosed) return;
      updateTagihanResepSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streaUpdateTagihanResep!.isClosed) return;
      updateTagihanResepSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streaUpdateTagihanResep?.close();
    _id.close();
    _jumlah.close();
  }
}
