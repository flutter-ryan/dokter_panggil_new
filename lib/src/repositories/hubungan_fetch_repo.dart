import 'package:dokter_panggil/src/models/hubungan_fetch_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class HubunganFetchRepo {
  Future<HubunganFetchModel> fetchHubungan() async {
    final response = await dio.get('/v1/master/hubungan/create');
    return hubunganFetchModelFromJson(response);
  }
}
