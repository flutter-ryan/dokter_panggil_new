import 'dart:async';

import 'package:admin_dokter_panggil/src/models/update_kunjungan_resep_tagihan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/repositories/update_kunjungan_bhp_tagihan_repo.dart';
import 'package:rxdart/subjects.dart';

class UpdateKunjunganBhpTagihanBloc {
  final _repo = UpdateKunjunganBhpTagihanRepo();
  StreamController<ApiResponse<ResponseUpdateKunjunganResepTagihanModel>>?
      _streamUpdateTagihanBhp;

  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<int> _jumlah = BehaviorSubject();
  StreamSink<int> get jumlahSink => _jumlah.sink;
  StreamSink<int> get idSink => _id.sink;
  StreamSink<ApiResponse<ResponseUpdateKunjunganResepTagihanModel>>
      get updateTagihanBhpSink => _streamUpdateTagihanBhp!.sink;
  Stream<ApiResponse<ResponseUpdateKunjunganResepTagihanModel>>
      get updateTagihanBhpStream => _streamUpdateTagihanBhp!.stream;
  Future<void> updateTagihanBhp() async {
    _streamUpdateTagihanBhp = StreamController();
    final jumlah = _jumlah.value;
    final id = _id.value;
    updateTagihanBhpSink.add(ApiResponse.loading('Memuat...'));
    UpdateKunjunganResepTagihanModel updateKunjunganResepTagihanModel =
        UpdateKunjunganResepTagihanModel(jumlah: jumlah);
    try {
      final res =
          await _repo.updateTagihanBhp(id, updateKunjunganResepTagihanModel);
      if (_streamUpdateTagihanBhp!.isClosed) return;
      updateTagihanBhpSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamUpdateTagihanBhp!.isClosed) return;
      updateTagihanBhpSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamUpdateTagihanBhp?.close();
    _id.close();
    _jumlah.close();
  }
}
