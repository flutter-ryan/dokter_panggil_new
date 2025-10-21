import 'package:admin_dokter_panggil/src/models/file_eresep_injeksi_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class FileEresepInjeksiRepo {
  Future<FileEresepInjeksiModel> eresepInjeksi(int idResep) async {
    final response =
        await dio.get('/v2/mr/obat-injeksi/tagihan/resep/$idResep');
    return fileEresepInjeksiModelFromJson(response);
  }
}
