import 'dart:async';

import 'package:admin_dokter_panggil/src/models/tagihan_tindakan_lab_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/repositories/tagihan_tindakan_lab_save_repo.dart';
import 'package:rxdart/subjects.dart';

class TagihanTindakanLabSaveBloc {
  final _repo = TagihanTindakanLabSaveRepo();
  StreamController<ApiResponse<TagihanTindakanLabSaveModel>>?
      _streamTagihanTindakanLab;
  final BehaviorSubject<int> _idPengantar = BehaviorSubject();
  final BehaviorSubject<List<TindakanLabRequest>> _tidakanLab =
      BehaviorSubject();

  StreamSink<int> get idPengantarSink => _idPengantar.sink;
  StreamSink<List<TindakanLabRequest>> get tindakanLabSink => _tidakanLab.sink;
  StreamSink<ApiResponse<TagihanTindakanLabSaveModel>>
      get tagihanTindakanLabSink => _streamTagihanTindakanLab!.sink;
  Stream<ApiResponse<TagihanTindakanLabSaveModel>>
      get tagihanTindakanLabStream => _streamTagihanTindakanLab!.stream;

  Future<void> saveTagihanTindakanLab() async {
    _streamTagihanTindakanLab = StreamController();
    final idPengantar = _idPengantar.value;
    final tindakanLab = _tidakanLab.value;
    tagihanTindakanLabSink.add(ApiResponse.loading('Memuat...'));
    TagihanTindakanLabRequestModel tagihanTindakanLabRequestModel =
        TagihanTindakanLabRequestModel(tindakanLab: tindakanLab);
    try {
      final res = await _repo.saveTagihanTindakanLab(
          tagihanTindakanLabRequestModel, idPengantar);
      if (_streamTagihanTindakanLab!.isClosed) return;
      tagihanTindakanLabSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTagihanTindakanLab!.isClosed) return;
      tagihanTindakanLabSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamTagihanTindakanLab?.close();
    _idPengantar.close();
    _tidakanLab.close();
  }
}
