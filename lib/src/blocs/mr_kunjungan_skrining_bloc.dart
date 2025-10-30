import 'dart:async';

import 'package:admin_dokter_panggil/src/models/mr_kunjungan_skrining_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mr_kunjungan_skrining_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrKunjunganSkriningBloc {
  final _repo = MrKunjunganSkriningRepo();
  StreamController<ApiResponse<MrKunjunganSkriningModel>>? _streamSkrining;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<ApiResponse<MrKunjunganSkriningModel>> get skriningSink =>
      _streamSkrining!.sink;
  Stream<ApiResponse<MrKunjunganSkriningModel>> get skriningStream =>
      _streamSkrining!.stream;

  Future<void> getSkrining() async {
    _streamSkrining = StreamController();
    final idKunjungan = _idKunjungan.value;
    skriningSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getSkrining(idKunjungan);
      if (_streamSkrining!.isClosed) return;
      skriningSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamSkrining!.isClosed) return;
      skriningSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamSkrining?.close();
    _idKunjungan.close();
  }
}
