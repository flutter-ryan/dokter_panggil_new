import 'dart:async';

import 'package:dokter_panggil/src/models/laporan_harian_model.dart';
import 'package:dokter_panggil/src/repositories/laporan_harian_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class LaporanHarianBloc {
  List<LaporanHarian> data = [];
  final _repo = LaporanHarianRepo();
  StreamController<ApiResponse<List<LaporanHarian>>>? _streamLaporanHarian;
  StreamController<ApiResponse<ResponseLaporanHarianRequestModel>>?
      _streamLaporanHarianRequest;
  final BehaviorSubject<String> _from = BehaviorSubject();
  final BehaviorSubject<String> _to = BehaviorSubject();
  final BehaviorSubject<String> _convert = BehaviorSubject.seeded('pdf');
  StreamSink<String> get fromSink => _from.sink;
  StreamSink<String> get toSink => _to.sink;
  StreamSink<String> get convertSink => _convert.sink;
  StreamSink<ApiResponse<ResponseLaporanHarianRequestModel>>
      get laporanHarianRequestSink => _streamLaporanHarianRequest!.sink;
  StreamSink<ApiResponse<List<LaporanHarian>>> get laporanHarianSink =>
      _streamLaporanHarian!.sink;
  Stream<ApiResponse<List<LaporanHarian>>> get laporanHarianStream =>
      _streamLaporanHarian!.stream;
  Stream<ApiResponse<ResponseLaporanHarianRequestModel>>
      get laporanHarianRequestStream => _streamLaporanHarianRequest!.stream;

  Future<void> getLaporanHarian() async {
    _streamLaporanHarian = StreamController();
    laporanHarianSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getLaporanHarian();
      data = res.data!;
      if (_streamLaporanHarian!.isClosed) return;
      laporanHarianSink.add(ApiResponse.completed(data));
    } catch (e) {
      if (_streamLaporanHarian!.isClosed) return;
      laporanHarianSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> saveLaporanHarian() async {
    _streamLaporanHarianRequest = StreamController();
    final from = _from.value;
    final to = _to.value;
    final convert = _convert.value;
    laporanHarianRequestSink.add(ApiResponse.loading('Memuat...'));
    LaporanHarianRequestModel laporanHarianRequestModel =
        LaporanHarianRequestModel(from: from, to: to, convert: convert);
    try {
      final res = await _repo.saveLaporanHarian(laporanHarianRequestModel);
      if (_streamLaporanHarianRequest!.isClosed) return;
      data.insert(0, res.data!);
      laporanHarianRequestSink.add(ApiResponse.completed(res));
      laporanHarianSink.add(ApiResponse.completed(data));
    } catch (e) {
      if (_streamLaporanHarianRequest!.isClosed) return;
      laporanHarianRequestSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamLaporanHarianRequest?.close();
    _from.close();
    _to.close();
    _streamLaporanHarian?.close();
  }
}
