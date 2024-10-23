import 'dart:async';

import 'package:dokter_panggil/src/models/master_paket_model.dart';
import 'package:dokter_panggil/src/repositories/master_paket_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MasterPaketBloc {
  final _repo = MasterPaketRepo();
  StreamController<ApiResponse<ResponseMasterPaketModel>>?
      _streamMasterPaketSave;
  final BehaviorSubject<int> _idPaket = BehaviorSubject();
  final BehaviorSubject<String> _jenisHarga = BehaviorSubject();
  final BehaviorSubject<String> _namaPaket = BehaviorSubject();
  final BehaviorSubject<int> _diskon = BehaviorSubject.seeded(0);
  final BehaviorSubject<int> _harga = BehaviorSubject();
  final BehaviorSubject<int> _total = BehaviorSubject();
  final BehaviorSubject<List<int>> _tindakans = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<int>> _jumlahTindakan = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<int>> _drugs = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<int>> _jumlahDrugs = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<String>> _aturanDrugs = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<String>> _catatanDrugs =
      BehaviorSubject.seeded([]);
  final BehaviorSubject<List<int>> _consumes = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<int>> _jumlahConsumes = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<int>> _farmasis = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<int>> _jumlahFarmasis = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<String>> _aturanFarmasi =
      BehaviorSubject.seeded([]);
  final BehaviorSubject<List<String>> _catatanFarmasi =
      BehaviorSubject.seeded([]);
  final BehaviorSubject<List<int>> _labs = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<int>> _rads = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<bool>> _isDokter = BehaviorSubject.seeded([]);

  StreamSink<int> get idPaketSink => _idPaket.sink;
  StreamSink<String> get jenisHarga => _jenisHarga.sink;
  StreamSink<String> get namaPaketSink => _namaPaket.sink;
  StreamSink<int> get diskonSink => _diskon.sink;
  StreamSink<int> get hargaSink => _harga.sink;
  StreamSink<int> get totalSink => _total.sink;
  StreamSink<List<int>> get tindakanSink => _tindakans.sink;
  StreamSink<List<int>> get jumlahTindakanSink => _jumlahTindakan.sink;
  StreamSink<List<int>> get drugsSink => _drugs.sink;
  StreamSink<List<int>> get jumlahDrugsSink => _jumlahDrugs.sink;
  StreamSink<List<String>> get aturanDrugsSink => _aturanDrugs.sink;
  StreamSink<List<String>> get catatanDrugSink => _catatanDrugs.sink;
  StreamSink<List<int>> get consumesSink => _consumes.sink;
  StreamSink<List<int>> get jumlahConsumesSink => _jumlahConsumes.sink;
  StreamSink<List<int>> get farmasisSink => _farmasis.sink;
  StreamSink<List<int>> get jumlashFarmasisSink => _jumlahFarmasis.sink;
  StreamSink<List<String>> get aturanFarmasiSink => _aturanFarmasi.sink;
  StreamSink<List<String>> get catatanFarmasiSink => _catatanFarmasi.sink;
  StreamSink<List<int>> get labSink => _labs.sink;
  StreamSink<List<int>> get radSink => _rads.sink;
  StreamSink<List<bool>> get isDokterSink => _isDokter.sink;
  StreamSink<ApiResponse<ResponseMasterPaketModel>> get masterPaketSaveSink =>
      _streamMasterPaketSave!.sink;
  Stream<ApiResponse<ResponseMasterPaketModel>> get masterPaketSaveStream =>
      _streamMasterPaketSave!.stream;

  Future<void> saveMasterPaket() async {
    _streamMasterPaketSave = StreamController();
    final jenisHarga = _jenisHarga.value;
    final namaPaket = _namaPaket.value;
    final diskon = _diskon.value;
    final harga = _harga.value;
    final total = _total.value;
    final tindakans = _tindakans.value;
    final jumlahTindakan = _jumlahTindakan.value;
    final drugs = _drugs.value;
    final jumlahDrugs = _jumlahDrugs.value;
    final aturanDrugs = _aturanDrugs.value;
    final catatanDrugs = _catatanDrugs.value;
    final consumes = _consumes.value;
    final jumlahConsumes = _jumlahConsumes.value;
    final farmasis = _farmasis.value;
    final jumlahFarmasi = _jumlahFarmasis.value;
    final aturanFarmasi = _aturanFarmasi.value;
    final catatanFarmasi = _catatanFarmasi.value;
    final labs = _labs.value;
    final rads = _rads.value;
    final isDokter = _isDokter.value;
    masterPaketSaveSink.add(ApiResponse.loading('Memuat...'));
    MasterPaketModel masterPaketModel = MasterPaketModel(
      jenisHarga: jenisHarga,
      namaPaket: namaPaket,
      diskon: diskon,
      harga: harga,
      total: total,
      tindakans: tindakans,
      jumlahTindakan: jumlahTindakan,
      drugs: drugs,
      jumlahDrugs: jumlahDrugs,
      aturanDrugs: aturanDrugs,
      catatanDrugs: catatanDrugs,
      consumes: consumes,
      jumlahConsumes: jumlahConsumes,
      farmasis: farmasis,
      jumlahFarmasi: jumlahFarmasi,
      aturanFarmasi: aturanFarmasi,
      catatanFarmasi: catatanFarmasi,
      labs: labs,
      rads: rads,
      isDokter: isDokter,
    );

    try {
      final res = await _repo.saveMasterPaket(masterPaketModel);
      if (_streamMasterPaketSave!.isClosed) return;
      masterPaketSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterPaketSave!.isClosed) return;
      masterPaketSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> updateMasterPaket() async {
    _streamMasterPaketSave = StreamController();
    final idPaket = _idPaket.value;
    final jenisHarga = _jenisHarga.value;
    final namaPaket = _namaPaket.value;
    final diskon = _diskon.value;
    final harga = _harga.value;
    final total = _total.value;
    final tindakans = _tindakans.value;
    final jumlahTindakan = _jumlahTindakan.value;
    final drugs = _drugs.value;
    final jumlahDrugs = _jumlahDrugs.value;
    final aturanDrugs = _aturanDrugs.value;
    final catatanDrugs = _catatanDrugs.value;
    final consumes = _consumes.value;
    final jumlahConsumes = _jumlahConsumes.value;
    final farmasis = _farmasis.value;
    final jumlahFarmasi = _jumlahFarmasis.value;
    final aturanFarmasi = _aturanFarmasi.value;
    final catatanFarmasi = _catatanFarmasi.value;
    final labs = _labs.value;
    final rads = _rads.value;
    final isDokter = _isDokter.value;
    masterPaketSaveSink.add(ApiResponse.loading('Memuat...'));
    MasterPaketModel masterPaketModel = MasterPaketModel(
      jenisHarga: jenisHarga,
      namaPaket: namaPaket,
      diskon: diskon,
      harga: harga,
      total: total,
      tindakans: tindakans,
      jumlahTindakan: jumlahTindakan,
      drugs: drugs,
      jumlahDrugs: jumlahDrugs,
      aturanDrugs: aturanDrugs,
      catatanDrugs: catatanDrugs,
      consumes: consumes,
      jumlahConsumes: jumlahConsumes,
      farmasis: farmasis,
      jumlahFarmasi: jumlahFarmasi,
      aturanFarmasi: aturanFarmasi,
      catatanFarmasi: catatanFarmasi,
      labs: labs,
      rads: rads,
      isDokter: isDokter,
    );

    try {
      final res = await _repo.updateMasterPaket(masterPaketModel, idPaket);
      if (_streamMasterPaketSave!.isClosed) return;
      masterPaketSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterPaketSave!.isClosed) return;
      masterPaketSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> deleteMasterPaket() async {
    _streamMasterPaketSave = StreamController();
    final idPaket = _idPaket.value;
    masterPaketSaveSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deleteMasterPaket(idPaket);
      if (_streamMasterPaketSave!.isClosed) return;
      masterPaketSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterPaketSave!.isClosed) return;
      masterPaketSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamMasterPaketSave?.close();
    _namaPaket.close();
    _harga.close();
    _tindakans.close();
    _jumlahTindakan.close();
    _drugs.close();
    _jumlahDrugs.close();
    _consumes.close();
    _jumlahConsumes.close();
    _farmasis.close();
    _jumlahFarmasis.close();
    _labs.close();
    _rads.close();
    _idPaket.close();
    _isDokter.close();
  }
}
