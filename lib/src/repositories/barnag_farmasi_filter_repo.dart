import 'package:dokter_panggil/src/models/barang_farmasi_filter_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class BarangFarmasiFilterRepo {
  Future<ResponseBarangFarmasiFilterModel> filterBarangFarmasi(
      BarangFarmasiFilterModel barangFarmasiFilterModel) async {
    final response = await dio.post('/v1/master/farmasi/filter',
        barangFarmasiFilterModelToJson(barangFarmasiFilterModel));
    return responseBarangFarmasiFilterModelFromJson(response);
  }
}
