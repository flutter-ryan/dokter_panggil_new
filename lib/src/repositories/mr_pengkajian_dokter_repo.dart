import 'package:admin_dokter_panggil/src/models/mr_pengkajian_dokter_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrPengkajianDokterRepo {
  Future<MrPengkajianDokterModel> getPengkajianDokter(int idKunjungan) async {
    final response = await dio.get('/v2/mr/pengkajian-dokter/$idKunjungan');
    return mrPengkajianDokterModelFromJson(response);
  }
}
