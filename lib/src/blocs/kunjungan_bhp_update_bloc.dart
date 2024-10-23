import 'dart:async';

import 'package:dokter_panggil/src/models/kunjungan_bhp_update_model.dart';
import 'package:dokter_panggil/src/repositories/kunjungan_bhp_update_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class KunjunganBhpUpdateBloc {
  final _repo = KunjunganBhpUpdateRepo();
  StreamController<ApiResponse<ResponseKunjunganBhpUpdateModel>>?
      _streamKunjunganBhpUpdate;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<int> _barang = BehaviorSubject();
  final BehaviorSubject<int> _jumlah = BehaviorSubject();
  final BehaviorSubject<int> _hargaModal = BehaviorSubject();
  final BehaviorSubject<int> _tarifAplikasi = BehaviorSubject();
  final BehaviorSubject<String> _alasan = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<int> get barangSink => _barang.sink;
  StreamSink<int> get jumlahSink => _jumlah.sink;
  StreamSink<int> get hargaModalSink => _hargaModal.sink;
  StreamSink<int> get tarifAplikasiSink => _tarifAplikasi.sink;
  StreamSink<String> get alasanSink => _alasan.sink;
  StreamSink<ApiResponse<ResponseKunjunganBhpUpdateModel>>
      get kunjunganBhpUpdateSink => _streamKunjunganBhpUpdate!.sink;
  Stream<ApiResponse<ResponseKunjunganBhpUpdateModel>>
      get kunjunganBhpUpdateStream => _streamKunjunganBhpUpdate!.stream;

  Future<void> updateKunjunganBhp() async {
    _streamKunjunganBhpUpdate = StreamController();
    final id = _id.value;
    final barang = _barang.value;
    final jumlah = _jumlah.value;
    final hargaModal = _hargaModal.value;
    final tarifAplikasi = _tarifAplikasi.value;
    final alasan = _alasan.value;
    kunjunganBhpUpdateSink.add(ApiResponse.loading('Memuat...'));
    KunjunganBhpUpdateModel kunjunganBhpUpdateModel = KunjunganBhpUpdateModel(
        barang: barang,
        jumlah: jumlah,
        hargaModal: hargaModal,
        tarifAplikasi: tarifAplikasi,
        alasan: alasan);

    try {
      final res = await _repo.updateKunjunganBhp(kunjunganBhpUpdateModel, id);
      if (_streamKunjunganBhpUpdate!.isClosed) return;
      kunjunganBhpUpdateSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKunjunganBhpUpdate!.isClosed) return;
      kunjunganBhpUpdateSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamKunjunganBhpUpdate?.close();
    _id.close();
    _barang.close();
    _jumlah.close();
    _tarifAplikasi.close();
    _hargaModal.close();
  }
}
