import 'dart:async';

import 'package:admin_dokter_panggil/src/models/pasien_filter_model.dart';
import 'package:admin_dokter_panggil/src/repositories/pasien_filter_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class PasienFilterBloc {
  final PasienFilterRepo _repo = PasienFilterRepo();
  StreamController<ApiResponse<ResponsePasienFilterModel>>? _streamPasienFilter;
  final BehaviorSubject<String> _filter = BehaviorSubject.seeded('');
  StreamSink<String> get filterSink => _filter.sink;
  StreamSink<ApiResponse<ResponsePasienFilterModel>> get pasienFilterSink =>
      _streamPasienFilter!.sink;
  Stream<ApiResponse<ResponsePasienFilterModel>> get pasienFilterStream =>
      _streamPasienFilter!.stream;

  Future<void> filterPasien() async {
    _streamPasienFilter = StreamController();
    final filter = _filter.value;
    pasienFilterSink.add(ApiResponse.loading('Memuat...'));
    PasienFilterModel pasienFilterModel = PasienFilterModel(filter: filter);
    try {
      final res = await _repo.filterPasien(pasienFilterModel);
      if (_streamPasienFilter!.isClosed) return;
      pasienFilterSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPasienFilter!.isClosed) return;
      pasienFilterSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamPasienFilter?.close();
    _filter.close();
  }
}
