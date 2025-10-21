import 'dart:async';

import 'package:admin_dokter_panggil/src/models/ojol_tindakan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/ojol_tindakan_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class OjolTindakanBloc {
  final _repo = OjolTindakanRepo();
  StreamController<ApiResponse<ResponseOjolTindakanModel>>? _srteamOjolTindakan;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<int> _tindakanKunjungan = BehaviorSubject();
  final BehaviorSubject<int> _biaya = BehaviorSubject();
  final BehaviorSubject<int> _persen = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<int> get tindakanKunjunganSink => _tindakanKunjungan.sink;
  StreamSink<int> get biayaSink => _biaya.sink;
  StreamSink<int> get persenSink => _persen.sink;
  StreamSink<ApiResponse<ResponseOjolTindakanModel>> get ojolTindakanSink =>
      _srteamOjolTindakan!.sink;
  Stream<ApiResponse<ResponseOjolTindakanModel>> get ojolTindakanStream =>
      _srteamOjolTindakan!.stream;

  Future<void> simpanOjolTindakan() async {
    _srteamOjolTindakan = StreamController();
    final id = _id.value;
    final tindakanKunjungan = _tindakanKunjungan.value;
    final biaya = _biaya.value;
    final persen = _persen.value;
    ojolTindakanSink.add(ApiResponse.loading('Memuat...'));
    OjolTindakanModel ojolTindakanModel = OjolTindakanModel(
        tindakanKunjungan: tindakanKunjungan, biaya: biaya, persen: persen);
    try {
      final res = await _repo.saveOjolTindakan(ojolTindakanModel, id);
      if (_srteamOjolTindakan!.isClosed) return;
      ojolTindakanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_srteamOjolTindakan!.isClosed) return;
      ojolTindakanSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _srteamOjolTindakan?.close();
    _id.close();
    _tindakanKunjungan.close();
    _persen.close();
    _biaya.close();
  }
}
