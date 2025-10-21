import 'package:admin_dokter_panggil/src/models/tindakan_create_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class TindakanCreateRepo {
  Future<TindakanCreateModel> tindakanCreate() async {
    final response = await dio.get('/v1/master/tindakan/create');
    return tindakanCreateModelFromJson(response);
  }
}
