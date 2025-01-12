import 'dart:async';

import 'package:dokter_panggil/src/models/mr_eresep_model.dart';
import 'package:dokter_panggil/src/repositories/mr_eresep_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MrEresepBloc {
  final _repo = MrEresepRepo();
  StreamController<ApiResponse<MrEresepModel>>? _streamEresep;
  final BehaviorSubject<int> _idResep = BehaviorSubject();
  StreamSink<int> get idResepSink => _idResep.sink;
  StreamSink<ApiResponse<MrEresepModel>> get eresepSink => _streamEresep!.sink;
  Stream<ApiResponse<MrEresepModel>> get eresepStream => _streamEresep!.stream;

  Future<void> getResepInjeksi() async {
    _streamEresep = StreamController();
    final idResep = _idResep.value;
    eresepSink.add(ApiResponse.loading('Memuat...'));
    MrEresepRequestModel mrEresepRequestModel =
        MrEresepRequestModel(idResep: idResep);
    try {
      final res = await _repo.getEresepInjeksi(mrEresepRequestModel);
      if (_streamEresep!.isClosed) return;
      eresepSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamEresep!.isClosed) return;
      eresepSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getResepOral() async {
    _streamEresep = StreamController();
    final idResep = _idResep.value;
    eresepSink.add(ApiResponse.loading('Memuat...'));
    MrEresepRequestModel mrEresepRequestModel =
        MrEresepRequestModel(idResep: idResep);
    try {
      final res = await _repo.getEresepOral(mrEresepRequestModel);
      if (_streamEresep!.isClosed) return;
      eresepSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamEresep!.isClosed) return;
      eresepSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamEresep?.close();
    _idResep.close();
  }
}
