import 'dart:async';

import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/pasien_kunjungan_final_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class PasienKunjunganFinalBloc {
  late PasienKunjunganFinalRepo _repo;
  StreamController<ApiResponse<PasienKunjunganModel>>? _streamPasienKunjungan;
  final BehaviorSubject<String> _norm = BehaviorSubject();
  StreamSink<String> get normSink => _norm.sink;
  StreamSink<ApiResponse<PasienKunjunganModel>> get pasienKunjunganSink =>
      _streamPasienKunjungan!.sink;
  Stream<ApiResponse<PasienKunjunganModel>> get pasienKunjunganStream =>
      _streamPasienKunjungan!.stream;

  Future<void> kunjunganFinal() async {
    _repo = PasienKunjunganFinalRepo();
    _streamPasienKunjungan = StreamController();
    final norm = _norm.value;
    pasienKunjunganSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.kunjunganFinal(norm);
      if (_streamPasienKunjungan!.isClosed) return;
      pasienKunjunganSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPasienKunjungan!.isClosed) return;
      pasienKunjunganSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamPasienKunjungan?.close();
    _norm.close();
  }
}
