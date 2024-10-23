import 'dart:async';

import 'package:dokter_panggil/src/models/stok_opname_barang_model.dart';
import 'package:dokter_panggil/src/models/stok_opname_barang_save_model.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/repositories/stok_opname_barang_save_repo.dart';
import 'package:rxdart/rxdart.dart';

class StokOpnameBarangSaveBloc {
  final _repo = StokOpnameBarangSaveRepo();
  StreamController<ApiResponse<StokOpnameBarangSaveModel>>?
      _streamStokOpnameBarangSave;
  StreamController<ApiResponse<StokOpnameBarangModel>>? _streamStokOpnameBarang;
  final BehaviorSubject<int> _idStokOpname = BehaviorSubject();
  final BehaviorSubject<int> _idStokBarang = BehaviorSubject();
  final BehaviorSubject<String> _stok = BehaviorSubject();
  final BehaviorSubject<String> _filter = BehaviorSubject.seeded('');
  StreamSink<int> get idStokOpnameSink => _idStokOpname.sink;
  StreamSink<String> get filterSink => _filter.sink;
  StreamSink<int> get idStokBarangSink => _idStokBarang.sink;
  StreamSink<String> get stokSink => _stok.sink;
  StreamSink<ApiResponse<StokOpnameBarangModel>> get stokOpnameBarangSink =>
      _streamStokOpnameBarang!.sink;
  StreamSink<ApiResponse<StokOpnameBarangSaveModel>>
      get stokOpnameBarangSaveSink => _streamStokOpnameBarangSave!.sink;
  Stream<ApiResponse<StokOpnameBarangSaveModel>>
      get stokOpnameBarangSaveStream => _streamStokOpnameBarangSave!.stream;
  Stream<ApiResponse<StokOpnameBarangModel>> get stokOpnameBarangStream =>
      _streamStokOpnameBarang!.stream;

  Future<void> saveStokOpnameBarang() async {
    _streamStokOpnameBarangSave = StreamController();
    final idStokBarang = _idStokBarang.value;
    final stok = _stok.value;
    stokOpnameBarangSaveSink.add(ApiResponse.loading('Memuat...'));
    KirimStokOpnameBarangSaveModel kirimStokOpnameBarangSaveModel =
        KirimStokOpnameBarangSaveModel(stok: int.parse(stok));
    try {
      final res = await _repo.updateStokOpname(
          kirimStokOpnameBarangSaveModel, idStokBarang);
      if (_streamStokOpnameBarangSave!.isClosed) return;
      stokOpnameBarangSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamStokOpnameBarangSave!.isClosed) return;
      stokOpnameBarangSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getStokOpnameBarang() async {
    _streamStokOpnameBarang = StreamController();
    final idStokOpname = _idStokOpname.value;
    final filter = _filter.value;
    stokOpnameBarangSink.add(ApiResponse.loading('Memuat...'));
    StokOpnameBarangFilterModel stokOpnameBarangFilterModel =
        StokOpnameBarangFilterModel(
      filter: filter,
    );
    try {
      final res = await _repo.getStokOpnameBarang(
          idStokOpname, stokOpnameBarangFilterModel);
      if (_streamStokOpnameBarang!.isClosed) return;
      stokOpnameBarangSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamStokOpnameBarang!.isClosed) return;
      stokOpnameBarangSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamStokOpnameBarangSave?.close();
    _streamStokOpnameBarang?.close();
    _idStokBarang.close();
    _stok.close();
    _idStokOpname.close();
  }
}
