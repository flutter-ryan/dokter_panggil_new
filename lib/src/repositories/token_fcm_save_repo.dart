import 'package:dokter_panggil/src/models/token_fcm_save_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class TokenFcmSaveRepo {
  Future<ResponseTokenFcmSaveModel> saveTokenFcm(
      TokenFcmSaveModel tokenFcmSaveModel) async {
    final response = await dio.post(
        '/v1/user/token', tokenFcmSaveModelToJson(tokenFcmSaveModel));
    return responseTokenFcmSaveModelFromJson(response);
  }
}
