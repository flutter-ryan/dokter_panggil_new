import 'package:dokter_panggil/src/models/kunjungan_tindakan_lab_save_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class KunjunganTindakanLabSaveRepo {
  Future<ResponseKunjunganTindakanbLabSaveModel> updateKunjunganTindakanLab(
      KunjunganTindakanbLabSaveModel kunjunganTindakanbLabSaveModel,
      int id) async {
    final response = await dio.put(
        '/v1/kunjungan/kunjungan-lab/update-tindakan-lab/$id',
        kunjunganTindakanbLabSaveModelToJson(kunjunganTindakanbLabSaveModel));
    return responseKunjunganTindakanbLabSaveModelFromJson(response);
  }
}
