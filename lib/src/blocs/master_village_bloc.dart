import 'dart:async';

import 'package:admin_dokter_panggil/src/models/master_village_model.dart';
import 'package:admin_dokter_panggil/src/repositories/master_village_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MasterVillageBloc {
  final _repo = MasterVillageRepo();
  StreamController<ApiResponse<MasterVillageModel>>? _streamMasterVillage;
  final BehaviorSubject<String> _filter = BehaviorSubject.seeded('');
  StreamSink<String> get filterSink => _filter.sink;
  StreamSink<ApiResponse<MasterVillageModel>> get masterVillageSink =>
      _streamMasterVillage!.sink;
  Stream<ApiResponse<MasterVillageModel>> get masterVillageStream =>
      _streamMasterVillage!.stream;

  Future<void> getMasterVillage() async {
    _streamMasterVillage = StreamController();
    final filter = _filter.value;
    masterVillageSink.add(ApiResponse.loading('Memuat...'));
    MasterVillageRequestModel masterVillageRequestModel =
        MasterVillageRequestModel(filter: filter);
    try {
      final res = await _repo.getMasterVillage(masterVillageRequestModel);
      if (_streamMasterVillage!.isClosed) return;
      masterVillageSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterVillage!.isClosed) return;
      masterVillageSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamMasterVillage?.close();
    _filter.close();
  }
}
