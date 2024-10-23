import 'dart:async';

import 'package:dokter_panggil/src/models/kunjungan_tindakan_lab_save_model.dart';
import 'package:dokter_panggil/src/repositories/kunjungan_tindakan_lab_save_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class KunjunganTindakanLabSaveBloc {
  final _repo = KunjunganTindakanLabSaveRepo();
  StreamController<ApiResponse<ResponseKunjunganTindakanbLabSaveModel>>?
      _streamKunjunganTindakanLabSave;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<int> _tindakanLab = BehaviorSubject();
  final BehaviorSubject<int> _hargaModal = BehaviorSubject();
  final BehaviorSubject<int> _tarifAplikasi = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<int> get tindakanLabSink => _tindakanLab.sink;
  StreamSink<int> get hargaModalSink => _hargaModal.sink;
  StreamSink<int> get tarifAplikasiSink => _tarifAplikasi.sink;
  StreamSink<ApiResponse<ResponseKunjunganTindakanbLabSaveModel>>
      get kunjunganTindakanLabSink => _streamKunjunganTindakanLabSave!.sink;
  Stream<ApiResponse<ResponseKunjunganTindakanbLabSaveModel>>
      get kunjungaTindakanLabStream => _streamKunjunganTindakanLabSave!.stream;

  Future<void> updateKunjunganTindakanLab() async {
    _streamKunjunganTindakanLabSave = StreamController();
    final id = _id.value;
    final tindakanLab = _tindakanLab.value;
    final hargaModal = _hargaModal.value;
    final tarifAplikasi = _tarifAplikasi.value;
    kunjunganTindakanLabSink.add(ApiResponse.loading('Memuat...'));
    KunjunganTindakanbLabSaveModel kunjunganTindakanbLabSaveModel =
        KunjunganTindakanbLabSaveModel(
            tindakanLab: tindakanLab,
            hargaModal: hargaModal,
            tarifAplikasi: tarifAplikasi);

    try {
      final res = await _repo.updateKunjunganTindakanLab(
          kunjunganTindakanbLabSaveModel, id);
      if (_streamKunjunganTindakanLabSave!.isClosed) return;
      kunjunganTindakanLabSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKunjunganTindakanLabSave!.isClosed) return;
      kunjunganTindakanLabSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamKunjunganTindakanLabSave?.close();
    _id.close();
    _tindakanLab.close();
    _hargaModal.close();
    _tarifAplikasi.close();
  }
}
