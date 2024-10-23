import 'package:dokter_panggil/src/models/update_kunjungan_resep_tagihan_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class UpdateKunjunganResepTagihanRepo {
  Future<ResponseUpdateKunjunganResepTagihanModel> updateTagihanResep(int? id,
      UpdateKunjunganResepTagihanModel updateKunjunganResepTagihanModel) async {
    final response = await dio.put(
        '/v1/kunjungan/tagihan-resep/$id',
        updateKunjunganResepTagihanModelToJson(
            updateKunjunganResepTagihanModel));
    return responseUpdateKunjunganResepTagihanModelFromJson(response);
  }
}
