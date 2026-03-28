import 'package:admin_dokter_panggil/src/models/token_fcm_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class TokenFcmRepo {
  Future<TokenFcmModel> updateTokenFcm(
      TokenFcmRequestModel tokenFcmRequestModel) async {
    final response = await dio.post(
        '/v1/user/token', tokenFcmRequestModelToJson(tokenFcmRequestModel));

    return tokenFcmModelFromJson(response);
  }
}
