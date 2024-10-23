import 'package:dokter_panggil/src/blocs/master_pegawai_fetch_bloc.dart';
import 'package:dokter_panggil/src/blocs/pegawai_update_akun_bloc.dart';
import 'package:dokter_panggil/src/blocs/token_fcm_save_bloc.dart';
import 'package:dokter_panggil/src/models/master_pegawai_fetch_model.dart';
import 'package:dokter_panggil/src/models/pegawai_update_akun_model.dart';
import 'package:dokter_panggil/src/models/token_fcm_save_model.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/form_akun.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/components/title_quick_act.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/local_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class AkunPage extends StatefulWidget {
  const AkunPage({Key? key}) : super(key: key);

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  final _masterPegawaiFetchBloc = MasterPegawaiFetchBloc();
  final PegawaiUpdateAkunBloc _pegawaiUpdateAkunBloc = PegawaiUpdateAkunBloc();
  final _tokenFcmSaveBloc = TokenFcmSaveBloc();

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _password = TextEditingController();
  final _konfirmPass = TextEditingController();
  String? _token;

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _masterPegawaiFetchBloc.getPegawai();
    _getTokenFcm();
  }

  void _getTokenFcm() async {
    final token = await FirebaseMessaging.instance.getToken();
    setState(() {
      _token = token;
    });
  }

  void _edit(User data) {
    _name.text = data.name!;
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              top: 32.0, bottom: MediaQuery.of(context).viewInsets.bottom),
          child: _formEditPengguna(),
        );
      },
    ).then((value) {
      if (value != null) {
        SystemChannels.textInput.invokeMapMethod('TextInput.hide');
        _update();
      }
    });
  }

  void _update() {
    if (validateAndSave()) {
      _pegawaiUpdateAkunBloc.nameSink.add(_name.text);
      _pegawaiUpdateAkunBloc.passwordSink.add(_password.text);
      _pegawaiUpdateAkunBloc.passwordConfirmationSink.add(_konfirmPass.text);
      _pegawaiUpdateAkunBloc.updateAkun();
      _showStreamUpdate();
    }
  }

  void _showStreamUpdate() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamUpdate();
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        _masterPegawaiFetchBloc.getPegawai();
        setState(() {});
      }
    });
  }

  void _notifikasi(int? id) {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          message: 'Anda ingin mengaktifkan notifikasi?',
          labelConfirm: 'Ya, Aktifkan',
          onConfirm: () => Navigator.pop(context, 'confirm'),
        );
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        RemoteMessage payload = const RemoteMessage(
          data: {'type': 'notifikasi'},
          notification: RemoteNotification(
              title: 'Aktivasi notifikasi',
              body: 'Anda telah mengktifkan notifikasi'),
        );
        LocalNotificationService.showNotification(payload);
        _tokenFcmSaveBloc.tokenSink.add(_token!);
        _tokenFcmSaveBloc.saveTokenFcm();
        _showStreamSaveToken(context);
      }
    });
  }

  void _showStreamSaveToken(BuildContext context) {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamSaveToken(context);
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        _masterPegawaiFetchBloc.getPegawai();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _masterPegawaiFetchBloc.dispose();
    _tokenFcmSaveBloc.dispose();
    _pegawaiUpdateAkunBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleQuickAct(
            title: 'Profil pengguna',
          ),
          const SizedBox(
            height: 32.0,
          ),
          Expanded(
            child: _streamPegawai(),
          )
        ],
      ),
    );
  }

  Widget _streamPegawai() {
    return StreamBuilder<ApiResponse<MasterPegawaiFetchModel>>(
      stream: _masterPegawaiFetchBloc.masterPegawaiStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const Center(
                child: LoadingKit(
                  color: kPrimaryColor,
                ),
              );
            case Status.error:
              return Center(
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  onTap: () {
                    _masterPegawaiFetchBloc.getPegawai();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              var pegawai = snapshot.data!.data!.pegawai;
              return ListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 22.0, vertical: 18.0),
                children: [
                  const Center(
                    child: Icon(
                      Icons.account_circle_outlined,
                      color: Colors.grey,
                      size: 72.0,
                    ),
                  ),
                  const Divider(
                    height: 52.0,
                  ),
                  const Text(
                    'Informasi pegawai',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  TileProfile(
                    label: 'Nama',
                    body: '${pegawai?.nama}',
                    onTap: () => pushScreen(
                      context,
                      screen: FormAkun(
                        id: pegawai?.id,
                        namaPegawai: pegawai?.nama,
                      ),
                      pageTransitionAnimation: PageTransitionAnimation.slideUp,
                      withNavBar: false,
                    ).then((value) {
                      if (value != null) {
                        _masterPegawaiFetchBloc.getPegawai();
                        setState(() {});
                      }
                    }),
                  ),
                  TileProfile(
                    label: 'Profesi',
                    body: '${pegawai?.profesi?.namaJabatan}',
                    onTap: () => pushScreen(
                      context,
                      screen: FormAkun(
                        id: pegawai?.id,
                        profesi: pegawai?.profesi?.namaJabatan,
                        idProfesi: pegawai?.profesi?.id,
                      ),
                      pageTransitionAnimation: PageTransitionAnimation.slideUp,
                      withNavBar: false,
                    ),
                  ),
                  const Divider(
                    height: 52.0,
                  ),
                  const Text(
                    'Akun pengguna',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  TileProfile(
                    label: 'Nama',
                    body: '${pegawai?.user!.name}',
                    onTap: () => pushScreen(
                      context,
                      screen: FormAkun(
                        id: pegawai?.id,
                        namaAkun: pegawai?.user!.name,
                      ),
                      pageTransitionAnimation: PageTransitionAnimation.slideUp,
                      withNavBar: false,
                    ),
                  ),
                  TileProfile(
                    label: 'Email',
                    body: '${pegawai?.user!.email}',
                  ),
                  TileProfile(
                    label: 'Password',
                    body: '*****',
                    onTap: () => pushScreen(
                      context,
                      screen: FormAkun(
                        id: pegawai?.id,
                        namaAkun: pegawai?.user!.name,
                      ),
                      pageTransitionAnimation: PageTransitionAnimation.slideUp,
                      withNavBar: false,
                    ),
                  ),
                  const Divider(
                    height: 52.0,
                  ),
                  const Text(
                    'Notifikasi',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  if (_token != pegawai?.user?.tokenFcm)
                    TileProfile(
                      label: 'Token FCM',
                      bodyActive: ElevatedButton(
                        onPressed: () => _notifikasi(pegawai!.user!.id),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        child: const Text("Aktikan Notifikasi"),
                      ),
                      onTap: () {},
                    )
                  else
                    TileProfile(
                      label: 'Token FCM',
                      body: '${pegawai?.user!.tokenFcm}',
                      onTap: () {},
                    ),
                  const SizedBox(
                    height: 42,
                  ),
                  ElevatedButton(
                    onPressed: () => _edit(pegawai!.user!),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        minimumSize: const Size(double.infinity, 45)),
                    child: const Text('Edit Akun'),
                  ),
                ],
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _formEditPengguna() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.0),
          child: Text(
            'Edit Pengguna',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(
          height: 32.0,
        ),
        Flexible(
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding:
                  const EdgeInsets.only(bottom: 22.0, left: 22.0, right: 22.0),
              children: [
                Input(
                  controller: _name,
                  label: 'Nama',
                  hint: 'Nama user akun',
                  maxLines: 1,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Input required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 22.0,
                ),
                Input(
                  controller: _password,
                  label: 'Password',
                  hint: 'Password akun',
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 22.0,
                ),
                Input(
                  controller: _konfirmPass,
                  label: 'Konfirmasi password',
                  hint: 'Konfirmasi password akun',
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 52.0,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, 'update'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                    ),
                    child: const Text('Update'),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _streamUpdate() {
    return StreamBuilder<ApiResponse<ResponsePegawaiUpdateAkunModel>>(
      stream: _pegawaiUpdateAkunBloc.pegawaiUpdateStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: Colors.white,
              );
            case Status.error:
              return ErrorDialog(
                message: snapshot.data!.message,
              );
            case Status.completed:
              return SuccessDialog(
                message: snapshot.data!.data!.message,
                onTap: () => Navigator.pop(context, 'reload'),
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _streamSaveToken(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseTokenFcmSaveModel>>(
      stream: _tokenFcmSaveBloc.tokenFcmStream,
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
                onTap: () =>
                    Navigator.pop(context, snapshot.data!.data!.data!.token),
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class TileProfile extends StatelessWidget {
  const TileProfile({
    Key? key,
    this.label,
    this.body,
    this.onTap,
    this.bodyActive,
  }) : super(key: key);
  final String? label;
  final String? body;
  final VoidCallback? onTap;
  final Widget? bodyActive;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  '$label',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              bodyActive ??
                  Expanded(
                    flex: 3,
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: '$body',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
              if (bodyActive == null)
                const Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.grey,
                )
              else
                const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
