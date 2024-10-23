import 'dart:async';

import 'package:dokter_panggil/src/models/tagihan_tindakan_lab_model.dart';
import 'package:dokter_panggil/src/repositories/delete_tagihan_tindakan_lab_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class DeleteTagihanTindakanLabBloc {
  final _repo = DeleteTagihanTindakanLabRepo();
  StreamController<ApiResponse<ResponseTagihanTindakanLabModel>>?
      _streamDeleteTagihanTindakanLab;

  final BehaviorSubject<int> _id = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<ApiResponse<ResponseTagihanTindakanLabModel>>
      get deleteTagihanTindakanLabSink => _streamDeleteTagihanTindakanLab!.sink;
  Stream<ApiResponse<ResponseTagihanTindakanLabModel>>
      get deleteTagihanTindakanLabStream =>
          _streamDeleteTagihanTindakanLab!.stream;

  Future<void> deleteTagihanTindakanLab() async {
    _streamDeleteTagihanTindakanLab = StreamController();
    final id = _id.value;
    deleteTagihanTindakanLabSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deleteTagihanTindakanLab(id);
      if (_streamDeleteTagihanTindakanLab!.isClosed) return;
      deleteTagihanTindakanLabSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamDeleteTagihanTindakanLab!.isClosed) return;
      deleteTagihanTindakanLabSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamDeleteTagihanTindakanLab?.close();
    _id.close();
  }
}
