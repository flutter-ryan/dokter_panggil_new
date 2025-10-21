import 'dart:async';

import 'package:admin_dokter_panggil/src/models/transaksi_bhp_model.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/repositories/transaksi_bhp_repo.dart';
import 'package:rxdart/subjects.dart';

class TransaksiBhpBloc {
  final _repo = TransaksiBhpRepo();
  StreamController<ApiResponse<ResponseTransaksiBhpModel>>? _streamTransaksiBhp;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  final BehaviorSubject<List<int>> _barang = BehaviorSubject();
  final BehaviorSubject<List<int>> _jumlah = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<List<int>> get barangSink => _barang.sink;
  StreamSink<List<int>> get jumlahSink => _jumlah.sink;
  StreamSink<ApiResponse<ResponseTransaksiBhpModel>> get transaksiBhpSink =>
      _streamTransaksiBhp!.sink;
  Stream<ApiResponse<ResponseTransaksiBhpModel>> get transaksiBhpStream =>
      _streamTransaksiBhp!.stream;

  Future<void> saveTransaksiBhp() async {
    _streamTransaksiBhp = StreamController();
    final id = _idKunjungan.value;
    final barang = _barang.value;
    final jumlah = _jumlah.value;
    transaksiBhpSink.add(ApiResponse.loading('Memuat...'));
    TransaksiBhpModel transaksiBhpModel =
        TransaksiBhpModel(barang: barang, jumlah: jumlah);
    try {
      final res = await _repo.saveTransaksiBhp(id, transaksiBhpModel);
      if (_streamTransaksiBhp!.isClosed) return;
      transaksiBhpSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTransaksiBhp!.isClosed) return;
      transaksiBhpSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamTransaksiBhp?.close();
    _idKunjungan.close();
    _barang.close();
    _jumlah.close();
  }
}
