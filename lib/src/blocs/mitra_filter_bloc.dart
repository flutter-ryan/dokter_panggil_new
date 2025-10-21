import 'dart:async';

import 'package:admin_dokter_panggil/src/models/mitra_filter_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mitra_filter_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MitraFilterBloc {
  final MitraFilterRepo _repo = MitraFilterRepo();
  StreamController<ApiResponse<ResponseMitraFilterModel>>? _streamFilterMitra;
  final BehaviorSubject<String> _filter = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _jenis = BehaviorSubject.seeded('');
  StreamSink<String> get filterSink => _filter.sink;
  StreamSink<String> get jenisSink => _jenis.sink;
  StreamSink<ApiResponse<ResponseMitraFilterModel>> get filterMitraSink =>
      _streamFilterMitra!.sink;
  Stream<ApiResponse<ResponseMitraFilterModel>> get filterMitraStream =>
      _streamFilterMitra!.stream;

  Future<void> filterMitra() async {
    _streamFilterMitra = StreamController();
    final filter = _filter.value;
    final jenis = _jenis.value;
    filterMitraSink.add(ApiResponse.loading('Memuat...'));
    MitraFilterModel mitraFilterModel =
        MitraFilterModel(filter: filter, jenis: jenis);
    try {
      final response = await _repo.filterMitra(mitraFilterModel);
      if (_streamFilterMitra!.isClosed) return;
      filterMitraSink.add(ApiResponse.completed(response));
    } catch (e) {
      if (_streamFilterMitra!.isClosed) return;
      filterMitraSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamFilterMitra?.close();
    _filter.close();
  }
}
