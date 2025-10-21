import 'dart:async';

import 'package:admin_dokter_panggil/src/models/barang_farmasi_filter_model.dart';
import 'package:admin_dokter_panggil/src/repositories/barnag_farmasi_filter_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class BarangFarmasiFilterBloc {
  final BarangFarmasiFilterRepo _repo = BarangFarmasiFilterRepo();
  StreamController<ApiResponse<ResponseBarangFarmasiFilterModel>>?
      _streamBarangFarmasi;
  final BehaviorSubject<String> _filter = BehaviorSubject.seeded('');
  StreamSink<String> get filterSink => _filter.sink;
  StreamSink<ApiResponse<ResponseBarangFarmasiFilterModel>>
      get barangFarmasiSink => _streamBarangFarmasi!.sink;
  Stream<ApiResponse<ResponseBarangFarmasiFilterModel>>
      get barangFarmasiStream => _streamBarangFarmasi!.stream;

  Future<void> filterBarangFarmasi() async {
    _streamBarangFarmasi = StreamController();
    final filter = _filter.value;
    barangFarmasiSink.add(ApiResponse.loading('Memuat...'));
    BarangFarmasiFilterModel barangFarmasiFilterModel =
        BarangFarmasiFilterModel(filter: filter);
    try {
      final res = await _repo.filterBarangFarmasi(barangFarmasiFilterModel);
      if (_streamBarangFarmasi!.isClosed) return;
      barangFarmasiSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBarangFarmasi!.isClosed) return;
      barangFarmasiSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamBarangFarmasi?.close();
    _filter.close();
  }
}
