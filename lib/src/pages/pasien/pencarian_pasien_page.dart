import 'dart:async';
import 'dart:io';

import 'package:dokter_panggil/src/blocs/pasien_bloc.dart';
import 'package:dokter_panggil/src/blocs/pasien_filter_bloc.dart';
import 'package:dokter_panggil/src/blocs/pasien_kunjungan_bloc.dart';
import 'package:dokter_panggil/src/blocs/pasien_kunjungan_final_bloc.dart';
import 'package:dokter_panggil/src/blocs/pasien_page_bloc.dart';
import 'package:dokter_panggil/src/blocs/pasien_show_bloc.dart';
import 'package:dokter_panggil/src/models/pasien_filter_model.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_model.dart';
import 'package:dokter_panggil/src/models/pasien_model.dart';
import 'package:dokter_panggil/src/models/pasien_show_model.dart';
import 'package:dokter_panggil/src/pages/components/card_layanan_pasien.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_card_layanan.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/pasien/edit_pasien_page.dart';
import 'package:dokter_panggil/src/pages/pasien/new_riwayat_pasien.dart';
import 'package:dokter_panggil/src/pages/pasien/pendaftaran_layanan_page.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:dokter_panggil/src/source/transition/slide_bottom_route.dart';
import 'package:dokter_panggil/src/source/transition/slide_left_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class PencarianPasianpage extends StatefulWidget {
  const PencarianPasianpage({
    super.key,
  });

  @override
  State<PencarianPasianpage> createState() => _PencarianPasianpageState();
}

class _PencarianPasianpageState extends State<PencarianPasianpage> {
  final PasienPageBloc _pasienPageBloc = PasienPageBloc();
  final PasienFilterBloc _pasienFilterBloc = PasienFilterBloc();
  final _filterCon = TextEditingController();
  final _filterFocus = FocusNode();
  final _tanggal = DateFormat('dd MMM yyyy', 'id');
  bool _isStream = false;
  bool _showPasien = false;
  int? _idPasien;
  bool _isSuperadmin = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _filterCon.addListener(_inputListener);
    _filterPasien();
  }

  void _inputListener() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      _filterPasien();
      timer.cancel();
    });
  }

  void _filterPasien() {
    _pasienFilterBloc.filterSink.add(_filterCon.text);
    _pasienFilterBloc.filterPasien();
    setState(() {
      _isStream = true;
      _showPasien = false;
    });
  }

  void _streamAllPasien() {
    _pasienPageBloc.getPagePasien();
  }

  @override
  void dispose() {
    _filterCon.dispose();
    _filterFocus.dispose();
    _pasienFilterBloc.dispose();
    _pasienPageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 2.0,
                right: 32.0,
                top: MediaQuery.of(context).padding.top + 18,
              ),
              child: Row(
                children: [
                  if (Platform.isAndroid)
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.grey[600],
                      ),
                    )
                  else
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey[600],
                      ),
                    ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  Expanded(
                    child: SearchInputForm(
                      controller: _filterCon,
                      focusNode: _filterFocus,
                      hint: 'Pencarian pasien',
                      suffixIcon: _isStream
                          ? InkWell(
                              onTap: () {
                                _filterFocus.requestFocus(FocusNode());
                                _streamAllPasien();
                                setState(() {
                                  _filterCon.clear();
                                  _isStream = false;
                                });
                              },
                              child: FaIcon(
                                FontAwesomeIcons.circleXmark,
                                size: 20,
                                color: Colors.grey[600],
                              ),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 22.0,
            ),
            _buildStreamFilter(context)
          ],
        ),
      ),
    );
  }

  Widget _buildStreamFilter(BuildContext context) {
    if (_showPasien) {
      return Expanded(
        child: StreamShowPasien(id: _idPasien!, isSuperadmin: _isSuperadmin),
      );
    }
    return StreamBuilder<ApiResponse<ResponsePasienFilterModel>>(
      stream: _pasienFilterBloc.pasienFilterStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const Expanded(
                child: Center(
                  child: LoadingKit(
                    color: kPrimaryColor,
                  ),
                ),
              );
            case Status.error:
              return Expanded(
                child: Center(
                  child: ErrorResponse(
                    message: snapshot.data!.message,
                    button: false,
                  ),
                ),
              );
            case Status.completed:
              return _listPasien(context, snapshot.data!.data!.pasien);
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _listPasien(BuildContext context, List<PasienFilter>? pasien) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12),
            child: Text(
              '${pasien!.length} Hasil pencarian',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemCount: pasien.length,
              itemBuilder: (context, i) {
                var data = pasien[i];
                return ListTile(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    setState(() {
                      _idPasien = data.id;
                      _showPasien = true;
                      _isSuperadmin = data.isSuperadmin!;
                    });
                  },
                  leading: const Icon(Icons.search),
                  title: Text('${data.normPanjang} - ${data.nama}'),
                  subtitle: Text(_tanggal.format(data.tanggalLahir!)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StreamShowPasien extends StatefulWidget {
  const StreamShowPasien({
    super.key,
    required this.id,
    this.isSuperadmin = false,
  });

  final int id;
  final bool isSuperadmin;

  @override
  State<StreamShowPasien> createState() => _StreamShowPasienState();
}

class _StreamShowPasienState extends State<StreamShowPasien> {
  final PasienShowBloc _pasienShowBloc = PasienShowBloc();

  @override
  void initState() {
    super.initState();
    _pasienShowBloc.idSink.add(widget.id);
    _pasienShowBloc.pasienShow();
  }

  @override
  void dispose() {
    _pasienShowBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<PasienShowModel>>(
      stream: _pasienShowBloc.pasienShowStream,
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
              return ErrorResponse(
                message: snapshot.data!.message,
              );
            case Status.completed:
              return PasienWidget(
                data: snapshot.data!.data!.pasien!,
                isSuperadmin: widget.isSuperadmin,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class PasienWidget extends StatefulWidget {
  const PasienWidget({
    super.key,
    required this.data,
    this.isSuperadmin = false,
  });

  final Pasien data;
  final bool isSuperadmin;

  @override
  State<PasienWidget> createState() => _PasienWidgetState();
}

class _PasienWidgetState extends State<PasienWidget> {
  final _pasienBloc = PasienBloc();
  final PasienKunjunganBloc _pasienKunjunganBloc = PasienKunjunganBloc();
  final PasienKunjunganFinalBloc _pasienKunjunganFinalBloc =
      PasienKunjunganFinalBloc();
  final _tanggal = DateFormat('dd MMM yyyy', 'id');
  late Pasien _data;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  void _showRiwayatPendaftarn() {
    showBarModalBottomSheet(
        context: context,
        builder: (context) {
          return LayananFinalPasien(
            norm: _data.norm!,
            bloc: _pasienKunjunganFinalBloc,
          );
        });
  }

  void _edit() {
    Navigator.push(
      context,
      SlideBottomRoute(
          page: EditPasienPage(
        data: _data,
      )),
    ).then((value) {
      if (value != null) {
        var data = value as Pasien;
        _data = data;
        setState(() {});
      }
    });
  }

  void _hapus() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          onConfirm: () => Navigator.pop(context, 'hapus'),
          message: 'Anda yakin menghapus pasien ini?',
        );
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        _pasienBloc.idSink.add(widget.data.id!);
        _pasienBloc.deletePasien();
        _showStreamDelete();
      }
    });
  }

  void _showStreamDelete() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamDelete(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          Navigator.pop(context);
        });
      }
    });
  }

  void _kirimPesan(String? nomorHp) async {
    String text = 'Hai Pasien, kami dari dokter panggil';
    String whatsappURlAndroid = "whatsapp://send?phone=$nomorHp&text=$text";
    String whatappURLIos = "https://wa.me/$nomorHp?text=$text";

    Uri toLaunchIos = Uri.parse(whatappURLIos);
    Uri toLaunchAndroid = Uri.parse(whatsappURlAndroid);
    if (Platform.isIOS) {
      if (await canLaunchUrl(toLaunchIos)) {
        await launchUrl(toLaunchIos);
      } else {
        _snakeBar('message');
      }
    } else {
      if (await canLaunchUrl(toLaunchAndroid)) {
        await launchUrl(toLaunchAndroid);
      } else {
        _snakeBar('Whatsapp is not installed');
      }
    }
  }

  void _snakeBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _profilePasien(_data),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(-2.0, 1.0),
              )
            ],
          ),
          child: ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              SlideLeftRoute(
                page: PendaftaranLayananPage(
                  pasien: _data,
                ),
              ),
            ).then((value) {
              if (value != null) {
                _pasienKunjunganBloc.kunjunganAktif();
                setState(() {});
              }
            }),
            style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                minimumSize: const Size(double.infinity, 45)),
            child: const Text('Daftar Layanan'),
          ),
        ),
      ],
    );
  }

  Widget _profilePasien(Pasien? pasien) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 22.0),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image.asset('images/logo_only.png'),
            ),
            const SizedBox(
              width: 22.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${pasien!.namaPasien}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text('${pasien.jenisKelamin}'),
                  Text('${pasien.umur}'),
                  Text(
                      '${pasien.tempatLahir}, ${_tanggal.format(DateTime.parse(pasien.tanggalLahir!))}'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 22.0,
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _edit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(45),
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Edit'),
              ),
            ),
            const SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: _hapus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size.fromHeight(45),
                ),
                child: const Text('Hapus'),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        ElevatedButton.icon(
          onPressed: () => _kirimPesan('${pasien.nomorTelepon}'),
          icon: const FaIcon(FontAwesomeIcons.whatsapp),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(double.infinity, 45),
          ),
          label: Text('${pasien.nomorTelepon}'),
        ),
        if (widget.isSuperadmin)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(
                  context,
                  SlideBottomRoute(
                    page: NewRiwayatPasien(pasien: pasien),
                  )),
              icon: const FaIcon(FontAwesomeIcons.paste),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                minimumSize: const Size(double.infinity, 45),
              ),
              label: const Text('Resume Medis'),
            ),
          ),
        const SizedBox(
          height: 18.0,
        ),
        const Divider(
          height: 0.0,
          color: Colors.grey,
        ),
        const SizedBox(
          height: 22.0,
        ),
        const Text(
          'Pendaftaran Layanan',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 18.0,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 18.0),
          decoration: BoxDecoration(
              border: Border.all(color: kPrimaryColor, width: 0.5),
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0)),
          child: ListTile(
            onTap: _showRiwayatPendaftarn,
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: const Text('Riwayat pendaftaran layanan'),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
        ),
        const SizedBox(
          height: 18.0,
        ),
        LayananAktifPasien(
          norm: pasien.norm!,
          bloc: _pasienKunjunganBloc,
        ),
      ],
    );
  }

  Widget _streamDelete(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponsePasienModel>>(
      stream: _pasienBloc.pasienStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: Colors.white,
              );
            case Status.error:
              return ErrorResponse(
                message: snapshot.data!.message,
                onTap: () => Navigator.pop(context),
              );
            case Status.completed:
              return SuccessDialog(
                message: snapshot.data!.data!.message,
                onTap: () => Navigator.pop(context, snapshot.data!.data!.data),
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class LayananAktifPasien extends StatefulWidget {
  const LayananAktifPasien({
    super.key,
    required this.norm,
    required this.bloc,
  });

  final String norm;
  final PasienKunjunganBloc bloc;

  @override
  State<LayananAktifPasien> createState() => _LayananAktifPasienState();
}

class _LayananAktifPasienState extends State<LayananAktifPasien> {
  @override
  void initState() {
    super.initState();
    widget.bloc.normSink.add(widget.norm);
    widget.bloc.kunjunganAktif();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StreamBuilder<ApiResponse<PasienKunjunganModel>>(
      stream: widget.bloc.pasienKunjunganStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingCardLayanan(
                itemCount: 2,
              );
            case Status.error:
              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 22.0,
                  horizontal: 18.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    snapshot.data!.message,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              );
            case Status.completed:
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                itemBuilder: (context, i) {
                  var kunjungan = snapshot.data!.data!.kunjungan![i];
                  return CardLayananPasien(
                    kunjungan: kunjungan,
                    type: 'create',
                  );
                },
                separatorBuilder: (context, i) => const SizedBox(
                  height: 15.0,
                ),
                itemCount: snapshot.data!.data!.kunjungan!.length,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class LayananFinalPasien extends StatefulWidget {
  const LayananFinalPasien({
    super.key,
    required this.norm,
    required this.bloc,
  });

  final String norm;
  final PasienKunjunganFinalBloc bloc;

  @override
  State<LayananFinalPasien> createState() => _LayananFinalPasienState();
}

class _LayananFinalPasienState extends State<LayananFinalPasien> {
  @override
  void initState() {
    super.initState();
    widget.bloc.normSink.add(widget.norm);
    widget.bloc.kunjunganFinal();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StreamBuilder<ApiResponse<PasienKunjunganModel>>(
      stream: widget.bloc.pasienKunjunganStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingCardLayanan(
                itemCount: 2,
                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 22.0),
              );
            case Status.error:
              return SizedBox(
                width: double.infinity,
                height: 300,
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  onTap: () => Navigator.pop(context),
                ),
              );
            case Status.completed:
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 18.0, vertical: 32.0),
                    child: Text(
                      'Riwayat kunjungan',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Flexible(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(
                          left: 18.0, right: 18.0, bottom: 32.0),
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        var kunjungan = snapshot.data!.data!.kunjungan![i];
                        return CardLayananPasien(
                          kunjungan: kunjungan,
                          type: 'view',
                        );
                      },
                      separatorBuilder: (context, i) => const SizedBox(
                        height: 15.0,
                      ),
                      itemCount: snapshot.data!.data!.kunjungan!.length,
                    ),
                  ),
                ],
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
