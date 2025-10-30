import 'package:admin_dokter_panggil/src/models/mr_kunjungan_cppt_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrKunjunganCpptRepo {
  Future<MrKunjunganCpptModel> getCppt(int idKunjungan) async {
    final resposne = await dio.get('/v2/mr/cppt/$idKunjungan');
    return mrKunjunganCpptModelFromJson(resposne);
  }
}
