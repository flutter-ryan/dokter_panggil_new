import 'dart:async';

import 'package:dokter_panggil/src/models/pencarian_master_tindakan_group_model.dart';
import 'package:dokter_panggil/src/models/tindakan_filter_model.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/repositories/tindakan_filter_repo.dart';
import 'package:rxdart/subjects.dart';

class TindakanFilterBloc {
  final TindakanFilterRepo _repo = TindakanFilterRepo();
  StreamController<ApiResponse<ResponseTindakanFilterModel>>?
      _streamTindakanFilter;
  final BehaviorSubject<String> _filter = BehaviorSubject.seeded('');
  final BehaviorSubject<int?> _idGroup = BehaviorSubject.seeded(null);
  StreamSink<String> get filterSink => _filter.sink;
  StreamSink<int?> get idGroupSink => _idGroup.sink;
  StreamSink<ApiResponse<ResponseTindakanFilterModel>> get tindakanFilterSink =>
      _streamTindakanFilter!.sink;
  Stream<ApiResponse<ResponseTindakanFilterModel>> get tindakanFilterStream =>
      _streamTindakanFilter!.stream;

  Future<void> tindakanFilter() async {
    _streamTindakanFilter = StreamController();
    final filter = _filter.value;
    tindakanFilterSink.add(ApiResponse.loading('Memuat...'));
    TindakanFilterModel tindakanFilterModel =
        TindakanFilterModel(filter: filter);
    try {
      final res = await _repo.filterTindakan(tindakanFilterModel);
      if (_streamTindakanFilter!.isClosed) return;
      tindakanFilterSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTindakanFilter!.isClosed) return;
      tindakanFilterSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> filterTindakanGroup() async {
    _streamTindakanFilter = StreamController();
    final filter = _filter.value;
    final idGroup = _idGroup.value;
    tindakanFilterSink.add(ApiResponse.loading('Memuat...'));
    PencarianMasterTindakanGroupModel pencarianMasterTindakanGroupModel =
        PencarianMasterTindakanGroupModel(filter: filter, idGroup: idGroup!);
    try {
      final res =
          await _repo.filterTindakanGroup(pencarianMasterTindakanGroupModel);
      if (_streamTindakanFilter!.isClosed) return;
      tindakanFilterSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTindakanFilter!.isClosed) return;
      tindakanFilterSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamTindakanFilter?.close();
    _filter.close();
    _idGroup.close();
  }
}
