import 'dart:async';

import 'package:admin_dokter_panggil/src/models/resume_soap_model.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/repositories/resume_soap_repo.dart';
import 'package:rxdart/subjects.dart';

class ResumeSoapBloc {
  final _repo = ResumeSoapRepo();
  StreamController<ApiResponse<ResponseResumeSoapModel>>? _streamResumeSoap;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  final BehaviorSubject<int> _idPetugas = BehaviorSubject();
  StreamSink<int> get idKunjuganSink => _idKunjungan.sink;
  StreamSink<int> get idPetugasSink => _idPetugas.sink;
  StreamSink<ApiResponse<ResponseResumeSoapModel>> get resumeSoapSink =>
      _streamResumeSoap!.sink;
  Stream<ApiResponse<ResponseResumeSoapModel>> get resumeSoapStream =>
      _streamResumeSoap!.stream;

  Future<void> getResumeSoap() async {
    _streamResumeSoap = StreamController();
    final idKunjungan = _idKunjungan.value;
    final idPetugas = _idPetugas.value;
    resumeSoapSink.add(ApiResponse.loading('Memuat...'));
    ResumeSoapModel resumeSoapModel =
        ResumeSoapModel(idKunjungan: idKunjungan, idPetugas: idPetugas);
    try {
      final res = await _repo.getSoapPasien(resumeSoapModel);
      if (_streamResumeSoap!.isClosed) return;
      resumeSoapSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamResumeSoap!.isClosed) return;
      resumeSoapSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamResumeSoap?.close();
    _idKunjungan.close();
    _idPetugas.close();
  }
}
