import 'dart:async';

import 'package:dokter_panggil/src/models/profesi_filter_model.dart';
import 'package:dokter_panggil/src/repositories/profesi_filter_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class ProfesiFilterBloc {
  final ProfesiFilterRepo _repo = ProfesiFilterRepo();
  StreamController<ApiResponse<ResponseProfesiFilterModel>>?
      _streamProfesiFilter;
  final BehaviorSubject<String> _filter = BehaviorSubject.seeded('');
  StreamSink<String> get filterSink => _filter.sink;
  StreamSink<ApiResponse<ResponseProfesiFilterModel>> get profesiFilterSink =>
      _streamProfesiFilter!.sink;
  Stream<ApiResponse<ResponseProfesiFilterModel>> get profesiFilterStream =>
      _streamProfesiFilter!.stream;

  Future<void> filterProfesi() async {
    _streamProfesiFilter = StreamController();
    final filter = _filter.value;
    profesiFilterSink.add(ApiResponse.loading('Memuat...'));
    ProfesiFilterModel profesiFilterModel = ProfesiFilterModel(filter: filter);
    try {
      final res = await _repo.filterProfesi(profesiFilterModel);
      if (_streamProfesiFilter!.isClosed) return;
      profesiFilterSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamProfesiFilter!.isClosed) return;
      profesiFilterSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamProfesiFilter?.close();
    _filter.close();
  }
}
