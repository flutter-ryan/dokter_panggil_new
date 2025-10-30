import 'package:admin_dokter_panggil/src/models/mr_pengkajian_telemedicine_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrPengkajianTelemedicineRepo {
  Future<MrKunjunganTelemedicineModel> getPengkajianTelemedicine(
      int idKunjungan) async {
    final response =
        await dio.get('/v2/mr/pengkajian-telemedicine/$idKunjungan');
    return mrKunjunganTelemedicineModelFromJson(response);
  }
}
