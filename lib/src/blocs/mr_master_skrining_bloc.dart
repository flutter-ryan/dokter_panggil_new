import 'dart:async';

import 'package:dokter_panggil/src/models/mr_master_skrining_model.dart';
import 'package:dokter_panggil/src/repositories/mr_Master_skrining_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrMasterSkriningBloc {
  final _repo = MrMasterSkriningRepo();
  StreamController<ApiResponse<MrMasterSkriningModel>>? _streamMasterSkrining;
  final BehaviorSubject<String> _filter = BehaviorSubject.seeded('');
  StreamSink<String> get filterSink => _filter.sink;
  StreamSink<ApiResponse<MrMasterSkriningModel>> get masterSkriningSink =>
      _streamMasterSkrining!.sink;
  Stream<ApiResponse<MrMasterSkriningModel>> get masterSkriningStream =>
      _streamMasterSkrining!.stream;

  Future<void> getMasterSkrining() async {
    _streamMasterSkrining = StreamController();
    final filter = _filter.value;
    masterSkriningSink.add(ApiResponse.loading('Memuat...'));
    MrMasterSkriningRequestModel mrMasterSkriningRequestModel =
        MrMasterSkriningRequestModel(filter: filter);
    try {
      final res = await _repo.getMasterSkrining(mrMasterSkriningRequestModel);
      if (_streamMasterSkrining!.isClosed) return;
      masterSkriningSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterSkrining!.isClosed) return;
      masterSkriningSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamMasterSkrining?.close();
    _filter.close();
  }
}
