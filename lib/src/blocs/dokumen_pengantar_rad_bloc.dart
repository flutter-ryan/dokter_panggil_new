import 'dart:async';

import 'package:dokter_panggil/src/models/dokumen_pengantar_rad_model.dart';
import 'package:dokter_panggil/src/repositories/dokumen_pengantar_rad_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class DokumenPengantarRadBloc {
  final _repo = DokumenPengantarRadRepo();
  StreamController<ApiResponse<ResponseDokumenPengantarRadModel>>?
      _streamDokumenPengantarRad;
  StreamController<ApiResponse<ResponseListTindakanRadPengantarModel>>?
      _streamListTindakanRad;

  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  final BehaviorSubject<String> _idPegawai = BehaviorSubject.seeded('');
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<String> get idPegawaiSink => _idPegawai.sink;
  StreamSink<ApiResponse<ResponseDokumenPengantarRadModel>>
      get dokumenPengantarRadSink => _streamDokumenPengantarRad!.sink;
  StreamSink<ApiResponse<ResponseListTindakanRadPengantarModel>>
      get listTindakanRadSink => _streamListTindakanRad!.sink;
  Stream<ApiResponse<ResponseDokumenPengantarRadModel>>
      get dokumenPengantarRadStream => _streamDokumenPengantarRad!.stream;
  Stream<ApiResponse<ResponseListTindakanRadPengantarModel>>
      get listTindakanRadStream => _streamListTindakanRad!.stream;

  Future<void> getDokumenPengantarRad() async {
    _streamDokumenPengantarRad = StreamController();
    final idKunjungan = _idKunjungan.value;
    final idPegawai = _idPegawai.value;
    dokumenPengantarRadSink.add(ApiResponse.loading('Memuat...'));
    DokumenPengantarRadModel dokumenPengantarRadModel =
        DokumenPengantarRadModel(
            idKunjungan: idKunjungan, idPegawai: idPegawai);
    try {
      final res = await _repo.getDokumenPengantarRad(dokumenPengantarRadModel);
      if (_streamDokumenPengantarRad!.isClosed) return;
      dokumenPengantarRadSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamDokumenPengantarRad!.isClosed) return;
      dokumenPengantarRadSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getListTindakanRad() async {
    _streamListTindakanRad = StreamController();
    final idKunjungan = _idKunjungan.value;
    final idPegawai = _idPegawai.value;
    listTindakanRadSink.add(ApiResponse.loading('Memuat...'));
    DokumenPengantarRadModel dokumenPengantarRadModel =
        DokumenPengantarRadModel(
            idKunjungan: idKunjungan, idPegawai: idPegawai);
    try {
      final res =
          await _repo.getListTindakanRadPengantar(dokumenPengantarRadModel);
      if (_streamListTindakanRad!.isClosed) return;
      listTindakanRadSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamListTindakanRad!.isClosed) return;
      listTindakanRadSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamDokumenPengantarRad?.close();
    _idKunjungan.close();
  }
}
