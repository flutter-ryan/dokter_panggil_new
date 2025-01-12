import 'package:dokter_panggil/src/models/file_eresep_oral_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class FileEresepOralRepo {
  Future<FileEresepOralModel> eresepOral(int idResep) async {
    final response = await dio.get('/v2/mr/resep-oral/tagihan/resep/$idResep');
    return fileEresepOralModelFromJson(response);
  }
}
