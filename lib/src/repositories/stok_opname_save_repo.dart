import 'package:dokter_panggil/src/models/stok_opname_save_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class StokOpnameSaveRepo {
  Future<StokOpnameSaveModel> saveStokOpname(
      KirimStokOpname kirimStokOpname) async {
    final response = await dio.post(
        '/v1/stok-opname', kirimStokOpnameToJson(kirimStokOpname));
    return stokOpnameSaveModelFromJson(response);
  }

  Future<StokOpnameSaveModel> deleteStokOpname(int? idStok) async {
    final response = await dio.delete('/v1/stok-opname/$idStok');
    return stokOpnameSaveModelFromJson(response);
  }
}
