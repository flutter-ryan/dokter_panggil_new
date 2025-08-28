import 'dart:async';

import 'package:dokter_panggil/src/models/master_village_model.dart';
import 'package:dokter_panggil/src/models/mr_pasien_save_model.dart';
import 'package:dokter_panggil/src/repositories/mr_pasien_save_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrPasienSaveBloc {
  final _repo = MrPasienSaveRepo();
  StreamController<ApiResponse<MrPasienSaveModel>>? _streamPasienSave;
  final BehaviorSubject<int> _idPasien = BehaviorSubject();
  final BehaviorSubject<String> _nik = BehaviorSubject.seeded('');
  final BehaviorSubject<int> _jenis = BehaviorSubject();
  final BehaviorSubject<String> _namaPasien = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _tempatLahir = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _tanggalLahir = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _jenisKelamin = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _alamat = BehaviorSubject.seeded('');
  final BehaviorSubject<Village> _village = BehaviorSubject();
  final BehaviorSubject<String> _kodePos = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _rt = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _rw = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _nomorHp = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _namaDarurat = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _nomorHpDarurat = BehaviorSubject.seeded('');
  final BehaviorSubject<int> _statusNikah = BehaviorSubject();
  StreamSink<int> get idPasienSink => _idPasien.sink;
  StreamSink<String> get nikSink => _nik.sink;
  StreamSink<int> get jenisSink => _jenis.sink;
  StreamSink<String> get namaPasienSink => _namaPasien.sink;
  StreamSink<String> get tempatLahirSink => _tempatLahir.sink;
  StreamSink<String> get tanggalLahirSink => _tanggalLahir.sink;
  StreamSink<String> get jenisKelaminSink => _jenisKelamin.sink;
  StreamSink<String> get alamatSink => _alamat.sink;
  StreamSink<Village> get villageSink => _village.sink;
  StreamSink<String> get kodePosSink => _kodePos.sink;
  StreamSink<String> get rtSink => _rt.sink;
  StreamSink<String> get rwSink => _rw.sink;
  StreamSink<String> get nomorHpSink => _nomorHp.sink;
  StreamSink<String> get namaDaruratSink => _namaDarurat.sink;
  StreamSink<String> get nomorHpDaruratSink => _nomorHpDarurat.sink;
  StreamSink<int> get statusNikahSink => _statusNikah.sink;
  StreamSink<ApiResponse<MrPasienSaveModel>> get pasienSaveSink =>
      _streamPasienSave!.sink;
  Stream<ApiResponse<MrPasienSaveModel>> get pasienSaveStream =>
      _streamPasienSave!.stream;

  Future<void> simpanPasien() async {
    _streamPasienSave = StreamController();
    final nik = _nik.value;
    final jenis = _jenis.value;
    final namaPasien = _namaPasien.value;
    final tempatLahir = _tempatLahir.value;
    final tanggalLahir = _tanggalLahir.value;
    final jenisKelamin = _jenisKelamin.value;
    final alamat = _alamat.value;
    final village = _village.value;
    final kodePos = _kodePos.value;
    final rt = _rt.value;
    final rw = _rw.value;
    final nomorHp = _nomorHp.value;
    final namaDarurat = _namaDarurat.value;
    final nomorHpDarurat = _nomorHpDarurat.value;
    final statusNikah = _statusNikah.value;

    pasienSaveSink.add(ApiResponse.loading('Memuat...'));
    MrPasienSaveRequestModel mrPasienSaveRequestModel =
        MrPasienSaveRequestModel(
      nik: nik,
      jenis: jenis,
      namaPasien: namaPasien,
      tempatLahir: tempatLahir,
      tanggalLahir: tanggalLahir,
      jenisKelamin: jenisKelamin,
      alamat: alamat,
      village: village,
      kodePos: kodePos,
      rt: rt,
      rw: rw,
      nomorHp: nomorHp,
      namaDarurat: namaDarurat,
      nomorHpDarurat: nomorHpDarurat,
      statusNikah: statusNikah,
    );
    try {
      final res = await _repo.simpanPasienBaru(mrPasienSaveRequestModel);
      if (_streamPasienSave!.isClosed) return;
      pasienSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPasienSave!.isClosed) return;
      pasienSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> deletePasien() async {
    //
  }

  dispose() {
    _streamPasienSave?.close();
    _idPasien.close();
    _nik.close();
    _jenis.close();
    _namaPasien.close();
    _tempatLahir.close();
    _tanggalLahir.close();
    _jenisKelamin.close();
    _alamat.close();
    _village.close();
    _kodePos.close();
    _rt.close();
    _rw.close();
    _nomorHp.close();
    _namaDarurat.close();
    _nomorHpDarurat.close();
    _statusNikah.close();
  }
}
