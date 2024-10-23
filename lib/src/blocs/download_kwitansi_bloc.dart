import 'dart:async';

import 'package:dokter_panggil/src/models/download_kwitansi_model.dart';
import 'package:dokter_panggil/src/repositories/download_kwitansi_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class DownloadKwitansiBloc {
  final DownloadKwitansiRepo _repo = DownloadKwitansiRepo();
  StreamController<ApiResponse<DownloadKwitansiModel>>? _streamDownloadKwitasi;
  final BehaviorSubject<int> _id = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<ApiResponse<DownloadKwitansiModel>> get downloadKwitansiSink =>
      _streamDownloadKwitasi!.sink;
  Stream<ApiResponse<DownloadKwitansiModel>> get downloadKwitansiStream =>
      _streamDownloadKwitasi!.stream;

  Future<void> downloadKwitansi() async {
    _streamDownloadKwitasi = StreamController();
    final id = _id.value;
    downloadKwitansiSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.downloadKwitansi(id);
      if (_streamDownloadKwitasi!.isClosed) return;
      downloadKwitansiSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamDownloadKwitasi!.isClosed) return;
      downloadKwitansiSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamDownloadKwitasi?.close();
    _id.close();
  }
}
