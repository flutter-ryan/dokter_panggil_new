import 'package:admin_dokter_panggil/src/models/file_eresep_racikan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class FileEresepRacikanRepo {
  Future<FileEresepRacikanModel> kirimEresp(int idResep) async {
    final response =
        await dio.get('/v2/mr/resep-racikan/tagihan/resep/$idResep');
    return fileEresepRacikanModelFromJson(response);
  }
}
