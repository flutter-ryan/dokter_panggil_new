import 'dart:async';

import 'package:admin_dokter_panggil/src/models/delete_tagihan_resep_model.dart';
import 'package:admin_dokter_panggil/src/repositories/delete_tagihan_bhp_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class DeleteTagihanBhpBloc {
  final _repo = DeleteTagihanBhpRepo();
  StreamController<ApiResponse<DeleteTagihanResepModel>>?
      _streamDeleteTagihanBhp;

  final BehaviorSubject<int> _id = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<ApiResponse<DeleteTagihanResepModel>> get deleteTagihanBhpSink =>
      _streamDeleteTagihanBhp!.sink;
  Stream<ApiResponse<DeleteTagihanResepModel>> get deleteTagihanBhpStream =>
      _streamDeleteTagihanBhp!.stream;

  Future<void> deleteTagihanBhp() async {
    _streamDeleteTagihanBhp = StreamController();
    final id = _id.value;
    deleteTagihanBhpSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deleteTagihanBhp(id);
      if (_streamDeleteTagihanBhp!.isClosed) return;
      deleteTagihanBhpSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamDeleteTagihanBhp!.isClosed) return;
      deleteTagihanBhpSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamDeleteTagihanBhp?.close();
    _id.close();
  }
}
