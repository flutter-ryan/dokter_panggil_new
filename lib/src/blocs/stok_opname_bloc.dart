import 'dart:async';

import 'package:admin_dokter_panggil/src/models/stok_opname_model.dart';
import 'package:admin_dokter_panggil/src/models/stok_opname_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/repositories/stok_opname_repo.dart';
import 'package:rxdart/rxdart.dart';

class StokOpnameBloc {
  final _repo = StokOpnameRepo();
  StokOpnameModel? data;
  StreamController<ApiResponse<StokOpnameModel>>? _streamStokOpname;
  StreamController<ApiResponse<StokOpnameSaveModel>>? _streamStokOpnameFinal;
  final BehaviorSubject<int> _idStokOpname = BehaviorSubject();
  StreamSink<int> get idStokOpnameSink => _idStokOpname.sink;
  StreamSink<ApiResponse<StokOpnameSaveModel>> get stokOpnameFinalSink =>
      _streamStokOpnameFinal!.sink;
  StreamSink<ApiResponse<StokOpnameModel>> get stokOpnameSink =>
      _streamStokOpname!.sink;
  Stream<ApiResponse<StokOpnameSaveModel>> get stokOpnameFinalStream =>
      _streamStokOpnameFinal!.stream;
  Stream<ApiResponse<StokOpnameModel>> get stokOpnameStream =>
      _streamStokOpname!.stream;

  Future<void> getStokOpname() async {
    _streamStokOpname = StreamController();
    stokOpnameSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getStokOpname();
      if (_streamStokOpname!.isClosed) return;
      data = res;
      stokOpnameSink.add(ApiResponse.completed(data));
    } catch (e) {
      if (_streamStokOpname!.isClosed) return;
      stokOpnameSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> finalStokOpname() async {
    _streamStokOpnameFinal = StreamController();
    final idStokOpname = _idStokOpname.value;
    stokOpnameFinalSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.finalStokOpname(idStokOpname);
      if (_streamStokOpnameFinal!.isClosed) return;
      data!.data![data!.data!
          .indexWhere((opname) => opname.id == res.data!.id)] = res.data!;
      stokOpnameFinalSink.add(ApiResponse.completed(res));
      stokOpnameSink.add(ApiResponse.completed(data));
    } catch (e) {
      if (_streamStokOpnameFinal!.isClosed) return;
      stokOpnameFinalSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamStokOpname?.close();
    _streamStokOpnameFinal?.close();
    _idStokOpname.close();
  }
}
