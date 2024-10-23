import 'package:dokter_panggil/src/models/master_bhp_paginate_model.dart';
import 'package:dokter_panggil/src/models/master_bhp_pencarian_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MasterBhpPencarianRepo {
  Future<MasterBhpPaginateModel> getPencarianMasterBhp(
      int? page, MasterBhpPencarianModel masterBhpPencarianModel) async {
    final response = await dio.post('/v1/master/bhp/paginate/search?page=$page',
        masterBhpPencarianModelToJson(masterBhpPencarianModel));
    return masterBhpPaginateModelFromJson(response);
  }
}
