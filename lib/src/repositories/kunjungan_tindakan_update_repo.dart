import 'package:dokter_panggil/src/models/kunjungan_tindakan_update_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class KunjunganTindakanUpdateRepo {
  Future<ResponseKunjunganTindakanUpdateModel> updateKunjunganTindakan(
      KunjunganTindakanUpdateModel kunjunganTindakanUpdateModel, int id) async {
    final response = await dio.put('/v1/kunjungan/kunjungan-tindakan/$id',
        kunjunganTindakanUpdateModelToJson(kunjunganTindakanUpdateModel));
    return responseKunjunganTindakanUpdateModelFromJson(response);
  }
}
