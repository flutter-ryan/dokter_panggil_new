import 'dart:async';

import 'package:admin_dokter_panggil/src/models/delete_tagihan_resep_model.dart';
import 'package:admin_dokter_panggil/src/repositories/delete_tagihan_resep_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class DeleteTagihanResepBloc {
  final _repo = DeleteTagihanResepRepo();
  StreamController<ApiResponse<DeleteTagihanResepModel>>?
      _streamDeleteTagihanResep;
  final BehaviorSubject<int> _id = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<ApiResponse<DeleteTagihanResepModel>> get deleteTagihanResepSink =>
      _streamDeleteTagihanResep!.sink;
  Stream<ApiResponse<DeleteTagihanResepModel>> get deleteTagihanResepStream =>
      _streamDeleteTagihanResep!.stream;
  Future<void> deleteTagihan() async {
    _streamDeleteTagihanResep = StreamController();
    final id = _id.value;
    deleteTagihanResepSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deleteTagihanResep(id);
      if (_streamDeleteTagihanResep!.isClosed) return;
      deleteTagihanResepSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamDeleteTagihanResep!.isClosed) return;
      deleteTagihanResepSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamDeleteTagihanResep?.close();
    _id.close();
  }
}
