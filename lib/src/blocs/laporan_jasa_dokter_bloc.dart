import 'dart:async';

import 'package:admin_dokter_panggil/src/models/laporan_jasa_dokter_model.dart';
import 'package:admin_dokter_panggil/src/models/laporan_jasa_dokter_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/laporan_jasa_dokter_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class LaporanJasaDokterBloc {
  List<LaporanJasaDokter> data = [];
  final _repo = LaporanJasaDokterRepo();
  StreamController<ApiResponse<List<LaporanJasaDokter>>>?
      _streamLaporanJasaDokter;
  StreamController<ApiResponse<ResponseLaporanJasaDokterSaveModel>>?
      _streamLaporanJasaDokterSave;
  final BehaviorSubject<String> _from = BehaviorSubject();
  final BehaviorSubject<String> _to = BehaviorSubject();
  StreamSink<String> get fromSink => _from.sink;
  StreamSink<String> get toSink => _to.sink;
  StreamSink<ApiResponse<ResponseLaporanJasaDokterSaveModel>>
      get laporanJasaDokterSaveSink => _streamLaporanJasaDokterSave!.sink;
  StreamSink<ApiResponse<List<LaporanJasaDokter>>> get laporanJasaDokterSink =>
      _streamLaporanJasaDokter!.sink;
  Stream<ApiResponse<ResponseLaporanJasaDokterSaveModel>>
      get laporanJasaDokterSaveStream => _streamLaporanJasaDokterSave!.stream;
  Stream<ApiResponse<List<LaporanJasaDokter>>> get laporanJasaDokterStream =>
      _streamLaporanJasaDokter!.stream;

  Future<void> getLaporanJasaDokter() async {
    _streamLaporanJasaDokter = StreamController();
    laporanJasaDokterSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.createLaporanJasa();
      if (_streamLaporanJasaDokter!.isClosed) return;
      data = res.data!;
      laporanJasaDokterSink.add(ApiResponse.completed(data));
    } catch (e) {
      if (_streamLaporanJasaDokter!.isClosed) return;
      laporanJasaDokterSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> saveLaporanJasaDokter() async {
    _streamLaporanJasaDokterSave = StreamController();
    final from = _from.value;
    final to = _to.value;
    laporanJasaDokterSaveSink.add(ApiResponse.loading('Memuat...'));
    LaporanJasaDokterSaveModel laporanJasaDokterSaveModel =
        LaporanJasaDokterSaveModel(from: from, to: to);
    try {
      final res = await _repo.saveLaporanJasa(laporanJasaDokterSaveModel);
      if (_streamLaporanJasaDokterSave!.isClosed) return;
      data.insert(0, res.data!);
      laporanJasaDokterSink.add(ApiResponse.completed(data));
      laporanJasaDokterSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamLaporanJasaDokterSave!.isClosed) return;
      laporanJasaDokterSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamLaporanJasaDokter?.close();
    _streamLaporanJasaDokterSave?.close();
    _from.close();
    _to.close();
  }
}
