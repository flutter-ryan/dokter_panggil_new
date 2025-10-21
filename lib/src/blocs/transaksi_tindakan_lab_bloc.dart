import 'dart:async';

import 'package:admin_dokter_panggil/src/models/transaksi_tindakan_lab_model.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/repositories/transaksi_tindakan_lab_repo.dart';
import 'package:rxdart/subjects.dart';

class TransaksiTindakanLabBloc {
  final _repo = TransaksiTindakanLabRepo();
  StreamController<ApiResponse<ResponseTransaksiTindakanLabModel>>?
      _streamTransaksiTindakanLab;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  final BehaviorSubject<List<int>> _idTindakanLab = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<List<int>> get idTindakanSink => _idTindakanLab.sink;
  StreamSink<ApiResponse<ResponseTransaksiTindakanLabModel>>
      get transaksiTindakanLabSink => _streamTransaksiTindakanLab!.sink;
  Stream<ApiResponse<ResponseTransaksiTindakanLabModel>>
      get transaksiTindakanLabStream => _streamTransaksiTindakanLab!.stream;
  Future<void> saveTransaksiTindakanLab() async {
    _streamTransaksiTindakanLab = StreamController();
    final idKunjungan = _idKunjungan.value;
    final idTindakanLab = _idTindakanLab.value;
    transaksiTindakanLabSink.add(ApiResponse.loading('Memuat...'));
    TransaksiTindakanLabModel transaksiTindakanLabModel =
        TransaksiTindakanLabModel(tindakanLab: idTindakanLab);
    try {
      final res = await _repo.saveTransaksiTindakanLab(
          idKunjungan, transaksiTindakanLabModel);
      if (_streamTransaksiTindakanLab!.isClosed) return;
      transaksiTindakanLabSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTransaksiTindakanLab!.isClosed) return;
      transaksiTindakanLabSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamTransaksiTindakanLab?.close();
    _idKunjungan.close();
    _idTindakanLab.close();
  }
}
