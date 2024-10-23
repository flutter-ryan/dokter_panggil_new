import 'dart:convert';

String pencarianMasterTindakanGroupModelToJson(
        PencarianMasterTindakanGroupModel data) =>
    json.encode(data.toJson());

class PencarianMasterTindakanGroupModel {
  String filter;
  int idGroup;

  PencarianMasterTindakanGroupModel({
    required this.filter,
    required this.idGroup,
  });

  Map<String, dynamic> toJson() => {
        "filter": filter,
        "idGroup": idGroup,
      };
}
