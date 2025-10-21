import 'dart:async';

import 'package:admin_dokter_panggil/src/models/file_eresep_injeksi_model.dart';
import 'package:admin_dokter_panggil/src/repositories/file_eresep_injeksi_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class FileEresepInjeksiBloc {
  final _repo = FileEresepInjeksiRepo();
  StreamController<ApiResponse<FileEresepInjeksiModel>>?
      _streamFileEresepInjeksi;
  final BehaviorSubject<int> _idResep = BehaviorSubject();
  StreamSink<int> get idResepSink => _idResep.sink;
  StreamSink<ApiResponse<FileEresepInjeksiModel>> get fileEresepInjeksiSink =>
      _streamFileEresepInjeksi!.sink;
  Stream<ApiResponse<FileEresepInjeksiModel>> get fileEresepInjeksiStream =>
      _streamFileEresepInjeksi!.stream;

  Future<void> eresepInjeksi() async {
    _streamFileEresepInjeksi = StreamController();
    final idResep = _idResep.value;
    fileEresepInjeksiSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.eresepInjeksi(idResep);
      if (_streamFileEresepInjeksi!.isClosed) return;
      fileEresepInjeksiSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamFileEresepInjeksi!.isClosed) return;
      fileEresepInjeksiSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamFileEresepInjeksi?.close();
    _idResep.close();
  }
}
