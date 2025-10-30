import 'package:admin_dokter_panggil/src/models/mr_kunjungan_discharge_planning_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrKunjunganDischargePlanningRepo {
  Future<MrKunjunganDischargePlanningModel> getDischargePlanning(
      int idKunjungan) async {
    final response = await dio.get('/v2/mr/discharge-planning/$idKunjungan');
    return mrKunjunganDischargePlanningModelFromJson(response);
  }
}
