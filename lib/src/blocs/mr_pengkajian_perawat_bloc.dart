import 'dart:async';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_pengkajian_perawat_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_pengkajian_perawat_anak_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mr_pengkajian_perawat_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrPengkajianPerawatBloc {
  final _repo = MrPengkajianPerawatRepo();
  StreamController<ApiResponse<MrKunjunganPengkajianPerawatModel>>?
      _streamPengkajianPerawat;
  StreamController<ApiResponse<MrPengkajianPerawatAnakModel>>?
      _streamPengkajianPerawatAnak;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<ApiResponse<MrKunjunganPengkajianPerawatModel>>
      get pengkajianPerawatSink => _streamPengkajianPerawat!.sink;
  Stream<ApiResponse<MrKunjunganPengkajianPerawatModel>>
      get pengkajianPerawatStream => _streamPengkajianPerawat!.stream;
  StreamSink<ApiResponse<MrPengkajianPerawatAnakModel>>
      get pengkajianPerawatAnakSink => _streamPengkajianPerawatAnak!.sink;
  Stream<ApiResponse<MrPengkajianPerawatAnakModel>>
      get pengkajianPerawatAnakStream => _streamPengkajianPerawatAnak!.stream;

  Future<void> getPengkajianPerawat() async {
    _streamPengkajianPerawat = StreamController();
    final idKunjungan = _idKunjungan.value;
    pengkajianPerawatSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getPengkajianPerawat(idKunjungan);
      if (_streamPengkajianPerawat!.isClosed) return;
      pengkajianPerawatSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPengkajianPerawat!.isClosed) return;
      pengkajianPerawatSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getPengkajianPerawatAnak() async {
    _streamPengkajianPerawatAnak = StreamController();
    final idKunjungan = _idKunjungan.value;
    pengkajianPerawatAnakSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getPengkajianPerawatAnak(idKunjungan);
      if (_streamPengkajianPerawatAnak!.isClosed) return;
      pengkajianPerawatAnakSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPengkajianPerawatAnak!.isClosed) return;
      pengkajianPerawatAnakSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamPengkajianPerawat?.close();
    _streamPengkajianPerawatAnak?.close();
    _idKunjungan.close();
  }
}
