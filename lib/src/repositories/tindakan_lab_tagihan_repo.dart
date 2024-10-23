import 'package:dokter_panggil/src/models/tindakan_lab_tagihan_modal.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class TindakanLabTagihanRepo {
  Future<TindakanLabTagihanModel> getTindakanLabTagihan() async {
    final response = await dio.get('/v1/tagihan-lab/tindakan-lab');
    return tindakanLabTagihanModelFromJson(response);
  }
}
