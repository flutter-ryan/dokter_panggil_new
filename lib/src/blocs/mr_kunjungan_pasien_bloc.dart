import 'dart:async';

import 'package:dokter_panggil/src/models/mr_kunjungan_pasien_model.dart';
import 'package:dokter_panggil/src/repositories/mr_kunjungan_pasien_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrKunjunganPasienBloc {
  final _repo = MrKunjunganPasienRepo();
  StreamController<ApiResponse<MrKunjunganPasienModel>>? _streamKunjunganPasien;
  final BehaviorSubject<String> _norm = BehaviorSubject();
  final BehaviorSubject<String> _tanggal = BehaviorSubject();
  final BehaviorSubject<String> _jam = BehaviorSubject();
  final BehaviorSubject<String> _keluhan = BehaviorSubject();
  final BehaviorSubject<int> _status = BehaviorSubject.seeded(1);
  final BehaviorSubject<String> _dokter = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _perawat = BehaviorSubject.seeded('');
  final BehaviorSubject<int> _layanan = BehaviorSubject();
  final BehaviorSubject<List<TindakanRequest>> _tindakan = BehaviorSubject();
  final BehaviorSubject<int> _skrining = BehaviorSubject();
  final BehaviorSubject<String> _resikoJatuh = BehaviorSubject();
  final BehaviorSubject<String> _keputusanResikoJatuh = BehaviorSubject();
  final BehaviorSubject<List<String>> _tokens = BehaviorSubject();
  final BehaviorSubject<String> _namaWali = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _hubungan = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _nomorWali = BehaviorSubject.seeded('');
  final BehaviorSubject<int> _idPaket = BehaviorSubject();
  StreamSink<String> get normSink => _norm.sink;
  StreamSink<String> get tanggalSink => _tanggal.sink;
  StreamSink<String> get jamSink => _jam.sink;
  StreamSink<int> get statusSink => _status.sink;
  StreamSink<String> get keluhanSink => _keluhan.sink;
  StreamSink<int> get layananSink => _layanan.sink;
  StreamSink<String> get dokterSink => _dokter.sink;
  StreamSink<String> get perawatSink => _perawat.sink;
  StreamSink<List<TindakanRequest>> get tindakanSink => _tindakan.sink;
  StreamSink<int> get skriningSink => _skrining.sink;
  StreamSink<String> get resikoJatuh => _resikoJatuh.sink;
  StreamSink<String> get keputusanResikoJatuhSink => _keputusanResikoJatuh.sink;
  StreamSink<List<String>> get tokensSink => _tokens.sink;
  StreamSink<String> get namaWaliSink => _namaWali.sink;
  StreamSink<String> get hubunganSink => _hubungan.sink;
  StreamSink<String> get nomorWaliSink => _nomorWali.sink;
  StreamSink<int> get idPaketSink => _idPaket.sink;
  StreamSink<ApiResponse<MrKunjunganPasienModel>> get kunjunganPasienSink =>
      _streamKunjunganPasien!.sink;
  Stream<ApiResponse<MrKunjunganPasienModel>> get kunjunganPasienStream =>
      _streamKunjunganPasien!.stream;

  Future<void> simpanKunjungan() async {
    _streamKunjunganPasien = StreamController();
    final norm = _norm.value;
    final tanggal = _tanggal.value;
    final jam = _jam.value;
    final status = _status.value;
    final keluhan = _keluhan.value;
    final layanan = _layanan.value;
    final dokter = _dokter.value;
    final perawat = _perawat.value;
    final tindakan = _tindakan.value;
    final skrining = _skrining.value;
    final resikoJatuh = _resikoJatuh.value;
    final keputusanResikoJatuh = _keputusanResikoJatuh.value;
    final tokens = _tokens.value;
    final namaWali = _namaWali.value;
    final hubungan = _hubungan.value;
    final nomorWali = _nomorWali.value;
    kunjunganPasienSink.add(ApiResponse.loading('Memuat...'));
    MrKunjunganPasienRequestModel mrKunjunganPasienRequestModel =
        MrKunjunganPasienRequestModel(
      norm: norm,
      tanggal: tanggal,
      jam: jam,
      keluhan: keluhan,
      status: status,
      dokter: dokter,
      perawat: perawat,
      layanan: layanan,
      tindakan: tindakan,
      skrining: skrining,
      resikoJatuh: resikoJatuh,
      keputusanResikoJatuh: keputusanResikoJatuh,
      tokens: tokens,
      namaWali: namaWali,
      nomorWali: nomorWali,
      hubungan: hubungan,
    );
    try {
      final res = await _repo.simpanKunjungan(mrKunjunganPasienRequestModel);
      if (_streamKunjunganPasien!.isClosed) return;
      kunjunganPasienSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKunjunganPasien!.isClosed) return;
      kunjunganPasienSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> simpanKunjunganPaket() async {
    _streamKunjunganPasien = StreamController();
    final norm = _norm.value;
    final tanggal = _tanggal.value;
    final jam = _jam.value;
    final status = _status.value;
    final keluhan = _keluhan.value;
    final layanan = _layanan.value;
    final dokter = _dokter.value;
    final perawat = _perawat.value;
    final skrining = _skrining.value;
    final resikoJatuh = _resikoJatuh.value;
    final keputusanResikoJatuh = _keputusanResikoJatuh.value;
    final idPaket = _idPaket.value;
    final tokens = _tokens.value;
    final namaWali = _namaWali.value;
    final hubungan = _hubungan.value;
    final nomorWali = _nomorWali.value;
    kunjunganPasienSink.add(ApiResponse.loading('Memuat...'));
    MrKunjunganPasienPaketRequestModel mrKunjunganPasienPaketRequestModel =
        MrKunjunganPasienPaketRequestModel(
            norm: norm,
            tanggal: tanggal,
            jam: jam,
            keluhan: keluhan,
            status: status,
            dokter: dokter,
            perawat: perawat,
            layanan: layanan,
            idPaket: idPaket,
            namaWali: namaWali,
            hubungan: hubungan,
            nomorWali: nomorWali,
            skrining: skrining,
            resikoJatuh: resikoJatuh,
            keputusanResikoJatuh: keputusanResikoJatuh,
            tokens: tokens);
    try {
      final res =
          await _repo.simpanKunjunganPaket(mrKunjunganPasienPaketRequestModel);
      if (_streamKunjunganPasien!.isClosed) return;
      kunjunganPasienSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKunjunganPasien!.isClosed) return;
      kunjunganPasienSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamKunjunganPasien?.close();
    _norm.close();
    _tanggal.close();
    _jam.close();
    _keluhan.close();
    _status.close();
    _dokter.close();
    _perawat.close();
    _layanan.close();
    _tindakan.close();
    _skrining.close();
    _resikoJatuh.close();
    _keputusanResikoJatuh.close();
    _tokens.close();
  }
}
