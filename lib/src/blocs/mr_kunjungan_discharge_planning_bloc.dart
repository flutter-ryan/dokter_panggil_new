import 'dart:async';

import 'package:admin_dokter_panggil/src/models/mr_kunjungan_discharge_planning_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mr_kunjungan_discharge_planning_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrKunjunganDischargePlanningBloc {
  final _repo = MrKunjunganDischargePlanningRepo();
  StreamController<ApiResponse<MrKunjunganDischargePlanningModel>>?
      _streamDischargePlanning;

  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<ApiResponse<MrKunjunganDischargePlanningModel>>
      get dischargePlanningSink => _streamDischargePlanning!.sink;
  Stream<ApiResponse<MrKunjunganDischargePlanningModel>>
      get dischargePlanningStream => _streamDischargePlanning!.stream;

  Future<void> getDischargePlanning() async {
    _streamDischargePlanning = StreamController();
    final idKunjungan = _idKunjungan.value;
    dischargePlanningSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getDischargePlanning(idKunjungan);
      if (_streamDischargePlanning!.isClosed) return;
      dischargePlanningSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamDischargePlanning!.isClosed) return;
      dischargePlanningSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamDischargePlanning?.close();
    _idKunjungan.close();
  }
}
