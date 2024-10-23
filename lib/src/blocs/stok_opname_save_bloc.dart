import 'dart:async';

import 'package:dokter_panggil/src/models/stok_opname_save_model.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/repositories/stok_opname_save_repo.dart';
import 'package:rxdart/rxdart.dart';

class StokOpnameSaveBloc {
  final _repo = StokOpnameSaveRepo();
  StreamController<ApiResponse<StokOpnameSaveModel>>? _streamStokOpnameSave;
  final BehaviorSubject<int> _idStok = BehaviorSubject();
  final BehaviorSubject<String> _from = BehaviorSubject();
  final BehaviorSubject<String> _to = BehaviorSubject();
  StreamSink<int> get idStokSink => _idStok.sink;
  StreamSink<String> get fromSink => _from.sink;
  StreamSink<String> get toSink => _to.sink;
  StreamSink<ApiResponse<StokOpnameSaveModel>> get stokOpnameSaveSink =>
      _streamStokOpnameSave!.sink;
  Stream<ApiResponse<StokOpnameSaveModel>> get stokOpnameSaveStream =>
      _streamStokOpnameSave!.stream;

  Future<void> saveStokOpname() async {
    _streamStokOpnameSave = StreamController();
    final from = _from.value;
    final to = _to.value;
    stokOpnameSaveSink.add(ApiResponse.loading('Memuat...'));
    KirimStokOpname kirimStokOpname = KirimStokOpname(from: from, to: to);
    try {
      final res = await _repo.saveStokOpname(kirimStokOpname);
      if (_streamStokOpnameSave!.isClosed) return;
      stokOpnameSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamStokOpnameSave!.isClosed) return;
      stokOpnameSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> deleteStokOpname() async {
    _streamStokOpnameSave = StreamController();
    final idStok = _idStok.value;
    stokOpnameSaveSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deleteStokOpname(idStok);
      if (_streamStokOpnameSave!.isClosed) return;
      stokOpnameSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamStokOpnameSave!.isClosed) return;
      stokOpnameSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamStokOpnameSave?.close();
    _from.close();
    _to.close();
    _idStok.close();
  }
}
