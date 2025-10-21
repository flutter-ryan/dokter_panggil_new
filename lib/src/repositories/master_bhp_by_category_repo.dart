import 'package:admin_dokter_panggil/src/models/master_bhp_by_category_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MasterBhpByCategoryRepo {
  Future<MasterBhpByCategoryModel> getBhpByCategory(int categoryId) async {
    final response = await dio.get('/v1/master/bhp/kategori/$categoryId');
    return masterBhpByCategoryModelFromJson(response);
  }
}
