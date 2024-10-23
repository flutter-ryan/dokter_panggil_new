import 'dart:async';

import 'package:dokter_panggil/src/models/barang_fetch_model.dart';
import 'package:dokter_panggil/src/repositories/barang_fetch_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class BarangFetchBloc {
  BarangFetchModel? data;
  int initialPage = 1;
  int nextPage = 1;
  final BarangFetchRepo _repo = BarangFetchRepo();
  StreamController<ApiResponse<BarangFetchModel>>? _streamBarangFetch;
  final BehaviorSubject<String> _filter = BehaviorSubject.seeded('');
  StreamSink<String> get filterSink => _filter.sink;
  StreamSink<ApiResponse<BarangFetchModel>> get barangFetchSink =>
      _streamBarangFetch!.sink;
  Stream<ApiResponse<BarangFetchModel>> get barangFetchStream =>
      _streamBarangFetch!.stream;

  Future<void> fetchBarang() async {
    _streamBarangFetch = StreamController();
    final filter = _filter.value;
    barangFetchSink.add(ApiResponse.loading('Memuat...'));
    FilterBarangFetchModel filterBarangFetchModel =
        FilterBarangFetchModel(filter: filter);
    try {
      final res = await _repo.fetchBarang(filterBarangFetchModel, initialPage);
      if (_streamBarangFetch!.isClosed) return;
      data = res;
      barangFetchSink.add(ApiResponse.completed(data));
      nextPage = initialPage + 1;
    } catch (e) {
      if (_streamBarangFetch!.isClosed) return;
      barangFetchSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> fetchNextBarang() async {
    final filter = _filter.value;
    FilterBarangFetchModel filterBarangFetchModel =
        FilterBarangFetchModel(filter: filter);
    try {
      final res = await _repo.fetchBarang(filterBarangFetchModel, nextPage);
      if (_streamBarangFetch!.isClosed) return;
      data!.barang!.addAll(res.barang!);
      data!.currentPage = res.currentPage;
      data!.totalPage = res.totalPage;
      barangFetchSink.add(ApiResponse.completed(data));
      nextPage = nextPage + 1;
    } catch (e) {
      if (_streamBarangFetch!.isClosed) return;
      barangFetchSink.add(ApiResponse.completed(data));
    }
  }

  dispose() {
    _streamBarangFetch!.close();
    _filter.close();
  }
}
