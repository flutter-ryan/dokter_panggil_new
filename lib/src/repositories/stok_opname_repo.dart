import 'package:admin_dokter_panggil/src/models/stok_opname_model.dart';
import 'package:admin_dokter_panggil/src/models/stok_opname_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class StokOpnameRepo {
  Future<StokOpnameModel> getStokOpname() async {
    final response = await dio.get('/v1/stok-opname/create');
    return stokOpnameModelFromJson(response);
  }

  Future<StokOpnameSaveModel> finalStokOpname(int idStokOpname) async {
    final response = await dio.get('/v1/stok-opname/$idStokOpname/final');
    return stokOpnameSaveModelFromJson(response);
  }
}
