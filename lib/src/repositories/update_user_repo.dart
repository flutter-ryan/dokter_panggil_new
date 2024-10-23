import 'package:dokter_panggil/src/models/update_user_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class UpdateUserRepo {
  Future<ResponseUpdateUserModel> updateUser(
      int id, UpdateUserModel updateUserModel) async {
    final response = await dio.put(
        '/v1/master/pegawai/akun/$id', updateUserModelToJson(updateUserModel));

    return responseUpdateUserModelFromJson(response);
  }
}
