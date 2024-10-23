import 'dart:async';

import 'package:dokter_panggil/src/models/master_tindakan_rad_cari_modal.dart';
import 'package:dokter_panggil/src/repositories/master_tindakan_rad_cari_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterTindakanRadCariBloc {
  final _repo = MasterTindakanRadCariRepo();
  StreamController<ApiResponse<ResponseMasterTindakanRadCariModel>>?
      _streamMasterTindakanRadCari;
  final BehaviorSubject<String> _filter = BehaviorSubject.seeded('');
  StreamSink<String> get filterSink => _filter.sink;
  StreamSink<ApiResponse<ResponseMasterTindakanRadCariModel>>
      get masterTindakanRadCariSink => _streamMasterTindakanRadCari!.sink;
  Stream<ApiResponse<ResponseMasterTindakanRadCariModel>>
      get masterTindakanRadCariStream => _streamMasterTindakanRadCari!.stream;

  Future<void> cariTindakanRad() async {
    _streamMasterTindakanRadCari = StreamController();
    final filter = _filter.value;
    masterTindakanRadCariSink.add(ApiResponse.loading('Memuat...'));
    MasterTindakanRadCariModel masterTindakanRadCariModel =
        MasterTindakanRadCariModel(filter: filter);
    try {
      final res = await _repo.cariTindakanRad(masterTindakanRadCariModel);
      if (_streamMasterTindakanRadCari!.isClosed) return;
      masterTindakanRadCariSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterTindakanRadCari!.isClosed) return;
      masterTindakanRadCariSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamMasterTindakanRadCari?.close();
    _filter.close();
  }
}
