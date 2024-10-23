import 'dart:async';

import 'package:dokter_panggil/src/models/pasien_model.dart';
import 'package:dokter_panggil/src/repositories/pasien_delete_repo.dart';
import 'package:dokter_panggil/src/repositories/pasien_save_repo.dart';
import 'package:dokter_panggil/src/repositories/pasien_update_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class PasienBloc {
  final _repo = PasienSaveRepo();
  late PasienUpdateRepo _repoUpdate;
  late PasienDeleteRepo _repoDelete;
  StreamController<ApiResponse<ResponsePasienModel>>? _streamPasien;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<String> _nik = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _jenis = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _nama = BehaviorSubject();
  final BehaviorSubject<String> _tempatLahir = BehaviorSubject();
  final BehaviorSubject<String> _tanggalLahir = BehaviorSubject();
  final BehaviorSubject<String> _alamat = BehaviorSubject();
  final BehaviorSubject<String> _jenisKelamin = BehaviorSubject();
  final BehaviorSubject<String> _nomorHp = BehaviorSubject();

  StreamSink<int> get idSink => _id.sink;
  StreamSink<String> get jenisSink => _jenis.sink;
  StreamSink<String> get nikSink => _nik.sink;
  StreamSink<String> get namaSink => _nama.sink;
  StreamSink<String> get tempatLahirSink => _tempatLahir.sink;
  StreamSink<String> get tanggalLahirSink => _tanggalLahir.sink;
  StreamSink<String> get alamatSink => _alamat.sink;
  StreamSink<String> get jenisKelaminSink => _jenisKelamin.sink;
  StreamSink<String> get nomorHpSink => _nomorHp.sink;
  StreamSink<ApiResponse<ResponsePasienModel>> get pasienSink =>
      _streamPasien!.sink;
  Stream<ApiResponse<ResponsePasienModel>> get pasienStream =>
      _streamPasien!.stream;

  Future<void> savePasien() async {
    _streamPasien = StreamController();
    final nik = _nik.value;
    final jenis = _jenis.value;
    final nama = _nama.value;
    final tempatLahir = _tempatLahir.value;
    final tanggalLahir = _tanggalLahir.value;
    final alamat = _alamat.value;
    final jenisKelamin = _jenisKelamin.value;
    final nomorHp = _nomorHp.value;
    pasienSink.add(ApiResponse.loading('Memuat...'));
    PasienModel pasienModel = PasienModel(
      nik: nik,
      jenis: jenis,
      namaPasien: nama,
      tempatLahir: tempatLahir,
      tanggalLahir: tanggalLahir,
      alamat: alamat,
      jenisKelamin: jenisKelamin,
      nomorHp: nomorHp,
    );
    try {
      final res = await _repo.savePasien(pasienModel);
      if (_streamPasien!.isClosed) return;
      pasienSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPasien!.isClosed) return;
      pasienSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> updatePasien() async {
    _repoUpdate = PasienUpdateRepo();
    _streamPasien = StreamController();
    final id = _id.value;
    final nik = _nik.value;
    final jenis = _jenis.value;
    final nama = _nama.value;
    final tempatLahir = _tempatLahir.value;
    final tanggalLahir = _tanggalLahir.value;
    final alamat = _alamat.value;
    final jenisKelamin = _jenisKelamin.value;
    final nomorHp = _nomorHp.value;
    pasienSink.add(ApiResponse.loading('Memuat...'));
    PasienModel pasienModel = PasienModel(
      nik: nik,
      jenis: jenis,
      namaPasien: nama,
      tempatLahir: tempatLahir,
      tanggalLahir: tanggalLahir,
      alamat: alamat,
      jenisKelamin: jenisKelamin,
      nomorHp: nomorHp,
    );

    try {
      final res = await _repoUpdate.updatePasien(id, pasienModel);
      if (_streamPasien!.isClosed) return;
      pasienSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPasien!.isClosed) return;
      pasienSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> deletePasien() async {
    _repoDelete = PasienDeleteRepo();
    _streamPasien = StreamController();
    final id = _id.value;
    pasienSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repoDelete.deletePasien(id);
      if (_streamPasien!.isClosed) return;
      pasienSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPasien!.isClosed) return;
      pasienSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamPasien?.close();
    _id.close();
    _nik.close();
    _nama.close();
    _tempatLahir.close();
    _tanggalLahir.close();
    _alamat.close();
    _jenisKelamin.close();
    _nomorHp.close();
  }
}
