import 'package:dokter_panggil/src/models/barang_farmasi_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class BarangFarmasiSaveRepo {
  Future<ResponseBarangFarmasiModel> saveBarangFarmasi(
      BarangFarmasiModel barangFarmasiModel) async {
    final response = await dio.post(
        '/v1/master/farmasi', barangFarmasiModelToJson(barangFarmasiModel));
    return responseBarangFarmasiModelFromJson(response);
  }
}
