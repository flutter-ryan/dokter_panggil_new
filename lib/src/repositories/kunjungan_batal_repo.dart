import 'package:dokter_panggil/src/models/pendaftaran_kunjungan_save_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class KunjunganBatalRepo {
  Future<ResponsePendaftaranKunjunganSaveModel> batalKunjungan(int? id) async {
    final response = await dio.delete('/v1/kunjungan/batal/$id');
    return responsePendaftaranKunjunganSaveModelFromJson(response);
  }
}
