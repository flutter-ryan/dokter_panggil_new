import 'package:admin_dokter_panggil/src/blocs/current_user_bloc.dart';
import 'package:admin_dokter_panggil/src/blocs/current_user_update_bloc.dart';
import 'package:admin_dokter_panggil/src/models/current_user_model.dart';
import 'package:admin_dokter_panggil/src/models/current_user_update_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/input_form.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:admin_dokter_panggil/src/source/transition/animated_dialog.dart';

class CurrentUserPage extends StatefulWidget {
  const CurrentUserPage({super.key});

  @override
  State<CurrentUserPage> createState() => _CurrentUserPageState();
}

class _CurrentUserPageState extends State<CurrentUserPage> {
  final _currentUserBloc = CurrentUserBloc();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    _currentUserBloc.getCurrentUser();
    setState(() {});
  }

  @override
  void dispose() {
    _currentUserBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context, 'logout'),
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(
            width: 5.0,
          )
        ],
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: _streamCurrentUser(context),
    );
  }

  Widget _streamCurrentUser(BuildContext context) {
    return StreamBuilder<ApiResponse<CurrentUserModel>>(
        stream: _currentUserBloc.currentUserStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status) {
              case Status.loading:
                return const LoadingKit(
                  color: kPrimaryColor,
                );
              case Status.error:
                return Center(
                  child: ErrorResponse(
                    message: snapshot.data!.message,
                    onTap: () {
                      _currentUserBloc.getCurrentUser();
                      setState(() {});
                    },
                  ),
                );
              case Status.completed:
                var user = snapshot.data!.data!.data!;
                return FormCurrentUser(data: user, reload: _loadUser);
            }
          }
          return const SizedBox();
        });
  }
}

class FormCurrentUser extends StatefulWidget {
  const FormCurrentUser({
    super.key,
    this.data,
    this.reload,
  });

  final CurrentUser? data;
  final VoidCallback? reload;

  @override
  State<FormCurrentUser> createState() => _FormCurrentUserState();
}

class _FormCurrentUserState extends State<FormCurrentUser> {
  final _currentUserUpdateBloc = CurrentUserUpdateBloc();
  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _passwordAgain = TextEditingController();

  bool validateAndSave() {
    var formData = _formKey.currentState;
    if (formData!.validate()) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _nama.text = '${widget.data!.name}';
    _email.text = '${widget.data!.email}';
  }

  void _update() {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).requestFocus(FocusNode());
      _currentUserUpdateBloc.namaSink.add(_nama.text);
      _currentUserUpdateBloc.emailSink.add(_email.text);
      _currentUserUpdateBloc.passwordSink.add(_password.text);
      _currentUserUpdateBloc.confirmationPasswordSink.add(_passwordAgain.text);
      _currentUserUpdateBloc.updateCurrentUser();
      _showStreamUpdateCurrentUser();
    }
  }

  void _showStreamUpdateCurrentUser() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamUpdateCurrentUser(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        widget.reload!();
      }
    });
  }

  @override
  void dispose() {
    _currentUserUpdateBloc.dispose();
    _nama.dispose();
    _email.dispose();
    _password.dispose();
    _passwordAgain.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: ListView(
              padding: const EdgeInsets.all(22.0),
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: kPrimaryColor,
                  foregroundColor: Colors.grey[100],
                  child: const Icon(
                    Icons.person,
                    size: 42,
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Center(
                  child: Text(
                    '${widget.data!.name}',
                    style: const TextStyle(
                        fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                ),
                if (widget.data!.role == 99)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text('Superadmin'),
                    ),
                  )
                else
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text('Administrator'),
                    ),
                  ),
                const SizedBox(
                  height: 22.0,
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22.0, vertical: 32.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12,
                            offset: Offset(2.0, 2.0),
                          )
                        ]),
                    child: Column(
                      children: [
                        Input(
                          controller: _nama,
                          label: 'Nama',
                          hint: 'Nama lengkap pengguna',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Input Required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 18.0,
                        ),
                        Input(
                          controller: _email,
                          label: 'Email',
                          hint: 'Alamat email',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Input Required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 18.0,
                        ),
                        Input(
                          controller: _password,
                          label: 'Password',
                          hint: 'Password min. 6 karakter',
                        ),
                        const SizedBox(
                          height: 18.0,
                        ),
                        Input(
                          controller: _passwordAgain,
                          label: 'Ulangi password',
                          hint: 'Ulangi password yang sama',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _update,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    minimumSize: const Size.fromHeight(45),
                  ),
                  child: const Text('Update'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _streamUpdateCurrentUser(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseCurrentUserUpdateModel>>(
        stream: _currentUserUpdateBloc.currentUpdateStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status) {
              case Status.loading:
                return const LoadingKit();
              case Status.error:
                return ErrorDialog(
                  message: snapshot.data!.message,
                  onTap: () => Navigator.pop(context),
                );
              case Status.completed:
                return SuccessDialog(
                  message: snapshot.data!.data!.message,
                  onTap: () => Navigator.pop(context, 'success'),
                );
            }
          }
          return const SizedBox();
        });
  }
}
