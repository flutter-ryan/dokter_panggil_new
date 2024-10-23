import 'dart:async';

import 'package:dokter_panggil/src/models/barang_farmasi_model.dart';
import 'package:dokter_panggil/src/repositories/barang_farmasi_save_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class BarangFarmasiBloc {
  late BarangFarmasiSaveRepo _repo;
  StreamController<ApiResponse<ResponseBarangFarmasiModel>>?
      _streamBarangFarmasi;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<String> _barang = BehaviorSubject();
  final BehaviorSubject<String> _harga = BehaviorSubject();
  final BehaviorSubject<int> _persen = BehaviorSubject();
  final BehaviorSubject<int> _mitra = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<String> get barangSink => _barang.sink;
  StreamSink<String> get hargaSink => _harga.sink;
  StreamSink<int> get persenSink => _persen.sink;
  StreamSink<int> get mitraSink => _mitra.sink;
  StreamSink<ApiResponse<ResponseBarangFarmasiModel>> get barangFarmasiSink =>
      _streamBarangFarmasi!.sink;
  Stream<ApiResponse<ResponseBarangFarmasiModel>> get barangFarmasiStream =>
      _streamBarangFarmasi!.stream;

  Future<void> saveBarangFarmasi() async {
    _repo = BarangFarmasiSaveRepo();
    _streamBarangFarmasi = StreamController();
    final barang = _barang.value;
    final harga = _harga.value;
    final persen = _persen.value;
    final mitra = _mitra.value;
    barangFarmasiSink.add(ApiResponse.loading('Memuat...'));
    BarangFarmasiModel barangFarmasiModel = BarangFarmasiModel(
      barang: barang,
      harga: int.parse(harga),
      persen: persen,
      mitra: mitra,
    );
    try {
      final res = await _repo.saveBarangFarmasi(barangFarmasiModel);
      if (_streamBarangFarmasi!.isClosed) return;
      barangFarmasiSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBarangFarmasi!.isClosed) return;
      barangFarmasiSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamBarangFarmasi?.close();
    _id.close();
    _barang.close();
    _harga.close();
    _persen.close();
    _mitra.close();
  }
}
