import 'dart:async';

import 'package:dokter_panggil/src/models/kunjungan_racikan_update_model.dart';
import 'package:dokter_panggil/src/repositories/kunjungan_racikan_update_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class KunjunganRacikanUpdateBloc {
  final _repo = KunjunganRacikanUpdateRepo();
  StreamController<ApiResponse<ResponseKunjunganRacikanUpdateModel>>?
      _streamRacikanUpdate;

  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<int> _jumlah = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<int> get jumlahSink => _jumlah.sink;
  StreamSink<ApiResponse<ResponseKunjunganRacikanUpdateModel>>
      get racikanUpdateSink => _streamRacikanUpdate!.sink;
  Stream<ApiResponse<ResponseKunjunganRacikanUpdateModel>>
      get racikanUpdateStream => _streamRacikanUpdate!.stream;

  Future<void> updateRacikan() async {
    _streamRacikanUpdate = StreamController();
    final id = _id.value;
    final jumlah = _jumlah.value;
    racikanUpdateSink.add(ApiResponse.loading('Memuat...'));
    KunjunganRacikanUpdateModel kunjunganRacikanUpdateModel =
        KunjunganRacikanUpdateModel(jumlah: jumlah);
    try {
      final res = await _repo.updateRacikan(kunjunganRacikanUpdateModel, id);
      if (_streamRacikanUpdate!.isClosed) return;
      racikanUpdateSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamRacikanUpdate!.isClosed) return;
      racikanUpdateSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispoe() {
    _streamRacikanUpdate?.close();
    _id.close();
    _jumlah.close();
  }
}
