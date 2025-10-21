import 'dart:async';

import 'package:admin_dokter_panggil/src/models/mr_pencarian_barang_farmasi_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mr_pencarian_barang_farmasi_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrPencarianBarangFarmasiBloc {
  MrPencarianBarangFarmasiModel? mrPencarianBarangFarmasiModel;
  int page = 1;
  final _repo = MrPencarianBarangFarmasiRepo();
  StreamController<ApiResponse<MrPencarianBarangFarmasiModel>>?
      _streamPencarianBarangFarmasi;
  final BehaviorSubject<String> _filter = BehaviorSubject.seeded('');
  StreamSink<String> get filterSink => _filter.sink;
  StreamSink<ApiResponse<MrPencarianBarangFarmasiModel>>
      get pencarianBarangFarmasiSink => _streamPencarianBarangFarmasi!.sink;
  Stream<ApiResponse<MrPencarianBarangFarmasiModel>>
      get pencarianBarangFarmasiStream => _streamPencarianBarangFarmasi!.stream;

  Future<void> pencarianBarangFarmasi() async {
    _streamPencarianBarangFarmasi = StreamController();
    final filter = _filter.value;
    pencarianBarangFarmasiSink.add(ApiResponse.loading('Memuat...'));
    MrPencarianBarangFarmasiRequestModel mrPencarianBarangFarmasiRequestModel =
        MrPencarianBarangFarmasiRequestModel(filter: filter);
    try {
      page = 1;
      final res = await _repo.pencarianBarangFarmasi(
          mrPencarianBarangFarmasiRequestModel, page);
      if (_streamPencarianBarangFarmasi!.isClosed) return;
      mrPencarianBarangFarmasiModel = res;
      pencarianBarangFarmasiSink
          .add(ApiResponse.completed(mrPencarianBarangFarmasiModel));
    } catch (e) {
      if (_streamPencarianBarangFarmasi!.isClosed) return;
      pencarianBarangFarmasiSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> nextPage() async {
    page += 1;
    final filter = _filter.value;
    MrPencarianBarangFarmasiRequestModel mrPencarianBarangFarmasiRequestModel =
        MrPencarianBarangFarmasiRequestModel(filter: filter);
    try {
      final res = await _repo.pencarianBarangFarmasi(
          mrPencarianBarangFarmasiRequestModel, page);
      if (_streamPencarianBarangFarmasi!.isClosed) return;
      mrPencarianBarangFarmasiModel!.data!.addAll(res.data!);
      pencarianBarangFarmasiSink
          .add(ApiResponse.completed(mrPencarianBarangFarmasiModel));
    } catch (e) {
      if (_streamPencarianBarangFarmasi!.isClosed) return;
      pencarianBarangFarmasiSink
          .add(ApiResponse.completed(mrPencarianBarangFarmasiModel));
    }
  }

  void dispose() {
    _streamPencarianBarangFarmasi?.close();
    _filter.close();
  }
}
