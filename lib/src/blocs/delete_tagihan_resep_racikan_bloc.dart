import 'dart:async';

import 'package:admin_dokter_panggil/src/models/delete_tagihan_resep_model.dart';
import 'package:admin_dokter_panggil/src/repositories/delete_tagihan_resep_racikan_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class DeleteTagihanResepRacikanBloc {
  final _repo = DeleteTagihanResepRacikanRepo();
  StreamController<ApiResponse<DeleteTagihanResepModel>>?
      _streamDeleteTagihanResepRacikan;
  final BehaviorSubject<int> _id = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<ApiResponse<DeleteTagihanResepModel>>
      get deleteTagihanResepRacikanSink =>
          _streamDeleteTagihanResepRacikan!.sink;
  Stream<ApiResponse<DeleteTagihanResepModel>>
      get deleteTagihanResepRacikanStream =>
          _streamDeleteTagihanResepRacikan!.stream;
  Future<void> deleteTagihanRacikan() async {
    _streamDeleteTagihanResepRacikan = StreamController();
    final id = _id.value;
    deleteTagihanResepRacikanSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deleteTagihanResepRacikan(id);
      if (_streamDeleteTagihanResepRacikan!.isClosed) return;
      deleteTagihanResepRacikanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamDeleteTagihanResepRacikan!.isClosed) return;
      deleteTagihanResepRacikanSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamDeleteTagihanResepRacikan?.close();
    _id.close();
  }
}
