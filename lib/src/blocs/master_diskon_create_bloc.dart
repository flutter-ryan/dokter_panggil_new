import 'dart:async';

import 'package:dokter_panggil/src/models/master_diskon_create_model.dart';
import 'package:dokter_panggil/src/repositories/master_diskon_create_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterDiskonCreateBloc {
  final _repo = MasterDiskonCreateRepo();
  StreamController<ApiResponse<ResponseMasterDiskonCreateModel>>?
      _streamMasterDiskon;
  final BehaviorSubject<String> _filter = BehaviorSubject.seeded('');
  StreamSink<String> get filterSink => _filter.sink;
  StreamSink<ApiResponse<ResponseMasterDiskonCreateModel>>
      get masterDiskonSink => _streamMasterDiskon!.sink;
  Stream<ApiResponse<ResponseMasterDiskonCreateModel>> get masterDiskonStream =>
      _streamMasterDiskon!.stream;

  Future<void> getMasterDiskon() async {
    _streamMasterDiskon = StreamController();
    final filter = _filter.value;
    masterDiskonSink.add(ApiResponse.loading('Memuat...'));
    MasterDiskonCreateModel masterDiskonCreateModel =
        MasterDiskonCreateModel(filter: filter);
    try {
      final res = await _repo.getMasterDiskon(masterDiskonCreateModel);
      if (_streamMasterDiskon!.isClosed) return;
      masterDiskonSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterDiskon!.isClosed) return;
      masterDiskonSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _filter.close();
    _streamMasterDiskon?.close();
  }
}
