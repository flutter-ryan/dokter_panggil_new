import 'dart:async';

import 'package:admin_dokter_panggil/src/models/kunjungan_obat_injeksi_update_model.dart';
import 'package:admin_dokter_panggil/src/repositories/kunjungan_obat_injeksi_update_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class KunjunganObatInjeksiUpdateBloc {
  final _repo = KunjunganObatInjeksiUpdateRepo();
  StreamController<ApiResponse<ResponseKunjunganObatInkjeksiUpdateModel>>?
      _streamObatInjeksiUpdate;
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
  StreamSink<ApiResponse<ResponseKunjunganObatInkjeksiUpdateModel>>
      get obatInjeksiUpdateSink => _streamObatInjeksiUpdate!.sink;
  Stream<ApiResponse<ResponseKunjunganObatInkjeksiUpdateModel>>
      get obatInjeksiUpdateStream => _streamObatInjeksiUpdate!.stream;
  Future<void> updateObatInjeksi() async {
    _streamObatInjeksiUpdate = StreamController();
    final id = _id.value;
    final barang = _barang.value;
    final jumlah = _jumlah.value;
    final hargaModal = _hargaModal.value;
    final tarifAplikasi = _tarifAplikasi.value;
    final alasan = _alasan.value;
    obatInjeksiUpdateSink.add(ApiResponse.loading('Memuat...'));
    KunjunganObatInkjeksiUpdateModel kunjunganObatInkjeksiUpdateModel =
        KunjunganObatInkjeksiUpdateModel(
            barang: barang,
            jumlah: jumlah,
            hargaModal: hargaModal,
            tarifAplikasi: tarifAplikasi,
            alasan: alasan);
    try {
      final res =
          await _repo.updateObatInjeksi(kunjunganObatInkjeksiUpdateModel, id);
      if (_streamObatInjeksiUpdate!.isClosed) return;
      obatInjeksiUpdateSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamObatInjeksiUpdate!.isClosed) return;
      obatInjeksiUpdateSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamObatInjeksiUpdate?.close();
    _id.close();
    _barang.close();
    _jumlah.close();
    _hargaModal.close();
    _tarifAplikasi.close();
  }
}
