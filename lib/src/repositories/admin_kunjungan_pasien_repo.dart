import 'package:dokter_panggil/src/models/admin_kunjungan_pasien_delete_model.dart';
import 'package:dokter_panggil/src/models/admin_kunjungan_pasien_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class AdminKunjunganPasienRepo {
  Future<AdminKunjunganPasienModel> getAdminKunjungan(
      KirimAdminKunjunganPasienModel kirimAdminKunjunganPasienModel,
      int page) async {
    final response = await dio.post('/v1/kunjungan/admin?page=$page',
        kirimAdminKunjunganPasienModelToJson(kirimAdminKunjunganPasienModel));
    return adminKunjunganPasienModelFromJson(response);
  }

  Future<AdminKunjunganPasienDeleteModel> deleteAdminKunjungan(
      int idKunjungan) async {
    final response = await dio.delete('/v1/kunjungan/delete/$idKunjungan');
    return adminKunjunganPasienDeleteModelFromJson(response);
  }
}
