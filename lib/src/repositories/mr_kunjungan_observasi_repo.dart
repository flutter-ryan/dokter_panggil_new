import 'package:admin_dokter_panggil/src/models/mr_kunjungan_observasi_anak_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_kunjungan_observasi_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrKunjunganObservasiRepo {
  Future<MrKunjunganObservasiModel> getObservasi(int idKunjungan) async {
    final response =
        await dio.get('/v2/mr/observasi-komprehensif/$idKunjungan');
    return mrKunjunganObservasiModelFromJson(response);
  }

  Future<MrKunjunganObservasiAnakModel> getObservasiAnak(
      int idKunjungan) async {
    final response =
        await dio.get('/v2/mr/observasi-komprehensif/$idKunjungan');
    return mrKunjunganObservasiAnakModelFromJson(response);
  }
}
