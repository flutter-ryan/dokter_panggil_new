import 'dart:async';

import 'package:dokter_panggil/src/models/kunjungan_biaya_lain_model.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/repositories/kunjungan_biaya_lain_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class KunjunganBiayaLainBloc {
  final _repo = KunjunganBiayaLainRepo();
  StreamController<ApiResponse<PasienKunjunganDetailModel>>? _streamBiayaLain;
  final BehaviorSubject<int> _idBiaya = BehaviorSubject();
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  final BehaviorSubject<String> _deskripsi = BehaviorSubject();
  final BehaviorSubject<int> _nilai = BehaviorSubject();
  StreamSink<int> get idBiayaSink => _idBiaya.sink;
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<String> get deskripsiSink => _deskripsi.sink;
  StreamSink<int> get nilaiSink => _nilai.sink;
  StreamSink<ApiResponse<PasienKunjunganDetailModel>> get biayaLainSink =>
      _streamBiayaLain!.sink;
  Stream<ApiResponse<PasienKunjunganDetailModel>> get biayaLainStream =>
      _streamBiayaLain!.stream;

  Future<void> saveBiayaLain() async {
    _streamBiayaLain = StreamController();
    final idKunjungan = _idKunjungan.value;
    final deskripsi = _deskripsi.value;
    final nilai = _nilai.value;

    KunjunganBiayaLainModel kunjunganBiayaLainModel = KunjunganBiayaLainModel(
        kunjungan: idKunjungan, deskripsi: deskripsi, nilai: nilai);
    biayaLainSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.saveBiayaLain(kunjunganBiayaLainModel);
      if (_streamBiayaLain!.isClosed) return;
      biayaLainSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBiayaLain!.isClosed) return;
      biayaLainSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> deleteBiayaLain() async {
    _streamBiayaLain = StreamController();
    final idBiaya = _idBiaya.value;
    biayaLainSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deleteBiayaLain(idBiaya);
      if (_streamBiayaLain!.isClosed) return;
      biayaLainSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBiayaLain!.isClosed) return;
      biayaLainSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamBiayaLain?.close();
    _idKunjungan.close();
    _nilai.close();
    _deskripsi.close();
    _idBiaya.close();
  }
}
