import 'package:dokter_panggil/src/models/barang_fetch_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class BarangFetchRepo {
  Future<BarangFetchModel> fetchBarang(
      FilterBarangFetchModel filterBarangFetchModel, int page) async {
    final response = await dio.post('/v1/master/bhp/apotek/create?page=$page',
        filterBarangfetchModelToJson(filterBarangFetchModel));
    return barangFetchModelFromJson(response);
  }
}
