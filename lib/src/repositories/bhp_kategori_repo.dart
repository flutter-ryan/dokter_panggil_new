import 'package:admin_dokter_panggil/src/models/bhp_kategori_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class BhpKategoriRepo {
  Future<BhpKategoriModel> getBhpKategori() async {
    final response = await dio.get('/v1/bhp-kategori');
    return bhpKategoriModelFromJson(response);
  }
}
