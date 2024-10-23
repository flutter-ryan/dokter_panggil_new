import 'dart:async';

import 'package:dokter_panggil/src/models/tagihan_tindakan_rad_model.dart';
import 'package:dokter_panggil/src/repositories/delete_tagihan_tindakan_rad_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class DeleteTagihanTindakanRadBloc {
  final _repo = DeleteTagihanTindakanRadRepo();
  StreamController<ApiResponse<ResponseTagihanTindakanRadModel>>?
      _streamDeleteTagihanRad;

  final BehaviorSubject<int> _idTagihanRad = BehaviorSubject();
  StreamSink<int> get idTagihanRadSink => _idTagihanRad.sink;
  StreamSink<ApiResponse<ResponseTagihanTindakanRadModel>>
      get tagihanTindakanRadSink => _streamDeleteTagihanRad!.sink;
  Stream<ApiResponse<ResponseTagihanTindakanRadModel>>
      get tagihanTindakanRadStream => _streamDeleteTagihanRad!.stream;

  Future<void> deleteTagihanRad() async {
    _streamDeleteTagihanRad = StreamController();
    final idTagihanRad = _idTagihanRad.value;
    tagihanTindakanRadSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deleteTagihanRad(idTagihanRad);
      if (_streamDeleteTagihanRad!.isClosed) return;
      tagihanTindakanRadSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamDeleteTagihanRad!.isClosed) return;
      tagihanTindakanRadSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamDeleteTagihanRad?.close();
    _idTagihanRad.close();
  }
}
