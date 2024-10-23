import 'dart:async';

import 'package:dokter_panggil/src/models/diagnosa_filter_model.dart';
import 'package:dokter_panggil/src/repositories/diagnosa_filter_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class DiagnosaFilterBloc {
  final DiagnosaFilterRepo _repo = DiagnosaFilterRepo();
  StreamController<ApiResponse<ResponseDiagnosaFilterModel>>?
      _streamDiagnosaFilter;
  final BehaviorSubject<String> _filter = BehaviorSubject.seeded('');
  StreamSink<String> get filterSink => _filter.sink;
  StreamSink<ApiResponse<ResponseDiagnosaFilterModel>> get diagnosaFilterSink =>
      _streamDiagnosaFilter!.sink;
  Stream<ApiResponse<ResponseDiagnosaFilterModel>> get diagnosaFilterStream =>
      _streamDiagnosaFilter!.stream;

  Future<void> filterDiagnosa() async {
    _streamDiagnosaFilter = StreamController();
    final filter = _filter.value;
    diagnosaFilterSink.add(ApiResponse.loading('Memuat...'));
    DiagnosaFilterModel diagnosaFilterModel =
        DiagnosaFilterModel(filter: filter);
    try {
      final res = await _repo.filterDiagnosa(diagnosaFilterModel);
      if (_streamDiagnosaFilter!.isClosed) return;
      diagnosaFilterSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamDiagnosaFilter!.isClosed) return;
      diagnosaFilterSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamDiagnosaFilter?.close();
    _filter.close();
  }
}
