import 'package:admin_dokter_panggil/src/blocs/auth_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/login_bloc.dart';
import 'package:admin_dokter_panggil/src/models/login_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:admin_dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final _formKey = GlobalKey<FormState>();
  final LoginBloc _loginBloc = LoginBloc();
  bool _visibility = false;
  String? _email, _password;

  bool validateAndSave() {
    FormState? formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      return true;
    }
    return false;
  }

  void _login() async {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).unfocus();
      _loginBloc.emailSink.add(_email!);
      _loginBloc.passwordSink.add(_password!);
      // final fcmToken = await FirebaseMessaging.instance.getToken();
      // if (fcmToken != null) {
      //   _loginBloc.tokenFcmSink.add(fcmToken);
      // }

      _loginBloc.login();
      _showStreamLogin();
    }
  }

  void _showStreamLogin() {
    showDialog(
      context: context,
      builder: (context) {
        return _buildStreamLogin();
      },
    ).then((value) {
      if (value != null) {
        final user = value as User;
        Future.delayed(const Duration(milliseconds: 300), () {
          authbloc.openSession(
            user.id,
            user.name,
            user.token,
            user.role,
            user.tokenFcm,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 22.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'images/logo_only.png',
                          width: 72,
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        const Text(
                          'Dokter Panggil\nAdministration',
                          style: TextStyle(
                            fontSize: 22,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Hei,\nLogin sekarang',
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 18.0,
                          ),
                          const Text(
                              'Silahkan login dengan menggunakan akun Anda'),
                          const SizedBox(
                            height: 52,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 18,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[50],
                              border:
                                  Border.all(color: Colors.grey, width: 0.5),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.envelope,
                                  color: Colors.grey[600],
                                  size: 20.0,
                                ),
                                const SizedBox(
                                  width: 15.0,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: 'Alamat email',
                                      border: InputBorder.none,
                                    ),
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return 'Input required';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) => _email = val,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 22.0,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 18,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[50],
                              border:
                                  Border.all(color: Colors.grey, width: 0.5),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.lock,
                                  color: Colors.grey[600],
                                  size: 20.0,
                                ),
                                const SizedBox(
                                  width: 15.0,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    obscureText: !_visibility,
                                    decoration: const InputDecoration(
                                      hintText: 'Password',
                                      border: InputBorder.none,
                                    ),
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return 'Input required';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) => _password = val,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _visibility = !_visibility;
                                    });
                                  },
                                  icon: _visibility
                                      ? const Icon(Icons.visibility_off)
                                      : const Icon(Icons.visibility),
                                  color: Colors.grey[600],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 62.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: kPrimaryColor),
                              child: const Text('MASUK'),
                            ),
                          ),
                          const SizedBox(
                            height: 18.0,
                          ),
                          Center(
                            child: Text(
                              'Hubungi admin drp jika Anda tidak dapat melakukan login pada aplikasi',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                          const SizedBox(
                            height: 12.0,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreamLogin() {
    return StreamBuilder<ApiResponse<ResponseLoginModel>>(
      stream: _loginBloc.loginStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit();
            case Status.error:
              return ErrorDialog(
                message: snapshot.data!.message,
              );
            case Status.completed:
              Navigator.pop(context, snapshot.data!.data!.user);
              return const SizedBox();
          }
        }
        return const SizedBox();
      },
    );
  }
}
