import 'package:admin_dokter_panggil/src/models/cetak_stok_opname_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class CetakStokOpnameRepo {
  Future<CetakStokOpnameModel> cetakStokOpname(int? idStokOpname,
      CetakStokOpnameRequestModel cetakStokOpnameRequestModel) async {
    final response = await dio.post('/v1/stok-opname/cetak/$idStokOpname',
        cetakStokOpnameRequestModelToJson(cetakStokOpnameRequestModel));
    return cetakStokOpnameModelFromJson(response);
  }
}
