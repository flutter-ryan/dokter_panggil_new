import 'package:admin_dokter_panggil/src/models/update_harga_farmasi_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class UpdateHargaFarmasiRepo {
  Future<ResponseUpdateHargaFarmasiModel> updateHargaFarmasi(
      UpdateHargaFarmasiModel updateHargaFarmasiModel, int id) async {
    final response = await dio.put(
        '/v1/kunjungan/kunjungan-farmasi/update-harga-barang/$id',
        updateHargaFarmasiModelToJson(updateHargaFarmasiModel));
    return responseUpdateHargaFarmasiModelFromJson(response);
  }
}
