import 'package:admin_dokter_panggil/src/models/mr_pencarian_barang_farmasi_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrPencarianBarangFarmasiRepo {
  Future<MrPencarianBarangFarmasiModel> pencarianBarangFarmasi(
      MrPencarianBarangFarmasiRequestModel mrPencarianBarangFarmasiRequestModel,
      int page) async {
    final response = await dio.post(
        '/v2/mr/master/barang-farmasi?page=$page',
        mrPencarianBarangFarmasiRequestModelToJson(
            mrPencarianBarangFarmasiRequestModel));
    return mrPencarianBarangFarmasiModelFromJson(response);
  }
}
