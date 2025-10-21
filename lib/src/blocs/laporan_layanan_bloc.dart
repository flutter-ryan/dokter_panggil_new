import 'dart:async';

import 'package:admin_dokter_panggil/src/models/laporan_layanan_model.dart';
import 'package:admin_dokter_panggil/src/models/laporan_layanan_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/laporan_layanan_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class LaporanLayananBloc {
  List<LaporanLayanan> data = [];
  final _repo = LaporanLayananRepo();
  StreamController<ApiResponse<List<LaporanLayanan>>>? _streamLaporanLayanan;
  StreamController<ApiResponse<ResponseLaporanLayananSaveModel>>?
      _streamLaporanLayananSave;
  final BehaviorSubject<String> _from = BehaviorSubject();
  final BehaviorSubject<String> _to = BehaviorSubject();
  StreamSink<String> get fromSink => _from.sink;
  StreamSink<String> get toSink => _to.sink;
  StreamSink<ApiResponse<ResponseLaporanLayananSaveModel>>
      get laporanLayananSaveSink => _streamLaporanLayananSave!.sink;
  StreamSink<ApiResponse<List<LaporanLayanan>>> get laporanLayananSink =>
      _streamLaporanLayanan!.sink;
  Stream<ApiResponse<ResponseLaporanLayananSaveModel>>
      get laporanLayananSaveStream => _streamLaporanLayananSave!.stream;
  Stream<ApiResponse<List<LaporanLayanan>>> get laporanLayananStream =>
      _streamLaporanLayanan!.stream;

  Future<void> getLaporanLayanan() async {
    _streamLaporanLayanan = StreamController();
    laporanLayananSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getLaporanLayanan();
      if (_streamLaporanLayanan!.isClosed) return;
      data = res.data!;
      laporanLayananSink.add(ApiResponse.completed(data));
    } catch (e) {
      if (_streamLaporanLayanan!.isClosed) return;
      laporanLayananSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> saveLaporanLayanan() async {
    _streamLaporanLayananSave = StreamController();
    final from = _from.value;
    final to = _to.value;
    laporanLayananSaveSink.add(ApiResponse.loading('Memuat...'));
    LaporanLayananSaveModel laporanLayananSaveModel =
        LaporanLayananSaveModel(from: from, to: to);
    try {
      final res = await _repo.saveLaporanLayanan(laporanLayananSaveModel);
      if (_streamLaporanLayananSave!.isClosed) return;
      data.insert(0, res.data!);
      laporanLayananSaveSink.add(ApiResponse.completed(res));
      laporanLayananSink.add(ApiResponse.completed(data));
    } catch (e) {
      if (_streamLaporanLayananSave!.isClosed) return;
      laporanLayananSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamLaporanLayanan?.close();
    _streamLaporanLayananSave?.close();
    _from.close();
    _to.close();
  }
}
