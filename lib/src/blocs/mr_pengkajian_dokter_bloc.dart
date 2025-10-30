import 'dart:async';
import 'package:admin_dokter_panggil/src/models/mr_pengkajian_dokter_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mr_pengkajian_dokter_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MrPengkajianDokterBloc {
  DataMrPengkajianDokter? dataPengkajianDokter;
  final _repo = MrPengkajianDokterRepo();
  StreamController<ApiResponse<DataMrPengkajianDokter>>?
      _streamPengkajianDokter;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSik => _idKunjungan.sink;
  StreamSink<ApiResponse<DataMrPengkajianDokter>> get pengkajianDokterSink =>
      _streamPengkajianDokter!.sink;
  Stream<ApiResponse<DataMrPengkajianDokter>> get pengkajianDokterStream =>
      _streamPengkajianDokter!.stream;

  Future<void> getPengkajianDokter() async {
    _streamPengkajianDokter = StreamController();
    final idKunjungan = _idKunjungan.value;
    pengkajianDokterSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getPengkajianDokter(idKunjungan);
      if (_streamPengkajianDokter!.isClosed) return;
      dataPengkajianDokter = res.data;
      pengkajianDokterSink.add(ApiResponse.completed(dataPengkajianDokter));
    } catch (e) {
      if (_streamPengkajianDokter!.isClosed) return;
      pengkajianDokterSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamPengkajianDokter?.close();
    _idKunjungan.close();
  }
}
