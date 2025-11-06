import 'dart:async';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_penghentian_layanan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mr_kunjungan_penghentian_layanan_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrKunjunganPenghentianLayananBloc {
  final _repo = MrKunjunganPenghentianLayananRepo();
  StreamController<ApiResponse<MrKunjunganPenghentianLayananModel>>?
      _streamPenghentianLayanan;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<ApiResponse<MrKunjunganPenghentianLayananModel>>
      get penghentianLayananSink => _streamPenghentianLayanan!.sink;
  Stream<ApiResponse<MrKunjunganPenghentianLayananModel>>
      get penghentianLayananStream => _streamPenghentianLayanan!.stream;

  Future<void> getPenghentian() async {
    _streamPenghentianLayanan = StreamController();
    final idKunjungan = _idKunjungan.value;
    penghentianLayananSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getPenghentian(idKunjungan);
      if (_streamPenghentianLayanan!.isClosed) return;
      penghentianLayananSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPenghentianLayanan!.isClosed) return;
      penghentianLayananSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamPenghentianLayanan?.close();
    _idKunjungan.close();
  }
}
