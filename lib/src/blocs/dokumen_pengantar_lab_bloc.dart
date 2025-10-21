import 'dart:async';

import 'package:admin_dokter_panggil/src/models/dokumen_pengantar_lab_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dokumen_pengantar_lab_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class DokumenPengantarLabBloc {
  final _repo = DokumenPengantarLabRepo();
  StreamController<ApiResponse<ResponseDokumenPengantarLabModel>>?
      _streamDokumenPengantarLab;
  StreamController<ApiResponse<ResponseListTindakanLabPengantarModel>>?
      _streamListTindakanLab;

  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  final BehaviorSubject<String> _idPegawai = BehaviorSubject.seeded('');
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<String> get idPegawaiSink => _idPegawai.sink;
  StreamSink<ApiResponse<ResponseDokumenPengantarLabModel>>
      get dokumenPengantarLabSink => _streamDokumenPengantarLab!.sink;
  StreamSink<ApiResponse<ResponseListTindakanLabPengantarModel>>
      get listTindakanLabSink => _streamListTindakanLab!.sink;
  Stream<ApiResponse<ResponseDokumenPengantarLabModel>>
      get dokumenPengantarLabStream => _streamDokumenPengantarLab!.stream;
  Stream<ApiResponse<ResponseListTindakanLabPengantarModel>>
      get listTindakanLabStream => _streamListTindakanLab!.stream;

  Future<void> getDokumenPengantarLab() async {
    _streamDokumenPengantarLab = StreamController();
    final idKunjungan = _idKunjungan.value;
    final idPegawai = _idPegawai.value;
    dokumenPengantarLabSink.add(ApiResponse.loading('Memuat...'));
    DokumenPengantarLabModel dokumenPengantarLabModel =
        DokumenPengantarLabModel(
            idKunjungan: idKunjungan, idPegawai: idPegawai);
    try {
      final res = await _repo.getDokumenPengantarLab(dokumenPengantarLabModel);
      if (_streamDokumenPengantarLab!.isClosed) return;
      dokumenPengantarLabSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamDokumenPengantarLab!.isClosed) return;
      dokumenPengantarLabSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getListTindakanLab() async {
    _streamListTindakanLab = StreamController();
    final idKunjungan = _idKunjungan.value;
    final idPegawai = _idPegawai.value;
    listTindakanLabSink.add(ApiResponse.loading('Memuat...'));
    DokumenPengantarLabModel dokumenPengantarLabModel =
        DokumenPengantarLabModel(
            idKunjungan: idKunjungan, idPegawai: idPegawai);
    try {
      final res =
          await _repo.getListTindakanLabPengantar(dokumenPengantarLabModel);
      if (_streamListTindakanLab!.isClosed) return;
      listTindakanLabSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamListTindakanLab!.isClosed) return;
      listTindakanLabSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamDokumenPengantarLab?.close();
    _idKunjungan.close();
  }
}
