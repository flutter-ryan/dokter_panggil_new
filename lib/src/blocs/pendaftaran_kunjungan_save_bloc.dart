import 'dart:async';

import 'package:dokter_panggil/src/models/pendaftaran_kunjungan_paket_save_mode.dart';
import 'package:dokter_panggil/src/models/pendaftaran_kunjungan_save_model.dart';
import 'package:dokter_panggil/src/repositories/pendaftaran_kunjungan_save_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class PendaftaranKunjunganSaveBloc {
  final PendaftaranKunjunganSaveRepo _repo = PendaftaranKunjunganSaveRepo();
  StreamController<ApiResponse<ResponsePendaftaranKunjunganSaveModel>>?
      _streamPendaftaranSave;
  final BehaviorSubject<String> _norm = BehaviorSubject();
  final BehaviorSubject<String> _tanggal = BehaviorSubject();
  final BehaviorSubject<String> _jam = BehaviorSubject();
  final BehaviorSubject<String> _dokter = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _perawat = BehaviorSubject.seeded('');
  final BehaviorSubject<List<int>> _tindakan = BehaviorSubject();
  final BehaviorSubject<List<int>> _jasaDokter = BehaviorSubject();
  final BehaviorSubject<List<int>> _jasaDrp = BehaviorSubject();
  final BehaviorSubject<List<int>> _total = BehaviorSubject();
  final BehaviorSubject<List<int>> _groupTindakan = BehaviorSubject.seeded([]);
  final BehaviorSubject<String> _keluhan = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _namaWali = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _hubungan = BehaviorSubject.seeded('');
  final BehaviorSubject<String> _nomorWali = BehaviorSubject.seeded('');
  final BehaviorSubject<List<String>> _tokenFcm = BehaviorSubject.seeded([]);
  final BehaviorSubject<int> _status = BehaviorSubject.seeded(1);
  final BehaviorSubject<int> _idPaket = BehaviorSubject();

  StreamSink<String> get normSink => _norm.sink;
  StreamSink<String> get tanggalSink => _tanggal.sink;
  StreamSink<String> get jamSink => _jam.sink;
  StreamSink<String> get dokterSink => _dokter.sink;
  StreamSink<String> get perawatSink => _perawat.sink;
  StreamSink<List<int>> get tindakanSink => _tindakan.sink;
  StreamSink<List<int>> get jasaDokterSink => _jasaDokter.sink;
  StreamSink<List<int>> get jasaDrpSink => _jasaDrp.sink;
  StreamSink<List<int>> get totalSink => _total.sink;
  StreamSink<List<int>> get groupTindakanSink => _groupTindakan.sink;
  StreamSink<String> get keluhanSink => _keluhan.sink;
  StreamSink<String> get namaWaliSink => _namaWali.sink;
  StreamSink<String> get hubunganSink => _hubungan.sink;
  StreamSink<String> get nomorWaliSink => _nomorWali.sink;
  StreamSink<List<String>> get tokenFcmSink => _tokenFcm.sink;
  StreamSink<int> get statusSink => _status.sink;
  StreamSink<int> get idPaketSink => _idPaket.sink;
  StreamSink<ApiResponse<ResponsePendaftaranKunjunganSaveModel>>
      get pendaftaranSaveSink => _streamPendaftaranSave!.sink;
  Stream<ApiResponse<ResponsePendaftaranKunjunganSaveModel>>
      get pendaftaranSaveStream => _streamPendaftaranSave!.stream;

  Future<void> saveKunjungan() async {
    _streamPendaftaranSave = StreamController();
    final norm = _norm.value;
    final tanggal = _tanggal.value;
    final jam = _jam.value;
    final dokter = _dokter.value;
    final perawat = _perawat.value;
    final tindakan = _tindakan.value;
    final jasaDokter = _jasaDokter.value;
    final jasaDrp = _jasaDrp.value;
    final total = _total.value;
    final groupTindakan = _groupTindakan.value;
    final keluhan = _keluhan.value;
    final namaWali = _namaWali.value;
    final hubungan = _hubungan.value;
    final nomorWali = _nomorWali.value;
    final tokens = _tokenFcm.value;
    final status = _status.value;
    pendaftaranSaveSink.add(ApiResponse.loading('Memuat...'));
    PendaftaranKunjunganSaveModel pendaftaranKunjunganSaveModel =
        PendaftaranKunjunganSaveModel(
      norm: norm,
      tanggal: tanggal,
      jam: jam,
      dokter: dokter,
      perawat: perawat,
      tindakan: tindakan,
      jasaDokter: jasaDokter,
      jasaDrp: jasaDrp,
      total: total,
      groupTindakan: groupTindakan,
      keluhan: keluhan,
      namaWali: namaWali,
      hubungan: hubungan,
      nomorWali: nomorWali,
      tokens: tokens,
      status: status,
    );
    try {
      final res = await _repo.saveKunjungan(pendaftaranKunjunganSaveModel);
      if (_streamPendaftaranSave!.isClosed) return;
      pendaftaranSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPendaftaranSave!.isClosed) return;
      pendaftaranSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> saveKunjunganPaket() async {
    _streamPendaftaranSave = StreamController();
    final norm = _norm.value;
    final tanggal = _tanggal.value;
    final jam = _jam.value;
    final dokter = _dokter.value;
    final perawat = _perawat.value;
    final idPaket = _idPaket.value;
    final status = _status.value;
    final tokens = _tokenFcm.value;
    pendaftaranSaveSink.add(ApiResponse.loading('Memuat...'));
    PendaftaranKunjunganPaketSaveModel pendaftaranKunjunganPaketSaveModel =
        PendaftaranKunjunganPaketSaveModel(
      norm: norm,
      tanggal: tanggal,
      jam: jam,
      idPaket: idPaket,
      dokter: dokter,
      perawat: perawat,
      status: status,
      tokens: tokens,
    );
    try {
      final res =
          await _repo.saveKunjunganPaket(pendaftaranKunjunganPaketSaveModel);
      if (_streamPendaftaranSave!.isClosed) return;
      pendaftaranSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPendaftaranSave!.isClosed) return;
      pendaftaranSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamPendaftaranSave?.close();
    _norm.close();
    _tanggal.close();
    _jam.close();
    _dokter.close();
    _perawat.close();
    _tindakan.close();
    _keluhan.close();
    _namaWali.close();
    _hubungan.close();
    _nomorWali.close();
    _status.close();
    _idPaket.close();
  }
}
