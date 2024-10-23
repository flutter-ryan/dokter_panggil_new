import 'dart:async';

import 'package:dokter_panggil/src/models/transaksi_resep_model.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/repositories/transaksi_resep_racikan_repo.dart';
import 'package:rxdart/rxdart.dart';

class TransaksiResepRacikanBloc {
  final _repo = TransaksiResepRacikanRepo();
  StreamController<ApiResponse<ResponseTransaksiResepModel>>?
      _streamTransaksiResepRacikan;
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
  StreamSink<ApiResponse<ResponseTransaksiResepModel>>
      get transaksiResepRacikanSink => _streamTransaksiResepRacikan!.sink;
  Stream<ApiResponse<ResponseTransaksiResepModel>>
      get transaksiResepRacikanStream => _streamTransaksiResepRacikan!.stream;

  Future<void> saveTransaksiResepRacikan() async {
    _streamTransaksiResepRacikan = StreamController();
    final idKunjungan = _idKunjungan.value;
    final barangMitra = _barangMitra.value;
    final barangMentari = _barangMentari.value;
    final jumlahMitra = _jumlahMitra.value;
    final jumlahMentari = _jumlahMentari.value;
    transaksiResepRacikanSink.add(ApiResponse.loading('Memuat...'));
    TransaksiResepModel transaksiResepModel = TransaksiResepModel(
      barangMitra: barangMitra,
      barangMentari: barangMentari,
      jumlahMitra: jumlahMitra,
      jumlahMentari: jumlahMentari,
    );
    try {
      final res = await _repo.saveTransaksiResepRacikan(
          idKunjungan, transaksiResepModel);
      if (_streamTransaksiResepRacikan!.isClosed) return;
      transaksiResepRacikanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTransaksiResepRacikan!.isClosed) return;
      transaksiResepRacikanSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamTransaksiResepRacikan?.close();
    _idKunjungan.close();
    _barangMitra.close();
    _barangMentari.close();
    _jumlahMitra.close();
    _jumlahMentari.close();
  }
}
