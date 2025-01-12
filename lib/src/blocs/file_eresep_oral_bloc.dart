import 'dart:async';

import 'package:dokter_panggil/src/models/file_eresep_oral_model.dart';
import 'package:dokter_panggil/src/repositories/file_eresep_oral_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class FileEresepOralBloc {
  final _repo = FileEresepOralRepo();
  StreamController<ApiResponse<FileEresepOralModel>>? _streamFileEresepOral;
  final BehaviorSubject<int> _idResep = BehaviorSubject();
  StreamSink<int> get idResepSink => _idResep.sink;
  StreamSink<ApiResponse<FileEresepOralModel>> get fileEresepOralSink =>
      _streamFileEresepOral!.sink;
  Stream<ApiResponse<FileEresepOralModel>> get fileEresepOralStream =>
      _streamFileEresepOral!.stream;

  Future<void> eresepOral() async {
    _streamFileEresepOral = StreamController();
    final idResep = _idResep.value;
    fileEresepOralSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.eresepOral(idResep);
      if (_streamFileEresepOral!.isClosed) return;
      fileEresepOralSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamFileEresepOral!.isClosed) return;
      fileEresepOralSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamFileEresepOral?.close();
    _idResep.close();
  }
}
