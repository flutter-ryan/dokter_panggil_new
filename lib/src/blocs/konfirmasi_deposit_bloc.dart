import 'dart:async';

import 'package:admin_dokter_panggil/src/models/konfirmasi_deposit_model.dart';
import 'package:admin_dokter_panggil/src/repositories/konfirmasi_deposit_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class KonfirmasiDepositBloc {
  final _repo = KonfirmasiDepositRepo();
  StreamController<ApiResponse<ResponseKonfirmasiDepositModel>>?
      _streamKonfirmasiDeposit;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  final BehaviorSubject<int> _status = BehaviorSubject();
  final BehaviorSubject<String> _nilaiPembayaran = BehaviorSubject();
  final BehaviorSubject<List<String>> _deskripsiBiayaAdmin =
      BehaviorSubject.seeded([]);
  final BehaviorSubject<List<int>> _nilaiBiayaAdmin =
      BehaviorSubject.seeded([]);
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<int> get statusSink => _status.sink;
  StreamSink<String> get nilaiPembayaranSink => _nilaiPembayaran.sink;
  StreamSink<List<String>> get deskripsiBiayaAdminSink =>
      _deskripsiBiayaAdmin.sink;
  StreamSink<List<int>> get nilaiBiayaAdminSink => _nilaiBiayaAdmin.sink;
  StreamSink<ApiResponse<ResponseKonfirmasiDepositModel>>
      get konfirmasiDepositSink => _streamKonfirmasiDeposit!.sink;
  Stream<ApiResponse<ResponseKonfirmasiDepositModel>>
      get konfirmasiDepositStream => _streamKonfirmasiDeposit!.stream;

  Future<void> konfirmasiPembayaran() async {
    _streamKonfirmasiDeposit = StreamController();
    final idKunjungan = _idKunjungan.value;
    final nilaiPembayaran = _nilaiPembayaran.value;
    final status = _status.value;
    final deskripsiBiayaAdmin = _deskripsiBiayaAdmin.value;
    final nilaiBiayaAdmin = _nilaiBiayaAdmin.value;
    konfirmasiDepositSink.add(ApiResponse.loading('Memuat...'));
    KonfirmasiDepositModel konfirmasiDepositModel = KonfirmasiDepositModel(
      status: status,
      nilaiPembayaran: nilaiPembayaran,
      deskripsiBiayaAdmin: deskripsiBiayaAdmin,
      nilaiBiayaAdmin: nilaiBiayaAdmin,
    );
    try {
      final res =
          await _repo.konfirmasiPembayaran(konfirmasiDepositModel, idKunjungan);
      await Future.delayed(const Duration(milliseconds: 300));
      if (_streamKonfirmasiDeposit!.isClosed) return;
      konfirmasiDepositSink.add(ApiResponse.completed(res));
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (_streamKonfirmasiDeposit!.isClosed) return;
      konfirmasiDepositSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamKonfirmasiDeposit?.close();
    _idKunjungan.close();
    _status.close();
    _nilaiPembayaran.close();
  }
}
