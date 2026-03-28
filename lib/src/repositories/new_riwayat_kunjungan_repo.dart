import 'package:admin_dokter_panggil/src/models/new_riwayat_kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class NewRiwayatKunjunganRepo {
  Future<NewRiwayatKunjunganModel> getRiwayatKunjungan(
      NewRiwayatKunjunganRequestModel newRiwayatKunjunganRequestModel) async {
    final response = await dio.post('/v2/mr/kunjungan/riwayat/filter',
        newRiwayatKunjunganRequestModelToJson(newRiwayatKunjunganRequestModel));
    return newRiwayatKunjunganModelFromJson(response);
  }

  Future<NewRiwayatKunjunganModel> nextPageRiwayat(String url,
      NewRiwayatKunjunganRequestModel newRiwayatKunjunganRequestModel) async {
    final response = await dio.post(url,
        newRiwayatKunjunganRequestModelToJson(newRiwayatKunjunganRequestModel));
    return newRiwayatKunjunganModelFromJson(response);
  }
}
