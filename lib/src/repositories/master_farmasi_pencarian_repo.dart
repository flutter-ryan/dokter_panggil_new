import 'package:dokter_panggil/src/models/master_farmasi_paginate_model.dart';
import 'package:dokter_panggil/src/models/master_farmasi_pencarian_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MasterFarmasiPencarianRepo {
  Future<MasterFarmasiPaginateModel> getPencarianMasterFarmasi(int? page,
      MasterFarmasiPencarianModel masterFarmasiPencarianModel) async {
    final response = await dio.post(
        '/v1/master/farmasi/paginate/search?page=$page',
        masterFarmasiPencarianModelToJson(masterFarmasiPencarianModel));
    return masterFarmasiPaginateModelFromJson(response);
  }
}
