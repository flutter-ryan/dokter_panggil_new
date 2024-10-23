import 'package:dio/dio.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_exception.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioHelper {
  late Dio dio;

  DioHelper() {
    BaseOptions options = BaseOptions(
      baseUrl: '$url/api',
      headers: {
        "Accept": "application/json",
      },
    );
    dio = Dio(options);
  }

  Future<dynamic> get(String? url) async {
    dynamic responseJson;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      if (token != null || token != '') {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }
      final response = await dio.get('$url');
      responseJson = response.data;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw BadRequestException("Server unreachable...connection timeout");
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw BadRequestException("Server unreachable...receive timeout");
      } else if (e.type == DioExceptionType.badResponse) {
        _returnResponse(e.response);
      }
      throw ErrorNoCodeException("Terjadi kesalahan...Coba beberapa saat lagi");
    }
    return responseJson;
  }

  Future<dynamic> post(String? url, String? request) async {
    dynamic responseJson;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      if (token != null) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }
      dio.options.headers['Content-Type'] = 'application/json';
      final response = await dio.post('$url', data: request);
      responseJson = response.data;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw BadRequestException("Server unreachable...connection timeout");
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw BadRequestException("Server unreachable...receive timeout");
      } else if (e.type == DioExceptionType.badResponse) {
        _returnResponse(e.response);
      }
      throw ErrorNoCodeException("Terjadi kesalahan...Coba beberapa saat lagi");
    }

    return responseJson;
  }

  Future<dynamic> put(String? url, String? request) async {
    dynamic responseJson;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      if (token != null) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['Accept'] = 'application/json';
      final response = await dio.put('$url', data: request);
      responseJson = response.data;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw BadRequestException("Server unreachable...connection timeout");
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw BadRequestException("Server unreachable...receive timeout");
      } else if (e.type == DioExceptionType.badResponse) {
        _returnResponse(e.response);
      }
      throw ErrorNoCodeException("Terjadi kesalahan...Coba beberapa saat lagi");
    }

    return responseJson;
  }

  Future<dynamic> delete(String? url) async {
    dynamic responseJson;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      if (token != null) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }
      dio.options.headers['Accept'] = 'application/json';
      final response = await dio.delete('$url');
      responseJson = response.data;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw BadRequestException("Server unreachable...connection timeout");
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw BadRequestException("Server unreachable...receive timeout");
      } else if (e.type == DioExceptionType.badResponse) {
        _returnResponse(e.response);
      }
      throw ErrorNoCodeException("Terjadi kesalahan...Coba beberapa saat lagi");
    }

    return responseJson;
  }

  dynamic _returnResponse(Response<dynamic>? response) {
    final errorData = exceptionModelFromJson(response!.data);
    print(response);
    switch (response.statusCode) {
      case 401:
      case 403:
        throw UnauthorisedException(
            '${response.statusCode} - Unauthorized\n${errorData.messages}');
      case 404:
        throw FetchDataException('${errorData.messages}');
      case 422:
        throw InvalidInputException(
            '${response.statusCode} - Validation Error\n${errorData.messages}');
      case 429:
        throw InvalidInputException(
            '${response.statusCode} - Server Error\n${errorData.messages}');
      case 500:
      default:
        throw FetchDataException(
            '${response.statusCode} - Internal Server Error\nTerjadi kesalahan pada server.');
    }
  }
}

ExceptionModel exceptionModelFromJson(dynamic str) =>
    ExceptionModel.fromJson(str);

class ExceptionModel {
  ExceptionModel({
    this.messages,
  });

  String? messages;

  factory ExceptionModel.fromJson(Map<String, dynamic> json) => ExceptionModel(
        messages: json["message"],
      );
}

final DioHelper dio = DioHelper();
