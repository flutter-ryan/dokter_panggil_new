import 'package:admin_dokter_panggil/src/models/update_kunjungan_resep_tagihan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class UpdateKunjunganResepTagihanRepo {
  Future<ResponseUpdateKunjunganResepTagihanModel> updateTagihanResep(
      int? idTagihanResep,
      UpdateKunjunganResepTagihanModel updateKunjunganResepTagihanModel) async {
    final response = await dio.put(
        '/v2/mr/resep-oral/tagihan/$idTagihanResep',
        updateKunjunganResepTagihanModelToJson(
            updateKunjunganResepTagihanModel));
    return responseUpdateKunjunganResepTagihanModelFromJson(response);
  }
}
