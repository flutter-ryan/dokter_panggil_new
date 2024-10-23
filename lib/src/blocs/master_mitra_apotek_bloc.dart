import 'dart:async';

import 'package:dokter_panggil/src/models/master_mitra_apotek_model.dart';
import 'package:dokter_panggil/src/repositories/master_mitra_apotek_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';

class MasterMitraApotekBloc {
  final _repo = MasterMitraApotekRepo();
  StreamController<ApiResponse<MasterMitraApotekModel>>?
      _streamMasterMitraApotek;
  StreamSink<ApiResponse<MasterMitraApotekModel>> get masterMitraApotekSink =>
      _streamMasterMitraApotek!.sink;
  Stream<ApiResponse<MasterMitraApotekModel>> get masterMitraApotekStream =>
      _streamMasterMitraApotek!.stream;
  Future<void> getMitraApotek() async {
    _streamMasterMitraApotek = StreamController();
    masterMitraApotekSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getMitraApotek();
      if (_streamMasterMitraApotek!.isClosed) return;
      masterMitraApotekSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamMasterMitraApotek!.isClosed) return;
      masterMitraApotekSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamMasterMitraApotek?.close();
  }
}
