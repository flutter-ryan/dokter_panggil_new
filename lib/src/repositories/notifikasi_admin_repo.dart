import 'package:dokter_panggil/src/models/notifikasi_admin_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class NotifikasiAdminRepo {
  Future<NotifikasiAdminModel> getNotifikasiAdmin() async {
    final response = await dio.get('/v2/mr/notifikasi/create');
    return notifikasiAdminModelFromJson(response);
  }
}
