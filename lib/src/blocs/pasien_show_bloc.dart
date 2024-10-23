import 'dart:async';

import 'package:dokter_panggil/src/models/pasien_show_model.dart';
import 'package:dokter_panggil/src/repositories/pasien_show_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class PasienShowBloc {
  final PasienShowRepo _repo = PasienShowRepo();
  StreamController<ApiResponse<PasienShowModel>>? _streamPasienShow;
  final BehaviorSubject<int> _idCon = BehaviorSubject();
  StreamSink<int> get idSink => _idCon.sink;
  StreamSink<ApiResponse<PasienShowModel>> get pasienShowSink =>
      _streamPasienShow!.sink;
  Stream<ApiResponse<PasienShowModel>> get pasienShowStream =>
      _streamPasienShow!.stream;
  Future<void> pasienShow() async {
    _streamPasienShow = StreamController();
    final id = _idCon.value;
    pasienShowSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.pasienShow(id);
      if (_streamPasienShow!.isClosed) return;
      pasienShowSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPasienShow!.isClosed) return;
      pasienShowSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamPasienShow?.isClosed;
    _idCon.close();
  }
}
