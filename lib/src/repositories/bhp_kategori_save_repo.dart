import 'package:admin_dokter_panggil/src/models/bhp_kategori_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class BhpKategoriSaveRepo {
  Future<ResponseBhpKategoriSaveModel> saveKategori(
      BhpKategoriSaveModel bhpKategoriSaveModel) async {
    final response = await dio.post(
        '/v1/bhp-kategori', bhpKategoriSaveModelToJson(bhpKategoriSaveModel));
    return responseBhpKategoriSaveModelFromJson(response);
  }
}
