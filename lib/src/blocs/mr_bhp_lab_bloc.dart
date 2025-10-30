import 'dart:async';

import 'package:admin_dokter_panggil/src/models/mr_bhp_lab_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mr_bhp_lab_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrBhpLabBloc {
  final _repo = MrBhpLabRepo();
  StreamController<ApiResponse<MrBhpLabModel>>? _streamBhpLab;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<ApiResponse<MrBhpLabModel>> get bhpLabSink => _streamBhpLab!.sink;
  Stream<ApiResponse<MrBhpLabModel>> get bhpLabStream => _streamBhpLab!.stream;

  Future<void> getBhpLab() async {
    _streamBhpLab = StreamController();
    final idKunjungan = _idKunjungan.value;
    bhpLabSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getBhpLab(idKunjungan);
      if (_streamBhpLab!.isClosed) return;
      bhpLabSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBhpLab!.isClosed) return;
      bhpLabSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamBhpLab?.close();
    _idKunjungan.close();
  }
}
