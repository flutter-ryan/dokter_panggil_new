import 'package:dokter_panggil/src/models/stok_opname_barang_model.dart';
import 'package:dokter_panggil/src/models/stok_opname_barang_save_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class StokOpnameBarangSaveRepo {
  Future<StokOpnameBarangSaveModel> updateStokOpname(
      KirimStokOpnameBarangSaveModel kirimStokOpnameBarangSaveModel,
      int? idBarangStok) async {
    final response = await dio.put('/v1/stok-opname/barang/$idBarangStok',
        kirimStokOpnameBarangSaveModelToJson(kirimStokOpnameBarangSaveModel));
    return stokOpnameBarangSaveModelFromJson(response);
  }

  Future<StokOpnameBarangModel> getStokOpnameBarang(int idStokOpname,
      StokOpnameBarangFilterModel stokOpnameBarangFilterModel) async {
    final response = await dio.post('/v1/stok-opname/$idStokOpname/barang',
        stokOpnameBarangFilterModelToJson(stokOpnameBarangFilterModel));
    return stokOpnameBarangModelFromJson(response);
  }
}
