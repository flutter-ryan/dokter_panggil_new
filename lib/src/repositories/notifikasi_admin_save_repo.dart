import 'package:admin_dokter_panggil/src/models/notifikasi_admin_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class NotifikasiAdminSaveRepo {
  Future<NotifikasiAdminSaveModel> updateNotifikasi(
      NotifikasiAdminSaveRequestModel notifikasiAdminSaveRequestModel,
      int idNotifikasi) async {
    final response = await dio.put('/v2/mr/notifikasi/read/$idNotifikasi',
        notifikasiAdminSaveRequestModelToJson(notifikasiAdminSaveRequestModel));
    return notifikasiAdminSaveModelFromJson(response);
  }
}
