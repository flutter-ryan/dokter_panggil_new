import 'package:admin_dokter_panggil/src/models/pegawai_update_akun_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class PegawaiUpdateAkunRepo {
  Future<ResponsePegawaiUpdateAkunModel> updateAkun(
      PegawaiUpdateAkunModel pegawaiUpdateAkunModel) async {
    final response = await dio.post(
      '/v1/master/pegawai/current',
      pegawaiUpdateAkunModelToJson(pegawaiUpdateAkunModel),
    );
    return responsePegawaiUpdateAkunModelFromJson(response);
  }
}
