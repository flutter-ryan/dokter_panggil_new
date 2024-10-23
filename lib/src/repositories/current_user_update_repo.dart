import 'package:dokter_panggil/src/models/current_user_update_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class CurrentUserUpdateRepo {
  Future<ResponseCurrentUserUpdateModel> updateCurrentUser(
      CurrentUserUpdateModel currentUserUpdateModel) async {
    final response = await dio.post('/v1/user/update-current',
        currentUserUpdateModelToJson(currentUserUpdateModel));

    return responseCurrentUserUpdateModelFromJson(response);
  }
}
