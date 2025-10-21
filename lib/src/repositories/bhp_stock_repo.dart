import 'package:admin_dokter_panggil/src/models/bhp_stock_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class BhpStockRepo {
  Future<ResponseBhpStockModel> tambahStock(
      int? idBarang, BhpStockModel bhpStockModel) async {
    final response = await dio.post('/v1/master/bhp/simpan-stock/$idBarang',
        bhpStockModelToJson(bhpStockModel));
    return responseBhpStockModelFromJson(response);
  }
}
