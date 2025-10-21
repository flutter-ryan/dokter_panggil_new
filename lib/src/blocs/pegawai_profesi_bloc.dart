import 'dart:async';

import 'package:admin_dokter_panggil/src/models/pegawai_dokter_model.dart';
import 'package:admin_dokter_panggil/src/repositories/pegawai_profesi_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class PegawaiProfesiBloc {
  final PegawaiProfesiRepo _repo = PegawaiProfesiRepo();
  StreamController<ApiResponse<PegawaiProfesiModel>>? _streamPegawaiProfesi;
  final BehaviorSubject<int> _groupId = BehaviorSubject();
  final BehaviorSubject<String> _filter = BehaviorSubject.seeded('');
  StreamSink<int> get groupIdSink => _groupId.sink;
  StreamSink<String> get filtersink => _filter.sink;
  StreamSink<ApiResponse<PegawaiProfesiModel>> get pegawaiProfesiSink =>
      _streamPegawaiProfesi!.sink;
  Stream<ApiResponse<PegawaiProfesiModel>> get pegawaiProfesiStream =>
      _streamPegawaiProfesi!.stream;

  Future<void> pegawaiProfesi() async {
    _streamPegawaiProfesi = StreamController();
    final groupId = _groupId.value;
    pegawaiProfesiSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.profesiPegawai(groupId);
      if (_streamPegawaiProfesi!.isClosed) return;
      pegawaiProfesiSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPegawaiProfesi!.isClosed) return;
      pegawaiProfesiSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> filterPegawaiProfesi() async {
    _streamPegawaiProfesi = StreamController();
    final groupId = _groupId.value;
    final filter = _filter.value;
    pegawaiProfesiSink.add(ApiResponse.loading('Memuat..'));
    PegawaiProfesiRequestModel pegawaiProfesiRequestModel =
        PegawaiProfesiRequestModel(filter: filter);

    try {
      final res =
          await _repo.filterProfesiPegawai(pegawaiProfesiRequestModel, groupId);
      if (_streamPegawaiProfesi!.isClosed) return;
      pegawaiProfesiSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPegawaiProfesi!.isClosed) return;
      pegawaiProfesiSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamPegawaiProfesi?.close();
    _filter.close();
    _groupId.close();
  }
}
