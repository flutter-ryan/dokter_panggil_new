import 'package:admin_dokter_panggil/src/models/pegawai_edit_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class PegawaiEditRepo {
  Future<PegawaiEditModel> editPegawai(int? id) async {
    final response = await dio.get('/v1/master/pegawai/$id/edit');
    return pegawaiEditModelFromJson(response);
  }
}
