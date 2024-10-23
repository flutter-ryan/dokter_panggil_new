import 'dart:async';

import 'package:dokter_panggil/src/models/master_paket_create_model.dart';
import 'package:dokter_panggil/src/repositories/master_paket_create_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MasterPaketCreateBloc {
  final _repo = MasterPaketCreateRepo();
  StreamController<ApiResponse<ResponseMasterPaketCreateModel>>?
      _streamMasterPaketCreate;
  final BehaviorSubject<String> _filter = BehaviorSubject.seeded('');
  StreamSink<String> get filterSink => _filter.sink;
  StreamSink<ApiResponse<ResponseMasterPaketCreateModel>>
      get masterPaketCreateSink => _streamMasterPaketCreate!.sink;
  Stream<ApiResponse<ResponseMasterPaketCreateModel>>
      get masterPaketCreateStream => _streamMasterPaketCreate!.stream;

  Future<void> getMasterPaket() async {
    _streamMasterPaketCreate = StreamController();
    final filter = _filter.value;
    masterPaketCreateSink.add(ApiResponse.loading('Memuat...'));
    MasterPaketCreateModel masterPaketCreateModel =
        MasterPaketCreateModel(filter: filter);
    try {
      final res = await _repo.getMasterPaket(masterPaketCreateModel);
      if (_streamMasterPaketCreate!.isClosed) return;
      masterPaketCreateSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterPaketCreate!.isClosed) return;
      masterPaketCreateSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamMasterPaketCreate?.close();
    _filter.close();
  }
}
