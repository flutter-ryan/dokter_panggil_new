import 'dart:async';

import 'package:dokter_panggil/src/models/pendaftaran_pembelian_langsug_save_model.dart';
import 'package:dokter_panggil/src/repositories/pendaftaran_kunjungan_save_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class PendaftaranPembelianLangsungBloc {
  final _repo = PendaftaranKunjunganSaveRepo();
  StreamController<ApiResponse<ResponsePendaftaranPembelianLangsungSaveModel>>?
      _streamPembelianLangsung;

  final BehaviorSubject<String> _norm = BehaviorSubject();
  final BehaviorSubject<String> _tanggal = BehaviorSubject();
  final BehaviorSubject<String> _jam = BehaviorSubject();
  final BehaviorSubject<List<int>> _drugs = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<int>> _consumes = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<int>> _jumlahDrugs = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<int>> _jumlahConsumes = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<int>> _hargaModalDrugs =
      BehaviorSubject.seeded([]);
  final BehaviorSubject<List<int>> _hargaModalConsumes =
      BehaviorSubject.seeded([]);
  final BehaviorSubject<List<int>> _tarifAplikasiDrugs =
      BehaviorSubject.seeded([]);
  final BehaviorSubject<List<int>> _tarifAplikasiConsumes =
      BehaviorSubject.seeded([]);
  final BehaviorSubject<List<String>> _aturan = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<String>> _catatan = BehaviorSubject.seeded([]);
  StreamSink<String> get normSink => _norm.sink;
  StreamSink<String> get tanggalSink => _tanggal.sink;
  StreamSink<String> get jamSink => _jam.sink;
  StreamSink<List<int>> get drugsSink => _drugs.sink;
  StreamSink<List<int>> get consumesSink => _consumes.sink;
  StreamSink<List<int>> get jumlahDrugsSink => _jumlahDrugs.sink;
  StreamSink<List<int>> get jumlahConsumesSink => _jumlahConsumes.sink;
  StreamSink<List<int>> get hargaModalDrugsSink => _hargaModalDrugs.sink;
  StreamSink<List<int>> get hargaModalConsumesSink => _hargaModalConsumes.sink;
  StreamSink<List<int>> get tarifAplikasiDrugsSink => _tarifAplikasiDrugs.sink;
  StreamSink<List<int>> get tarifAplikasiConsumesSink =>
      _tarifAplikasiConsumes.sink;
  StreamSink<List<String>> get aturanSink => _aturan.sink;
  StreamSink<List<String>> get catatanSink => _catatan.sink;
  StreamSink<ApiResponse<ResponsePendaftaranPembelianLangsungSaveModel>>
      get pembelianLangsungSink => _streamPembelianLangsung!.sink;
  Stream<ApiResponse<ResponsePendaftaranPembelianLangsungSaveModel>>
      get pembelianLansungStream => _streamPembelianLangsung!.stream;

  Future<void> savePembelianLangsung() async {
    _streamPembelianLangsung = StreamController();
    final norm = _norm.value;
    final tanggal = _tanggal.value;
    final jam = _jam.value;
    final drugs = _drugs.value;
    final consumes = _consumes.value;
    final jumlahDrugs = _jumlahDrugs.value;
    final jumlahConsumes = _jumlahConsumes.value;
    final hargaModalDrugs = _hargaModalDrugs.value;
    final hargaModalConsumes = _hargaModalConsumes.value;
    final tarifAplikasiDrugs = _tarifAplikasiDrugs.value;
    final tarifAplikasiConsumes = _tarifAplikasiConsumes.value;
    final aturan = _aturan.value;
    final catatan = _catatan.value;
    pembelianLangsungSink.add(ApiResponse.loading('Memuat...'));
    PendaftaranPembelianLangsungSaveModel
        pendaftaranPembelianLangsungSaveModel =
        PendaftaranPembelianLangsungSaveModel(
      norm: norm,
      tanggal: tanggal,
      jam: jam,
      drugs: drugs,
      consumes: consumes,
      jumlahDrugs: jumlahDrugs,
      jumlahConsumes: jumlahConsumes,
      hargaModalDrugs: hargaModalDrugs,
      hargaModalConsumes: hargaModalConsumes,
      tarifAplikasiDrugs: tarifAplikasiDrugs,
      tarifAplikasiConsumes: tarifAplikasiConsumes,
      aturan: aturan,
      catatan: catatan,
      status: 1,
    );

    try {
      final res = await _repo
          .savePembelianLangsung(pendaftaranPembelianLangsungSaveModel);
      if (_streamPembelianLangsung!.isClosed) return;
      pembelianLangsungSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPembelianLangsung!.isClosed) return;
      pembelianLangsungSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamPembelianLangsung?.close();
    _norm.close();
    _tanggal.close();
    _jam.close();
    _drugs.close();
    _consumes.close();
    _jumlahConsumes.close();
    _jumlahDrugs.close();
    _hargaModalDrugs.close();
    _hargaModalConsumes.close();
    _tarifAplikasiConsumes.close();
    _tarifAplikasiDrugs.close();
    _aturan.close();
    _catatan.close();
  }
}
