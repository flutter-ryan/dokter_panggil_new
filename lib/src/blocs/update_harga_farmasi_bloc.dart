import 'dart:async';

import 'package:dokter_panggil/src/models/update_harga_farmasi_model.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/repositories/update_harga_farmasi_repo.dart';
import 'package:rxdart/subjects.dart';

class UpdateHargaFarmasiBloc {
  final _repo = UpdateHargaFarmasiRepo();
  StreamController<ApiResponse<ResponseUpdateHargaFarmasiModel>>?
      _streamUpdateHargaFarmasi;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<int> _hargaModal = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<int> get hargaModalSink => _hargaModal.sink;
  StreamSink<ApiResponse<ResponseUpdateHargaFarmasiModel>>
      get updateHargaFarmasiSink => _streamUpdateHargaFarmasi!.sink;
  Stream<ApiResponse<ResponseUpdateHargaFarmasiModel>>
      get updateHargaFarmasiStream => _streamUpdateHargaFarmasi!.stream;

  Future<void> updateHargaFarmasi() async {
    _streamUpdateHargaFarmasi = StreamController();
    final id = _id.value;
    final hargaModal = _hargaModal.value;
    updateHargaFarmasiSink.add(ApiResponse.loading('Memuat...'));
    UpdateHargaFarmasiModel updateHargaFarmasiModel =
        UpdateHargaFarmasiModel(hargaModal: hargaModal);
    try {
      final res = await _repo.updateHargaFarmasi(updateHargaFarmasiModel, id);
      if (_streamUpdateHargaFarmasi!.isClosed) return;
      updateHargaFarmasiSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamUpdateHargaFarmasi!.isClosed) return;
      updateHargaFarmasiSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamUpdateHargaFarmasi?.close();
    _id.close();
    _hargaModal.close();
  }
}
