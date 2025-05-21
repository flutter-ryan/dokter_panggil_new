import 'package:dokter_panggil/src/models/pegawai_dokter_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class PegawaiProfesiRepo {
  Future<PegawaiProfesiModel> profesiPegawai(int? groupId) async {
    final response = await dio.get('/v1/master/pegawai/profesi/$groupId');
    return pegawaiProfesiModelFromJson(response);
  }

  Future<PegawaiProfesiModel> filterProfesiPegawai(
      PegawaiProfesiRequestModel pegawaiProfesiRequestModel,
      int? groupId) async {
    final response = await dio.post(
        '/v1/master/pegawai/profesi/filter/$groupId',
        pegawaiProfesiRequestModelToJson(pegawaiProfesiRequestModel));
    return pegawaiProfesiModelFromJson(response);
  }
}
