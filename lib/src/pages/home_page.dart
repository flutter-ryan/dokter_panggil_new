import 'package:dokter_panggil/src/blocs/auth_bloc.dart';
import 'package:dokter_panggil/src/blocs/kunjungan_bloc.dart';
import 'package:dokter_panggil/src/blocs/kunjungan_final_bloc.dart';
import 'package:dokter_panggil/src/models/kunjungan_final_model.dart';
import 'package:dokter_panggil/src/models/kunjungan_model.dart';
import 'package:dokter_panggil/src/models/pendaftaran_kunjungan_save_model.dart';
import 'package:dokter_panggil/src/pages/admin_area.dart';
import 'package:dokter_panggil/src/pages/akun_page.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/detail_layanan_widget.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_card_vert_layanan.dart';
import 'package:dokter_panggil/src/pages/kunjungan_page.dart';
import 'package:dokter_panggil/src/pages/pasien/detail_layanan_page.dart';
import 'package:dokter_panggil/src/pages/pasien/pencarian_pasien_page.dart';
import 'package:dokter_panggil/src/pages/current_user_page.dart';
import 'package:dokter_panggil/src/pages/riwayat_kunjungan_page.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

class Homepage extends StatefulWidget {
  const Homepage({
    super.key,
    required this.name,
    required this.role,
  });

  final String name;
  final int role;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final KunjunganBloc _kunjunganBloc = KunjunganBloc();
  final KunjunganFinalBloc _kunjunganFinalBloc = KunjunganFinalBloc();

  @override
  void initState() {
    super.initState();
    _kunjunganBloc.kunjunganPasien();
    _kunjunganFinalBloc.kunjunganFinal();
  }

  Future<void> _showVersion() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    String version = info.version;
    if (!mounted) return;
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'images/logo.png',
                  width: 200,
                ),
                const SizedBox(
                  height: 32.0,
                ),
                const Text(
                  'Dokter Panggil Admin',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text('Version $version'),
                const SizedBox(
                  height: 22.0,
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    minimumSize: const Size(200, 45),
                  ),
                  child: const Text('Tutup'),
                )
              ],
            ),
          ),
        );
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 22.0,
                right: 8.0,
                top: MediaQuery.of(context).padding.top + 12.0,
                bottom: 12.0,
              ),
              decoration: const BoxDecoration(color: kPrimaryColor, boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(1.0, 2.0))
              ]),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.account_circle,
                          size: 28,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => pushScreen(
                              context,
                              screen: const CurrentUserPage(),
                              pageTransitionAnimation:
                                  PageTransitionAnimation.slideUp,
                              withNavBar: false,
                            ).then((value) {
                              if (value != null) {
                                authbloc.closedSession();
                              }
                            }),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    'Hai, ${widget.name}',
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  width: 4.0,
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _showVersion,
                    color: Colors.white,
                    icon: const Icon(Icons.info_outline_rounded),
                  ),
                  if (widget.role == 99)
                    IconButton(
                      onPressed: () => pushScreen(
                        context,
                        screen: const AdminArea(),
                        pageTransitionAnimation:
                            PageTransitionAnimation.slideUp,
                        withNavBar: false,
                      ),
                      color: Colors.white,
                      icon: const Icon(Icons.admin_panel_settings_outlined),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 22.0),
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22.0),
                    child: Text(
                      'Quick Action',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22.0, vertical: 15.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: QuickActionButton(
                              onTap: () => pushScreen(
                                context,
                                screen: const PencarianPasianpage(),
                                pageTransitionAnimation:
                                    PageTransitionAnimation.slideUp,
                                withNavBar: false,
                              ),
                              label: const Text(
                                'Registrasi',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.0),
                              ),
                              icon: const FaIcon(
                                FontAwesomeIcons.paste,
                                color: Colors.white,
                                size: 28.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: QuickActionButton(
                              onTap: () => pushScreen(
                                context,
                                screen: const KunjunganPage(),
                                pageTransitionAnimation:
                                    PageTransitionAnimation.slideUp,
                                withNavBar: false,
                              ),
                              label: const Text(
                                'Kunjungan',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.0),
                              ),
                              icon: const FaIcon(
                                FontAwesomeIcons.personCircleCheck,
                                color: Colors.white,
                                size: 28.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: QuickActionButton(
                              onTap: () => pushScreen(
                                context,
                                screen: const RiwayatKunjunganPage(),
                                pageTransitionAnimation:
                                    PageTransitionAnimation.slideUp,
                                withNavBar: false,
                              ),
                              label: const Text(
                                'History',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.0),
                              ),
                              icon: const FaIcon(
                                FontAwesomeIcons.clockRotateLeft,
                                color: Colors.white,
                                size: 28.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: QuickActionButton(
                              onTap: () => pushScreen(
                                context,
                                screen: const AkunPage(),
                                withNavBar: false,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.slideUp,
                              ),
                              label: const Text(
                                'Akun',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.0),
                              ),
                              icon: const FaIcon(
                                FontAwesomeIcons.userDoctor,
                                color: Colors.white,
                                size: 28.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Kunjungan Terbaru',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w600),
                        ),
                        InkWell(
                          onTap: () {
                            _kunjunganBloc.kunjunganPasien();
                            setState(() {});
                          },
                          child: const Text(
                            'Reload',
                            style:
                                TextStyle(color: Colors.blue, fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  _streamKunjunganPasien(),
                  const SizedBox(
                    height: 22.0,
                  ),
                  const Divider(
                    height: 0,
                    thickness: 8,
                  ),
                  const SizedBox(
                    height: 22.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Riwayat Terbaru',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w600),
                        ),
                        InkWell(
                          onTap: () {
                            _kunjunganFinalBloc.kunjunganFinal();
                            setState(() {});
                          },
                          child: const Text(
                            'Reload',
                            style:
                                TextStyle(color: Colors.blue, fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  _streamKunjunganFinal(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _streamKunjunganPasien() {
    return StreamBuilder<ApiResponse<KunjunganModel>>(
      stream: _kunjunganBloc.kunjunganStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingCardVertLayanan(
                itemCount: 3,
                padding: EdgeInsets.symmetric(
                  horizontal: 22.0,
                  vertical: 18.0,
                ),
              );
            case Status.error:
              return SizedBox(
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: ErrorResponse(
                    message: snapshot.data!.message,
                    onTap: () {
                      _kunjunganBloc.kunjunganPasien();
                      setState(() {});
                    },
                  ),
                ),
              );
            case Status.completed:
              return KunjunganPasien(
                data: snapshot.data!.data!.kunjungan!,
                reload: () {
                  _kunjunganFinalBloc.kunjunganFinal();
                  _kunjunganBloc.kunjunganPasien();
                  setState(() {});
                },
                role: widget.role,
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _streamKunjunganFinal() {
    return StreamBuilder<ApiResponse<KunjunganModel>>(
      stream: _kunjunganFinalBloc.kunjunganFinalStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingCardVertLayanan(
                itemCount: 3,
                padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 18.0),
              );
            case Status.error:
              return SizedBox(
                height: 300,
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  onTap: () {
                    _kunjunganFinalBloc.kunjunganFinal();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              return KunjunganPasien(
                data: snapshot.data!.data!.kunjungan!,
                type: 'view',
                role: widget.role,
                reload: () {
                  _kunjunganBloc.kunjunganPasien();
                  _kunjunganFinalBloc.kunjunganFinal();
                  setState(() {});
                },
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class QuickActionButton extends StatelessWidget {
  const QuickActionButton({
    super.key,
    this.label,
    this.icon,
    this.onTap,
  });

  final Widget? label;
  final Widget? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? const SizedBox(),
            const SizedBox(
              height: 12.0,
            ),
            label ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class KunjunganPasien extends StatefulWidget {
  const KunjunganPasien({
    super.key,
    required this.data,
    this.reload,
    this.type = 'create',
    this.role,
  });

  final List<Kunjungan> data;
  final VoidCallback? reload;
  final String type;
  final int? role;

  @override
  State<KunjunganPasien> createState() => _KunjunganPasienState();
}

class _KunjunganPasienState extends State<KunjunganPasien> {
  List<Kunjungan> _pasien = [];
  @override
  void initState() {
    super.initState();
    _pasien = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_pasien.isEmpty)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 22.0, vertical: 18.0),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: kPrimaryColor.withAlpha(30),
                border: Border.all(width: 0.5, color: kPrimaryColor),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Center(
                child: Text(
                  'Data kunjungan tidak tersedia',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: 280,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 22.0,
                vertical: 18.0,
              ),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                var data = _pasien[i];
                return CardLayananVertPasien(
                  data: data,
                  reload: widget.reload!,
                  type: widget.type,
                  role: widget.role,
                );
              },
              separatorBuilder: (context, i) => const SizedBox(
                width: 15.0,
              ),
              itemCount: _pasien.length,
            ),
          ),
      ],
    );
  }
}

class CardLayananVertPasien extends StatefulWidget {
  const CardLayananVertPasien({
    super.key,
    required this.data,
    required this.reload,
    this.type = 'create',
    this.role,
  });

  final Kunjungan data;
  final VoidCallback reload;
  final String type;
  final int? role;

  @override
  State<CardLayananVertPasien> createState() => _CardLayananVertPasienState();
}

class _CardLayananVertPasienState extends State<CardLayananVertPasien> {
  void _kirimKwitansi(KwitansiSimpan data) {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          onConfirm: () => Navigator.pop(context, data),
          message: 'Anda ingin mengirim kwitansi kepada pasien?',
          labelConfirm: 'Ya, Kirim',
        );
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) async {
      if (value != null) {
        var data = value as KwitansiSimpan;
        var tlp = data.pasien!.nomorTelepon;
        String text =
            'Hai pasien ${data.pasien!.namaPasien}, Tap tautan dibawah untuk mengunduh kwitansi pembayaranmu';
        await WhatsappShare.share(
          text: text,
          linkUrl: Uri.parse('${data.url}').toString(),
          phone: '$tlp',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.blockSizeHorizontal * 42,
      padding: const EdgeInsets.fromLTRB(15.0, 4.0, 15.0, 12.0),
      decoration: BoxDecoration(
        color: kPrimaryColor.withAlpha(30),
        border: Border.all(width: 0.5, color: kPrimaryColor),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: const Icon(
              Icons.account_circle,
              size: 42.0,
            ),
            title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${widget.data.tanggal}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            subtitle: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${widget.data.jam}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#${widget.data.nomorRegistrasi}',
                style: const TextStyle(fontSize: 13.0, color: Colors.grey),
              ),
              Text(
                '${widget.data.namaPasien}',
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => pushScreen(
                context,
                screen: DetailLayananPage(
                  id: widget.data.id!,
                  type: widget.type,
                  role: widget.role,
                ),
                pageTransitionAnimation: PageTransitionAnimation.slideUp,
                withNavBar: false,
              ).then((value) {
                if (value != null) {
                  var data = value as HomeAction;
                  widget.reload();
                  if (data.type == 'final') {
                    _kirimKwitansi(data.data!);
                  }
                }
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
              ),
              child: const Text('Detail'),
            ),
          )
        ],
      ),
    );
  }
}
