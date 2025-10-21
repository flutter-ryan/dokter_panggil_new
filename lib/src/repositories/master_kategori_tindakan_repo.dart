import 'package:admin_dokter_panggil/src/models/master_kategori_tindakan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MasterKategoriTindakanRepo {
  Future<MasterKategoriTindakanModel> getKategoriTindakan() async {
    final response = await dio.get('/v2/mr/master/kategori-tindakan');
    return masterKategoriTindakanModelFromJson(response);
  }
}
