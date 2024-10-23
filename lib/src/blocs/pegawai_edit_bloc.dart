import 'dart:async';

import 'package:dokter_panggil/src/models/pegawai_edit_model.dart';
import 'package:dokter_panggil/src/repositories/pegawai_edit_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class PegawaiEditBloc {
  final PegawaiEditRepo _repo = PegawaiEditRepo();
  StreamController<ApiResponse<PegawaiEditModel>>? _streamPegawaiEdit;
  final BehaviorSubject<int> _id = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<ApiResponse<PegawaiEditModel>> get pegawaiEditSink =>
      _streamPegawaiEdit!.sink;
  Stream<ApiResponse<PegawaiEditModel>> get pegawaiEditStream =>
      _streamPegawaiEdit!.stream;

  Future<void> editPegawai() async {
    _streamPegawaiEdit = StreamController();
    final id = _id.value;
    pegawaiEditSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.editPegawai(id);
      if (_streamPegawaiEdit!.isClosed) return;
      pegawaiEditSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPegawaiEdit!.isClosed) return;
      pegawaiEditSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamPegawaiEdit?.close();
    _id.close();
  }
}
