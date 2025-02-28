import 'dart:async';

import 'package:dokter_panggil/src/models/master_biaya_admin_emr_model.dart';
import 'package:dokter_panggil/src/repositories/master_biaya_admin_emr_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MasterBiayaAdminEmrBloc {
  final _repo = MasterBiayaAdminEmrRepo();
  StreamController<ApiResponse<MasterBiayaAdminEmrModel>>? _streamBiayaAdminEmr;
  final BehaviorSubject<String> _layanan = BehaviorSubject();
  StreamSink<String> get layananSink => _layanan.sink;
  StreamSink<ApiResponse<MasterBiayaAdminEmrModel>> get biayaAdminEmrSink =>
      _streamBiayaAdminEmr!.sink;
  Stream<ApiResponse<MasterBiayaAdminEmrModel>> get biayaAdminEmrStream =>
      _streamBiayaAdminEmr!.stream;

  Future<void> biayaAdminEmr() async {
    _streamBiayaAdminEmr = StreamController();
    final layanan = _layanan.value;
    biayaAdminEmrSink.add(ApiResponse.loading('Memuat...'));
    MasterBiayaAdminEmrRequestModel masterBiayaAdminEmrRequestModel =
        MasterBiayaAdminEmrRequestModel(layanan: layanan);
    try {
      final res = await _repo.biayaAdminEmr(masterBiayaAdminEmrRequestModel);
      if (_streamBiayaAdminEmr!.isClosed) return;
      biayaAdminEmrSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBiayaAdminEmr!.isClosed) return;
      biayaAdminEmrSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamBiayaAdminEmr?.close();
    _layanan.close();
  }
}
