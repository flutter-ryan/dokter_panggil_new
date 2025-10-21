import 'dart:async';

import 'package:admin_dokter_panggil/src/models/kunjungan_tindakan_update_model.dart';
import 'package:admin_dokter_panggil/src/repositories/kunjungan_tindakan_update_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class KunjunganTindakanUpdateBloc {
  final _repo = KunjunganTindakanUpdateRepo();
  StreamController<ApiResponse<ResponseKunjunganTindakanUpdateModel>>?
      _streamKunjunganTindakanUpdate;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<int> _quantity = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<int> get quantitySink => _quantity.sink;
  StreamSink<ApiResponse<ResponseKunjunganTindakanUpdateModel>>
      get kunjunganTindakanUpdateSink => _streamKunjunganTindakanUpdate!.sink;
  Stream<ApiResponse<ResponseKunjunganTindakanUpdateModel>>
      get kunjunganTindakanUpdateStream =>
          _streamKunjunganTindakanUpdate!.stream;
  Future<void> updateKunjunganTindakan() async {
    _streamKunjunganTindakanUpdate = StreamController();
    final id = _id.value;
    final quantity = _quantity.value;
    kunjunganTindakanUpdateSink.add(ApiResponse.loading('Memuat...'));
    KunjunganTindakanUpdateModel kunjunganTindakanUpdateModel =
        KunjunganTindakanUpdateModel(quantity: quantity);
    try {
      final res =
          await _repo.updateKunjunganTindakan(kunjunganTindakanUpdateModel, id);
      if (_streamKunjunganTindakanUpdate!.isClosed) return;
      kunjunganTindakanUpdateSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKunjunganTindakanUpdate!.isClosed) return;
      kunjunganTindakanUpdateSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamKunjunganTindakanUpdate?.close();
    _id.close();
    _quantity.close();
  }
}
