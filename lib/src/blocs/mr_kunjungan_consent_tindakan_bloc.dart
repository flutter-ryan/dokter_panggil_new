import 'dart:async';

import 'package:admin_dokter_panggil/src/models/mr_kunjungan_consent_tindakan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mr_kunjungan_consent_tindakan_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrKunjunganConsentTindakanBloc {
  final _repo = MrKunjunganConsentTindakanRepo();
  StreamController<ApiResponse<MrKunjunganConsentTindakanModel>>?
      _streamConsentTindakan;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<ApiResponse<MrKunjunganConsentTindakanModel>>
      get consentTindakanSink => _streamConsentTindakan!.sink;
  Stream<ApiResponse<MrKunjunganConsentTindakanModel>>
      get consentTindakanStream => _streamConsentTindakan!.stream;

  Future<void> getConsentTindakan() async {
    _streamConsentTindakan = StreamController();
    final idKunjungan = _idKunjungan.value;
    consentTindakanSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getConsentTindakan(idKunjungan);
      if (_streamConsentTindakan!.isClosed) return;
      consentTindakanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamConsentTindakan!.isClosed) return;
      consentTindakanSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamConsentTindakan?.close();
    _idKunjungan.close();
  }
}
