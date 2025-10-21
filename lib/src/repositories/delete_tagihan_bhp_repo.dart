import 'package:admin_dokter_panggil/src/models/delete_tagihan_resep_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class DeleteTagihanBhpRepo {
  Future<DeleteTagihanResepModel> deleteTagihanBhp(int id) async {
    final response = await dio.delete('/v1/kunjungan/tagihan-bhp/$id');
    return deleteTagihanResepModelFromJson(response);
  }
}
