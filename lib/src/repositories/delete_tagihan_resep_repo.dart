import 'package:dokter_panggil/src/models/delete_tagihan_resep_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class DeleteTagihanResepRepo {
  Future<DeleteTagihanResepModel> deleteTagihanResep(int? id) async {
    final response = await dio.delete('/v1/kunjungan/tagihan-resep/$id');
    return deleteTagihanResepModelFromJson(response);
  }
}
