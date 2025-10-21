import 'dart:async';

import 'package:admin_dokter_panggil/src/models/transaksi_resep_model.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/repositories/transaksi_resep_repo.dart';
import 'package:rxdart/subjects.dart';

class TransaksiResepBloc {
  final _repo = TransaksiResepRepo();
  StreamController<ApiResponse<ResponseTransaksiResepModel>>?
      _streamTransaksiResep;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  final BehaviorSubject<List<int>> _barangMitra = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<int>> _barangMentari = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<int>> _jumlahMitra = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<int>> _jumlahMentari = BehaviorSubject.seeded([]);
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<List<int>> get barangMitraSink => _barangMitra.sink;
  StreamSink<List<int>> get barangMentariSink => _barangMentari.sink;
  StreamSink<List<int>> get jumlahMitraSink => _jumlahMitra.sink;
  StreamSink<List<int>> get jumlahMentariSink => _jumlahMentari.sink;
  StreamSink<ApiResponse<ResponseTransaksiResepModel>> get transaksiResepSink =>
      _streamTransaksiResep!.sink;
  Stream<ApiResponse<ResponseTransaksiResepModel>> get transaksiResepStream =>
      _streamTransaksiResep!.stream;

  Future<void> saveTransaksiResep() async {
    _streamTransaksiResep = StreamController();
    final idKunjungan = _idKunjungan.value;
    final barangMitra = _barangMitra.value;
    final barangMentari = _barangMentari.value;
    final jumlahMitra = _jumlahMitra.value;
    final jumlahMentari = _jumlahMentari.value;
    transaksiResepSink.add(ApiResponse.loading('Memuat...'));
    TransaksiResepModel transaksiResepModel = TransaksiResepModel(
      barangMitra: barangMitra,
      barangMentari: barangMentari,
      jumlahMitra: jumlahMitra,
      jumlahMentari: jumlahMentari,
    );
    try {
      final res =
          await _repo.saveTransaksiResep(idKunjungan, transaksiResepModel);
      if (_streamTransaksiResep!.isClosed) return;
      transaksiResepSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTransaksiResep!.isClosed) return;
      transaksiResepSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamTransaksiResep?.close();
    _idKunjungan.close();
    _barangMitra.close();
    _barangMentari.close();
    _jumlahMitra.close();
    _jumlahMentari.close();
  }
}
