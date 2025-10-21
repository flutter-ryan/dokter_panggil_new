import 'package:admin_dokter_panggil/src/models/konfirmasi_deposit_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class KonfirmasiDepositRepo {
  Future<ResponseKonfirmasiDepositModel> konfirmasiPembayaran(
      KonfirmasiDepositModel konfirmasiDepositModel, int? id) async {
    final response = await dio.put(
        '/v1/layanan-kunjungan/konfirmasi-pembayaran/$id',
        konfirmasiDepositModelToJson(konfirmasiDepositModel));
    return responseKonfirmasiDepositModelFromJson(response);
  }
}
