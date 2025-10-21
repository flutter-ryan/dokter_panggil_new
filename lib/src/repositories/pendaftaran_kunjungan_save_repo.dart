import 'package:admin_dokter_panggil/src/models/pendaftaran_kunjungan_paket_save_mode.dart';
import 'package:admin_dokter_panggil/src/models/pendaftaran_kunjungan_save_model.dart';
import 'package:admin_dokter_panggil/src/models/pendaftaran_pembelian_langsug_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class PendaftaranKunjunganSaveRepo {
  Future<ResponsePendaftaranKunjunganSaveModel> saveKunjungan(
      PendaftaranKunjunganSaveModel pendaftaranKunjunganSaveModel) async {
    final response = await dio.post('/v1/kunjungan',
        pendaftaranKunjunganSaveModelToJson(pendaftaranKunjunganSaveModel));
    return responsePendaftaranKunjunganSaveModelFromJson(response);
  }

  Future<ResponsePendaftaranKunjunganSaveModel> saveKunjunganPaket(
      PendaftaranKunjunganPaketSaveModel
          pendaftaranKunjunganPaketSaveModel) async {
    final response = await dio.post(
        '/v1/kunjungan/paket',
        pendaftaranKunjunganPaketSaveModelToJson(
            pendaftaranKunjunganPaketSaveModel));
    return responsePendaftaranKunjunganSaveModelFromJson(response);
  }

  Future<ResponsePendaftaranPembelianLangsungSaveModel> savePembelianLangsung(
      PendaftaranPembelianLangsungSaveModel
          pendaftaranPembelianLangsungSaveModel) async {
    final response = await dio.post(
        '/v1/kunjungan/pembelian-langsung',
        pendaftaranPembelianLangsungSaveModelToJson(
            pendaftaranPembelianLangsungSaveModel));
    return responsePendaftaranPembelianLangsungSaveModelFromJson(response);
  }
}
