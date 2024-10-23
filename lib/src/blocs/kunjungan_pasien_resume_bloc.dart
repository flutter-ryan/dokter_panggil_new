import 'dart:async';

import 'package:dokter_panggil/src/models/kunjungan_pasien_resume_model.dart';
import 'package:dokter_panggil/src/repositories/kunjungan_pasien_resume_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class KunjunganResumePasienBloc {
  KunjunganPasienResumeModel? kunjunganResume;
  int initialPage = 1;
  int nextPage = 1;
  int totalPage = 1;
  final _repo = KunjunganPasienResumeRepo();
  StreamController<ApiResponse<KunjunganPasienResumeModel>>?
      _streamKunjunganPasienResume;
  final BehaviorSubject<String> _norm = BehaviorSubject();
  final BehaviorSubject<String> _tanggal = BehaviorSubject.seeded('');
  StreamSink<String> get normSink => _norm.sink;
  StreamSink<String> get tanggalSink => _tanggal.sink;
  StreamSink<ApiResponse<KunjunganPasienResumeModel>>
      get kunjunganPasienResumeSink => _streamKunjunganPasienResume!.sink;
  Stream<ApiResponse<KunjunganPasienResumeModel>>
      get kunjunganPasienResumeStream => _streamKunjunganPasienResume!.stream;

  Future<void> getKunjunganPasienResume() async {
    _streamKunjunganPasienResume = StreamController();
    final norm = _norm.value;
    final tanggal = _tanggal.value;
    kunjunganPasienResumeSink.add(ApiResponse.loading('Memuat...'));
    PencarianRiwayatResumeModel pencarianRiwayatResumeModel =
        PencarianRiwayatResumeModel(tanggal: tanggal);
    try {
      final res = await _repo.getKunjunganPasienResume(
          norm, initialPage, pencarianRiwayatResumeModel);
      if (_streamKunjunganPasienResume!.isClosed) return;
      kunjunganResume = res;
      totalPage = res.totalPage!;
      kunjunganPasienResumeSink.add(ApiResponse.completed(kunjunganResume));
    } catch (e) {
      if (_streamKunjunganPasienResume!.isClosed) return;
      kunjunganPasienResumeSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getNextKunjunganPasienResume() async {
    if (nextPage != totalPage) {
      nextPage = nextPage + 1;
      final norm = _norm.value;
      final tanggal = _tanggal.value;
      PencarianRiwayatResumeModel pencarianRiwayatResumeModel =
          PencarianRiwayatResumeModel(tanggal: tanggal);
      try {
        final res = await _repo.getKunjunganPasienResume(
            norm, nextPage, pencarianRiwayatResumeModel);
        if (_streamKunjunganPasienResume!.isClosed) return;
        kunjunganResume!.currentPage = nextPage;
        kunjunganResume!.data!.addAll(res.data!);
        kunjunganPasienResumeSink.add(ApiResponse.completed(kunjunganResume));
      } catch (e) {
        if (_streamKunjunganPasienResume!.isClosed) return;
        kunjunganPasienResumeSink.add(ApiResponse.completed(kunjunganResume));
      }
    }
  }

  dispose() {
    _streamKunjunganPasienResume?.close();
    _norm.close();
  }
}
