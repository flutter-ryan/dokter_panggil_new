import 'package:dokter_panggil/src/models/master_bhp_paginate_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MasterBhpPaginateRepo {
  Future<MasterBhpPaginateModel> getMasterBhp(int page) async {
    final response = await dio.get('/v1/master/bhp/paginate?page=$page');
    return masterBhpPaginateModelFromJson(response);
  }
}
