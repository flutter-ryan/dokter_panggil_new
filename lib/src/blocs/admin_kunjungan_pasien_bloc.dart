import 'dart:async';

import 'package:admin_dokter_panggil/src/models/admin_kunjungan_pasien_delete_model.dart';
import 'package:admin_dokter_panggil/src/models/admin_kunjungan_pasien_model.dart';
import 'package:admin_dokter_panggil/src/repositories/admin_kunjungan_pasien_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class AdminKunjunganPasienBloc {
  AdminKunjunganPasienModel? data;
  int initialPage = 1;
  int totalPage = 0;
  int nextPage = 0;
  final _repo = AdminKunjunganPasienRepo();
  StreamController<ApiResponse<AdminKunjunganPasienModel>>?
      _streamAdminKunjunganPasien;
  StreamController<ApiResponse<AdminKunjunganPasienDeleteModel>>?
      _streamAdminKunjungan;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  final BehaviorSubject<String> _filter = BehaviorSubject.seeded('');
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<String> get filterSink => _filter.sink;
  StreamSink<ApiResponse<AdminKunjunganPasienDeleteModel>>
      get adminKunjunganSink => _streamAdminKunjungan!.sink;
  StreamSink<ApiResponse<AdminKunjunganPasienModel>>
      get adminKunjunganPasienSink => _streamAdminKunjunganPasien!.sink;
  Stream<ApiResponse<AdminKunjunganPasienDeleteModel>>
      get adminKunjunganStream => _streamAdminKunjungan!.stream;
  Stream<ApiResponse<AdminKunjunganPasienModel>>
      get adminKunjunganPasienStream => _streamAdminKunjunganPasien!.stream;

  Future<void> getAdminKunjunganPasien() async {
    _streamAdminKunjunganPasien = StreamController();
    final filter = _filter.value;
    nextPage = initialPage + 1;
    adminKunjunganPasienSink.add(ApiResponse.loading('Memuat...'));
    KirimAdminKunjunganPasienModel kirimAdminKunjunganPasienModel =
        KirimAdminKunjunganPasienModel(filter: filter);
    try {
      final res = await _repo.getAdminKunjungan(
          kirimAdminKunjunganPasienModel, initialPage);
      if (_streamAdminKunjunganPasien!.isClosed) return;
      data = res;
      adminKunjunganPasienSink.add(ApiResponse.completed(data));
    } catch (e) {
      if (_streamAdminKunjunganPasien!.isClosed) return;
      adminKunjunganPasienSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getNextAdminKunjunganPasien() async {
    if (nextPage == totalPage) return;
    final filter = _filter.value;
    KirimAdminKunjunganPasienModel kirimAdminKunjunganPasienModel =
        KirimAdminKunjunganPasienModel(filter: filter);
    try {
      final res = await _repo.getAdminKunjungan(
          kirimAdminKunjunganPasienModel, nextPage);
      if (_streamAdminKunjunganPasien!.isClosed) return;
      data!.data!.addAll(res.data!);
      data!.currentPage = res.currentPage;
      data!.totalPage = res.totalPage;
      adminKunjunganPasienSink.add(ApiResponse.completed(data));
      nextPage = nextPage + 1;
    } catch (e) {
      if (_streamAdminKunjunganPasien!.isClosed) return;
      adminKunjunganPasienSink.add(ApiResponse.completed(data));
    }
  }

  Future<void> deleteAdminKunjungan() async {
    _streamAdminKunjungan = StreamController();
    final idKunjungan = _idKunjungan.value;
    adminKunjunganSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deleteAdminKunjungan(idKunjungan);
      if (_streamAdminKunjungan!.isClosed) return;
      data!.data!.removeWhere((kunjungan) => kunjungan.id == res.data!.id);
      adminKunjunganSink.add(ApiResponse.completed(res));
      adminKunjunganPasienSink.add(ApiResponse.completed(data));
    } catch (e) {
      if (_streamAdminKunjungan!.isClosed) return;
      adminKunjunganSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamAdminKunjungan?.close();
    _streamAdminKunjunganPasien?.close();
    _filter.close();
  }
}
