import 'package:dokter_panggil/src/models/tagihan_resep_oral_update_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class TagihanResepOralUpdateRepo {
  Future<TagihanResepOralUpdateModel> updateTagihanResepOral(
      TagihanResepOralRequestUpdateModel tagihanResepOralRequestUpdateModel,
      int idBarangResepOral) async {
    final response = await dio.put(
        '/v2/mr/resep-oral/tagihan/$idBarangResepOral',
        tagihanResepOralRequestUpdateModelToJson(
            tagihanResepOralRequestUpdateModel));
    return tagihanResepOralUpdateModelFromJson(response);
  }

  Future<TagihanResepOralUpdateModel> deleteTagihanResepOral(
      int idBarangResepOral) async {
    final response =
        await dio.delete('/v2/mr/resep-oral/tagihan/$idBarangResepOral');
    return tagihanResepOralUpdateModelFromJson(response);
  }
}
