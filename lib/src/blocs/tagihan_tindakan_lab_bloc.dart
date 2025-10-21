import 'dart:async';

import 'package:admin_dokter_panggil/src/models/tagihan_tindakan_lab_model.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/repositories/tagihan_tindakan_lab_repo.dart';
import 'package:rxdart/rxdart.dart';

class TagihanTindakanLabBloc {
  final _repo = TagihanTindakanLabRepo();
  StreamController<ApiResponse<ResponseTagihanTindakanLabModel>>?
      _streamTagihanTindakanLab;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  final BehaviorSubject<String> _norm = BehaviorSubject();
  final BehaviorSubject<List<int>> _idTindakan = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<int>> _hargaModal = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<int>> _tarifAplikasi = BehaviorSubject.seeded([]);
  final BehaviorSubject<bool> _isPaket = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<String> get normSink => _norm.sink;
  StreamSink<List<int>> get idTindakanSink => _idTindakan.sink;
  StreamSink<List<int>> get hargaModalSink => _hargaModal.sink;
  StreamSink<List<int>> get tarifAplikasiSink => _tarifAplikasi.sink;
  StreamSink<bool> get isPaketSink => _isPaket.sink;
  StreamSink<ApiResponse<ResponseTagihanTindakanLabModel>>
      get tagihanTindakanLabSink => _streamTagihanTindakanLab!.sink;
  Stream<ApiResponse<ResponseTagihanTindakanLabModel>>
      get tagihanTindakanLabStream => _streamTagihanTindakanLab!.stream;

  Future<void> saveTindakanLab() async {
    _streamTagihanTindakanLab = StreamController();
    final idKunjungan = _idKunjungan.value;
    final norm = _norm.value;
    final idTindakan = _idTindakan.value;
    final hargaModal = _hargaModal.value;
    final tarifAplikasi = _tarifAplikasi.value;
    final isPaket = _isPaket.value;
    tagihanTindakanLabSink.add(ApiResponse.loading('Memuat...'));
    TagihanTindakanLabModel tagihanTindakanLabModel = TagihanTindakanLabModel(
      idKunjungan: idKunjungan,
      norm: norm,
      idTindakan: idTindakan,
      hargaModal: hargaModal,
      tarifAplikasi: tarifAplikasi,
      isPaket: isPaket,
    );
    try {
      final res = await _repo.saveTindakanLab(tagihanTindakanLabModel);
      if (_streamTagihanTindakanLab!.isClosed) return;
      tagihanTindakanLabSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTagihanTindakanLab!.isClosed) return;
      tagihanTindakanLabSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamTagihanTindakanLab?.close();
    _idKunjungan.close();
    _idTindakan.close();
    _hargaModal.close();
    _tarifAplikasi.close();
    _norm.close();
  }
}
