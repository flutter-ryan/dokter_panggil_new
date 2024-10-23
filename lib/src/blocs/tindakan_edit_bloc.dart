import 'dart:async';

import 'package:dokter_panggil/src/models/tindakan_edit_model.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/repositories/tindakan_edit_repo.dart';
import 'package:rxdart/subjects.dart';

class TindakanEditBloc {
  final TindakanEditRepo _repo = TindakanEditRepo();
  StreamController<ApiResponse<TindakanEditModel>>? _streamTindakanEdit;
  final BehaviorSubject<int> _id = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<ApiResponse<TindakanEditModel>> get tindakanEditSink =>
      _streamTindakanEdit!.sink;
  Stream<ApiResponse<TindakanEditModel>> get tindakanEditStream =>
      _streamTindakanEdit!.stream;

  Future<void> editTindakan() async {
    _streamTindakanEdit = StreamController();
    final id = _id.value;
    tindakanEditSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.editTindakan(id);
      if (_streamTindakanEdit!.isClosed) return;
      tindakanEditSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTindakanEdit!.isClosed) return;
      tindakanEditSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> deleteTindakan() async {
    _streamTindakanEdit = StreamController();
    final id = _id.value;
    tindakanEditSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deleteTindakan(id);
      if (_streamTindakanEdit!.isClosed) return;
      tindakanEditSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTindakanEdit!.isClosed) return;
      tindakanEditSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamTindakanEdit?.close();
    _id.close();
  }
}
