import 'dart:async';

import 'package:dokter_panggil/src/models/file_eresep_racikan_model.dart';
import 'package:dokter_panggil/src/repositories/file_eresep_racikan_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class FileEresepRacikanBloc {
  final _repo = FileEresepRacikanRepo();
  StreamController<ApiResponse<FileEresepRacikanModel>>?
      _streamFileEresepRacikan;
  final BehaviorSubject<int> _idResep = BehaviorSubject();
  StreamSink<int> get idResepSink => _idResep.sink;
  StreamSink<ApiResponse<FileEresepRacikanModel>> get fileEresepRacikanSink =>
      _streamFileEresepRacikan!.sink;
  Stream<ApiResponse<FileEresepRacikanModel>> get fileEresepRacikanStream =>
      _streamFileEresepRacikan!.stream;

  Future<void> eresepRacikan() async {
    _streamFileEresepRacikan = StreamController();
    final idResep = _idResep.value;
    fileEresepRacikanSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.kirimEresp(idResep);
      if (_streamFileEresepRacikan!.isClosed) return;
      fileEresepRacikanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamFileEresepRacikan!.isClosed) return;
      fileEresepRacikanSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamFileEresepRacikan?.close();
    _idResep.close();
  }
}
