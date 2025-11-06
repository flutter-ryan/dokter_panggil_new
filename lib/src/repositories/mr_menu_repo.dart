import 'package:admin_dokter_panggil/src/models/mr_menu_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrMenuRepo {
  Future<MrMenuModel> getMrMenu(int idKunjungan) async {
    final response = await dio
        .get('/v2/mr/admin-riwayat-kunjungan/mr-menu-riwayat/$idKunjungan');
    return mrMenuModelFromJson(response);
  }
}
