import 'package:admin_dokter_panggil/src/models/current_user_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class CurrentUserRepo {
  Future<CurrentUserModel> getCurrentUser() async {
    final response = await dio.get('/v1/user/create');
    return currentUserModelFromJson(response);
  }
}
