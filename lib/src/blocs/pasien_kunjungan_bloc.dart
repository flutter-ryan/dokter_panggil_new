import 'dart:async';

import 'package:dokter_panggil/src/models/pasien_kunjungan_model.dart';
import 'package:dokter_panggil/src/repositories/pasien_kunjungan_aktif_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class PasienKunjunganBloc {
  late PasienKunjunganAktifRepo _repoAktif;
  StreamController<ApiResponse<PasienKunjunganModel>>? _streamPasienKunjungan;
  final BehaviorSubject<String> _norm = BehaviorSubject();
  StreamSink<String> get normSink => _norm.sink;
  StreamSink<ApiResponse<PasienKunjunganModel>> get pasienKunjunganSink =>
      _streamPasienKunjungan!.sink;
  Stream<ApiResponse<PasienKunjunganModel>> get pasienKunjunganStream =>
      _streamPasienKunjungan!.stream;

  Future<void> kunjunganAktif() async {
    _repoAktif = PasienKunjunganAktifRepo();
    _streamPasienKunjungan = StreamController();
    final norm = _norm.value;
    pasienKunjunganSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repoAktif.kunjunganAktif(norm);
      if (_streamPasienKunjungan!.isClosed) return;
      pasienKunjunganSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPasienKunjungan!.isClosed) return;
      pasienKunjunganSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamPasienKunjungan?.close();
    _norm.close();
  }
}
