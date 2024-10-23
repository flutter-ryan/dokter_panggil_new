import 'dart:async';

import 'package:dokter_panggil/src/models/tindakan_create_model.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/repositories/tindakan_create_repo.dart';

class TindakanCreateBloc {
  final _repo = TindakanCreateRepo();
  StreamController<ApiResponse<TindakanCreateModel>>? _streamTindakanCreate;
  StreamSink<ApiResponse<TindakanCreateModel>> get tindakanCreateSink =>
      _streamTindakanCreate!.sink;
  Stream<ApiResponse<TindakanCreateModel>> get tindakanCreateStream =>
      _streamTindakanCreate!.stream;
  Future<void> tindakanCreate() async {
    _streamTindakanCreate = StreamController();
    tindakanCreateSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.tindakanCreate();
      if (_streamTindakanCreate!.isClosed) return;
      tindakanCreateSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTindakanCreate!.isClosed) return;
      tindakanCreateSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamTindakanCreate?.close();
  }
}
