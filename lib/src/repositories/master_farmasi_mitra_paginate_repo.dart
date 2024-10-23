import 'package:dokter_panggil/src/models/master_farmasi_paginate_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MasterFarmasiMitraPaginateRepo {
  Future<MasterFarmasiPaginateModel> getFarmasiMitra(
      int page, int idMitra) async {
    final response =
        await dio.get('/v1/master/farmasi/$idMitra/paginate?page=$page');
    return masterFarmasiPaginateModelFromJson(response);
  }
}
