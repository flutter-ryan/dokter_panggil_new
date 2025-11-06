import 'dart:async';
import 'package:admin_dokter_panggil/src/models/mr_hasil_lab_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mr_hasil_lab_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrHasilLabBloc {
  final _repo = MrHasilLabRepo();
  StreamController<ApiResponse<MrHasilLabModel>>? _streamHasilLab;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<ApiResponse<MrHasilLabModel>> get hasilLabSink =>
      _streamHasilLab!.sink;
  Stream<ApiResponse<MrHasilLabModel>> get hasilLabStream =>
      _streamHasilLab!.stream;
  Future<void> getHasilLab() async {
    _streamHasilLab = StreamController();
    final idKunjungan = _idKunjungan.value;
    hasilLabSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getHasilLab(idKunjungan);
      if (_streamHasilLab!.isClosed) return;
      hasilLabSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamHasilLab!.isClosed) return;
      hasilLabSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamHasilLab?.close();
    _idKunjungan.close();
  }
}
