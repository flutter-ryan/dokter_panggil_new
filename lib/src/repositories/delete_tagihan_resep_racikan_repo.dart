import 'package:admin_dokter_panggil/src/models/delete_tagihan_resep_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class DeleteTagihanResepRacikanRepo {
  Future<DeleteTagihanResepModel> deleteTagihanResepRacikan(int? id) async {
    final response =
        await dio.delete('/v1/kunjungan/tagihan-resep-racikan/$id');
    return deleteTagihanResepModelFromJson(response);
  }
}
