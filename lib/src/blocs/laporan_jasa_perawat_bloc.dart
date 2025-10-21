import 'dart:async';

import 'package:admin_dokter_panggil/src/models/laporan_jasa_perawat_model.dart';
import 'package:admin_dokter_panggil/src/models/laporan_jasa_perawat_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/laporan_jasa_perawat_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class LaporanJasaPerawatBloc {
  List<LaporanJasaPerawat> data = [];
  final _repo = LaporanJasaPerawatRepo();
  StreamController<ApiResponse<List<LaporanJasaPerawat>>>?
      _streamLaporanJasaPerawat;
  StreamController<ApiResponse<ResponseLaporanJasaPerawatSaveModel>>?
      _streamLaporanJasaPerawatSave;
  final BehaviorSubject<String> _from = BehaviorSubject();
  final BehaviorSubject<String> _to = BehaviorSubject();
  StreamSink<String> get fromSink => _from.sink;
  StreamSink<String> get toSink => _to.sink;
  StreamSink<ApiResponse<ResponseLaporanJasaPerawatSaveModel>>
      get laporanJasaPerawatSaveSink => _streamLaporanJasaPerawatSave!.sink;
  StreamSink<ApiResponse<List<LaporanJasaPerawat>>>
      get laporanJasaPerawatSink => _streamLaporanJasaPerawat!.sink;
  Stream<ApiResponse<ResponseLaporanJasaPerawatSaveModel>>
      get laporanJasaPerawatSaveStream => _streamLaporanJasaPerawatSave!.stream;
  Stream<ApiResponse<List<LaporanJasaPerawat>>> get laporanJasaPerawatStream =>
      _streamLaporanJasaPerawat!.stream;

  Future<void> getLaporanJasa() async {
    _streamLaporanJasaPerawat = StreamController();
    laporanJasaPerawatSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getLaporanJasaPerawat();
      if (_streamLaporanJasaPerawat!.isClosed) return;
      data = res.data!;
      laporanJasaPerawatSink.add(ApiResponse.completed(data));
    } catch (e) {
      if (_streamLaporanJasaPerawat!.isClosed) return;
      laporanJasaPerawatSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> saveLaporanJasa() async {
    _streamLaporanJasaPerawatSave = StreamController();
    final from = _from.value;
    final to = _to.value;
    laporanJasaPerawatSaveSink.add(ApiResponse.loading('Memuat...'));
    LaporanJasaPerawatSaveModel laporanJasaPerawatSaveModel =
        LaporanJasaPerawatSaveModel(from: from, to: to);
    try {
      final res =
          await _repo.saveLaporanJasaPerawat(laporanJasaPerawatSaveModel);
      if (_streamLaporanJasaPerawatSave!.isClosed) return;
      data.insert(0, res.data!);
      laporanJasaPerawatSaveSink.add(ApiResponse.completed(res));
      laporanJasaPerawatSink.add(ApiResponse.completed(data));
    } catch (e) {
      if (_streamLaporanJasaPerawatSave!.isClosed) return;
      laporanJasaPerawatSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamLaporanJasaPerawat?.close();
    _streamLaporanJasaPerawatSave?.close();
    _from.close();
    _to.close();
  }
}
