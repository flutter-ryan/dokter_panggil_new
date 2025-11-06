import 'package:admin_dokter_panggil/src/models/mr_kunjungan_consent_tindakan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrKunjunganConsentTindakanRepo {
  Future<MrKunjunganConsentTindakanModel> getConsentTindakan(
      int idKunjungan) async {
    final response = await dio.get('/v2/mr/persetujuan-tindakan/$idKunjungan');
    return mrKunjunganConsentTindakanModelFromJson(response);
  }
}
