import 'dart:async';

import 'package:admin_dokter_panggil/src/models/mr_kunjungan_cppt_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mr_kunjungan_cppt_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrKunjunganCpptBloc {
  final _repo = MrKunjunganCpptRepo();
  StreamController<ApiResponse<MrKunjunganCpptModel>>? _streamCppt;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<ApiResponse<MrKunjunganCpptModel>> get cpptSink =>
      _streamCppt!.sink;
  Stream<ApiResponse<MrKunjunganCpptModel>> get cpptStream =>
      _streamCppt!.stream;
  Future<void> getCppt() async {
    _streamCppt = StreamController();
    final idKunjungan = _idKunjungan.value;
    cpptSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getCppt(idKunjungan);
      if (_streamCppt!.isClosed) return;
      cpptSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamCppt!.isClosed) return;
      cpptSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamCppt?.close();
    _idKunjungan.close();
  }
}
