import 'package:dokter_panggil/src/models/tindakan_edit_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class TindakanEditRepo {
  Future<TindakanEditModel> editTindakan(int? id) async {
    final response = await dio.get('/v1/master/tindakan/$id');
    return tindakanEditModelFromJson(response);
  }

  Future<TindakanEditModel> deleteTindakan(int? id) async {
    final response = await dio.delete('/v1/master/tindakan/$id');
    return tindakanEditModelFromJson(response);
  }
}
