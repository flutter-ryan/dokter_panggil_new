import 'dart:async';

import 'package:dokter_panggil/src/models/tagihan_tindakan_rad_save_model.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/repositories/tagihan_tindakan_rad_save_repo.dart';
import 'package:rxdart/rxdart.dart';

class TagihanTindakanRadSaveBloc {
  final _repo = TagihanTindakanRadSaveRepo();
  StreamController<ApiResponse<TagihanTindakanRadSaveModel>>?
      _streamTagihanTindakanRad;
  final BehaviorSubject<int> _idPengantar = BehaviorSubject();
  final BehaviorSubject<List<TindakanRadRequest>> _tindakanRad =
      BehaviorSubject.seeded([]);
  StreamSink<int> get idPengantarSink => _idPengantar.sink;
  StreamSink<List<TindakanRadRequest>> get tindakanRadSink => _tindakanRad.sink;
  StreamSink<ApiResponse<TagihanTindakanRadSaveModel>>
      get tagihanTindakanRadSink => _streamTagihanTindakanRad!.sink;
  Stream<ApiResponse<TagihanTindakanRadSaveModel>>
      get tagihanTindakanRadStream => _streamTagihanTindakanRad!.stream;

  Future<void> saveTagihanTindakanRad() async {
    _streamTagihanTindakanRad = StreamController();
    final idPengantar = _idPengantar.value;
    final tindakanRad = _tindakanRad.value;
    tagihanTindakanRadSink.add(ApiResponse.loading('Memuat...'));
    TagihanTindakanRadRequestModel tagihanTindakanRadRequestModel =
        TagihanTindakanRadRequestModel(tindakanRad: tindakanRad);
    try {
      final res = await _repo.simpanTindakanRad(
          tagihanTindakanRadRequestModel, idPengantar);
      if (_streamTagihanTindakanRad!.isClosed) return;
      tagihanTindakanRadSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTagihanTindakanRad!.isClosed) return;
      tagihanTindakanRadSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamTagihanTindakanRad?.close();
    _idPengantar.close();
    _tindakanRad.close();
  }
}
