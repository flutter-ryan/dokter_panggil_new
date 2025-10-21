import 'package:admin_dokter_panggil/src/models/master_bhp_kategori_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MasterBhpKategoriRepo {
  Future<MasterBhpKategoriModel> getBhpKategori(int idKategori) async {
    final response = await dio.get('/v1/master/bhp/kategori/$idKategori');
    return masterBhpKategoriModelFromJson(response);
  }
}
