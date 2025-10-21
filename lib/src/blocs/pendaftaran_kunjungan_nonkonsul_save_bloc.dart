import 'dart:async';

import 'package:admin_dokter_panggil/src/models/pendaftaran_kunjungan_nonkonsul_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/pendaftaran_kunjungan_nonkonsul_save_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class PendaftaranKunjunganNonkonsulSaveBloc {
  final _repo = PendaftaranKunjunganNonkonsulSaveRepo();
  StreamController<ApiResponse<ResponsePendaftaranKunjunganNonkonsulSaveModel>>?
      _streamKunjunganNonkonsul;
  final BehaviorSubject<String> _norm = BehaviorSubject();
  final BehaviorSubject<String> _tanggal = BehaviorSubject();
  final BehaviorSubject<String> _jam = BehaviorSubject();
  final BehaviorSubject<List<int>> _tindakanLab = BehaviorSubject();
  final BehaviorSubject<List<int>> _hargaModal = BehaviorSubject();
  final BehaviorSubject<List<int>> _tarifAplikasi = BehaviorSubject();
  final BehaviorSubject<int> _perawat = BehaviorSubject();
  final BehaviorSubject<int> _status = BehaviorSubject();
  final BehaviorSubject<List<String>> _tokens = BehaviorSubject.seeded([]);
  StreamSink<String> get normSink => _norm.sink;
  StreamSink<String> get tanggalSink => _tanggal.sink;
  StreamSink<String> get jamSink => _jam.sink;
  StreamSink<List<int>> get tindakanLabSink => _tindakanLab.sink;
  StreamSink<List<int>> get hargaModalSink => _hargaModal.sink;
  StreamSink<List<int>> get tarifAplikasiSink => _tarifAplikasi.sink;
  StreamSink<int> get perawatSink => _perawat.sink;
  StreamSink<int> get statusSink => _status.sink;
  StreamSink<List<String>> get tokensSink => _tokens.sink;
  StreamSink<ApiResponse<ResponsePendaftaranKunjunganNonkonsulSaveModel>>
      get kunjunganNonkonsulSink => _streamKunjunganNonkonsul!.sink;
  Stream<ApiResponse<ResponsePendaftaranKunjunganNonkonsulSaveModel>>
      get kunjunganNonkonsulStream => _streamKunjunganNonkonsul!.stream;

  Future<void> saveKunjunganNonkonsul() async {
    _streamKunjunganNonkonsul = StreamController();
    final norm = _norm.value;
    final tanggal = _tanggal.value;
    final tindakanLab = _tindakanLab.value;
    final jam = _jam.value;
    final hargaModal = _hargaModal.value;
    final tarifAplikasi = _tarifAplikasi.value;
    final perawat = _perawat.value;
    final status = _status.value;
    final tokens = _tokens.value;
    kunjunganNonkonsulSink.add(ApiResponse.loading('Memuat...'));
    PendaftaranKunjunganNonkonsulSaveModel
        pendaftaranKunjunganNonkonsulSaveModel =
        PendaftaranKunjunganNonkonsulSaveModel(
      norm: norm,
      tanggal: tanggal,
      jam: jam,
      tindakanLab: tindakanLab,
      hargaModal: hargaModal,
      tarifAplikasi: tarifAplikasi,
      perawat: perawat,
      status: status,
      tokens: tokens,
    );
    try {
      final res = await _repo
          .saveKunjunganNonKonsul(pendaftaranKunjunganNonkonsulSaveModel);
      if (_streamKunjunganNonkonsul!.isClosed) return;
      kunjunganNonkonsulSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKunjunganNonkonsul!.isClosed) return;
      kunjunganNonkonsulSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamKunjunganNonkonsul?.close();
    _norm.close();
    _jam.close();
    _tanggal.close();
    _tindakanLab.close();
    _hargaModal.close();
    _tarifAplikasi.close();
    _status.close();
  }
}
