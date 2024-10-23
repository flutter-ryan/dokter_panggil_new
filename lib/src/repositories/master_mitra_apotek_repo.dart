import 'package:dokter_panggil/src/models/master_mitra_apotek_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MasterMitraApotekRepo {
  Future<MasterMitraApotekModel> getMitraApotek() async {
    final response = await dio.get('/v1/master/mitra/create/apotek');
    return masterMitraApotekModelFromJson(response);
  }
}
