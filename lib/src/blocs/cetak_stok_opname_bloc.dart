import 'dart:async';

import 'package:dokter_panggil/src/models/cetak_stok_opname_model.dart';
import 'package:dokter_panggil/src/repositories/cetak_stok_opname_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class CetakStokOpnameBloc {
  final _repo = CetakStokOpnameRepo();
  StreamController<ApiResponse<CetakStokOpnameModel>>? _streamCetakStokOpname;
  final BehaviorSubject<int> _idStokOpname = BehaviorSubject();
  final BehaviorSubject<String> _from = BehaviorSubject();
  final BehaviorSubject<String> _to = BehaviorSubject();
  StreamSink<int> get idStokOpnameSink => _idStokOpname.sink;
  StreamSink<String> get fromSink => _from.sink;
  StreamSink<String> get toSink => _to.sink;
  StreamSink<ApiResponse<CetakStokOpnameModel>> get cetakStokOpnameSink =>
      _streamCetakStokOpname!.sink;
  Stream<ApiResponse<CetakStokOpnameModel>> get cetakStokOpnameStream =>
      _streamCetakStokOpname!.stream;

  Future<void> cetakStokOpname() async {
    _streamCetakStokOpname = StreamController();
    final idStokOpname = _idStokOpname.value;
    final from = _from.value;
    final to = _to.value;
    cetakStokOpnameSink.add(ApiResponse.loading('Memuat...'));
    CetakStokOpnameRequestModel cetakStokOpnameRequestModel =
        CetakStokOpnameRequestModel(from: from, to: to);
    try {
      final res = await _repo.cetakStokOpname(
          idStokOpname, cetakStokOpnameRequestModel);
      if (_streamCetakStokOpname!.isClosed) return;
      cetakStokOpnameSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamCetakStokOpname!.isClosed) return;
      cetakStokOpnameSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamCetakStokOpname?.close();
    _idStokOpname.close();
    _from.close();
    _to.close();
  }
}
