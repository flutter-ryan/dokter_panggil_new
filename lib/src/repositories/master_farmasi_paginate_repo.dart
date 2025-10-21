import 'package:admin_dokter_panggil/src/models/master_farmasi_paginate_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MasterFarmasiPaginateRepo {
  Future<MasterFarmasiPaginateModel> getMasterFarmasi(int page) async {
    final response = await dio.get('/v1/master/farmasi/paginate?page=$page');
    return masterFarmasiPaginateModelFromJson(response);
  }

  Future<MasterFarmasiPaginateModel> getMasterFarmasiMitra(
      int page, int idMitra) async {
    final response =
        await dio.get('/v1/master/farmasi/paginate/mitra/$idMitra?page=$page');
    return masterFarmasiPaginateModelFromJson(response);
  }
}
