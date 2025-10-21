import 'package:admin_dokter_panggil/src/models/update_kunjungan_resep_tagihan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class UpdateKunjunganBhpTagihanRepo {
  Future<ResponseUpdateKunjunganResepTagihanModel> updateTagihanBhp(int? id,
      UpdateKunjunganResepTagihanModel updateKunjunganResepTagihanModel) async {
    final response = await dio.put(
        '/v1/kunjungan/tagihan-bhp/$id',
        updateKunjunganResepTagihanModelToJson(
            updateKunjunganResepTagihanModel));
    return responseUpdateKunjunganResepTagihanModelFromJson(response);
  }
}
