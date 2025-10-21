import 'dart:async';

import 'package:admin_dokter_panggil/src/models/tagihan_tindakan_rad_model.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/repositories/tagihan_tindakan_rad_repo.dart';
import 'package:rxdart/rxdart.dart';

class TagihanTindakanRadBloc {
  final _repo = TagihanTindakanRadRepo();
  StreamController<ApiResponse<ResponseTagihanTindakanRadModel>>?
      _streamTagihanRad;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  final BehaviorSubject<String> _norm = BehaviorSubject();
  final BehaviorSubject<List<int>> _idTindakan = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<int>> _hargaModal = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<int>> _tarifAplikasi = BehaviorSubject.seeded([]);
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<String> get normSink => _norm.sink;
  StreamSink<List<int>> get idTindakanSink => _idTindakan.sink;
  StreamSink<List<int>> get hargaModalSink => _hargaModal.sink;
  StreamSink<List<int>> get tarifAplikasiSink => _tarifAplikasi.sink;
  StreamSink<ApiResponse<ResponseTagihanTindakanRadModel>>
      get tagihanTindakanRadSink => _streamTagihanRad!.sink;
  Stream<ApiResponse<ResponseTagihanTindakanRadModel>>
      get tagihanTindakanRadStream => _streamTagihanRad!.stream;

  Future<void> saveTindakanRad() async {
    _streamTagihanRad = StreamController();
    final idKunjungan = _idKunjungan.value;
    final norm = _norm.value;
    final idTindakan = _idTindakan.value;
    final hargaModal = _hargaModal.value;
    final tarifAplikasi = _tarifAplikasi.value;
    tagihanTindakanRadSink.add(ApiResponse.loading('Memuat...'));
    TagihanTindakanRadModel tagihanTindakanRadModel = TagihanTindakanRadModel(
        idKunjungan: idKunjungan,
        norm: norm,
        idTindakan: idTindakan,
        hargaModal: hargaModal,
        tarifAplikasi: tarifAplikasi);

    try {
      final res = await _repo.saveTindakanRad(tagihanTindakanRadModel);
      if (_streamTagihanRad!.isClosed) return;
      tagihanTindakanRadSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTagihanRad!.isClosed) return;
      tagihanTindakanRadSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamTagihanRad?.close();
    _idKunjungan.close();
    _idTindakan.close();
    _hargaModal.close();
    _tarifAplikasi.close();
    _norm.close();
  }
}
