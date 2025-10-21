import 'package:admin_dokter_panggil/src/models/login_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class LoginRepo {
  Future<ResponseLoginModel> login(LoginModel loginModel) async {
    final response = await dio.post('/v1/login', loginModelToJson(loginModel));
    return responseLoginModelFromJson(response);
  }
}
