import 'dart:async';

import 'package:admin_dokter_panggil/src/models/pegawai_search_model.dart';
import 'package:admin_dokter_panggil/src/repositories/pegawai_search_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class PegawaiSearchBloc {
  final PegawaiSearchRepo _repo = PegawaiSearchRepo();
  StreamController<ApiResponse<ResultPegawaiSearchModel>>? _streamPegawaiSearch;
  final BehaviorSubject<String> _filter = BehaviorSubject.seeded('');
  StreamSink<String> get filterSink => _filter.sink;
  StreamSink<ApiResponse<ResultPegawaiSearchModel>> get pegawaiSearchSink =>
      _streamPegawaiSearch!.sink;
  Stream<ApiResponse<ResultPegawaiSearchModel>> get pegawaiSearchStream =>
      _streamPegawaiSearch!.stream;

  Future<void> filter() async {
    _streamPegawaiSearch = StreamController();
    final filter = _filter.value;
    pegawaiSearchSink.add(ApiResponse.loading('Memaut...'));
    PegawaiSearchModel pegawaiSearchModel = PegawaiSearchModel(filter: filter);
    try {
      final res = await _repo.filterPegawai(pegawaiSearchModel);
      if (_streamPegawaiSearch!.isClosed) return;
      pegawaiSearchSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPegawaiSearch!.isClosed) return;
      pegawaiSearchSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamPegawaiSearch?.close();
    _filter.close();
  }
}
