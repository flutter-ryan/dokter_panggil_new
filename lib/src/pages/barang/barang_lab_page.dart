import 'dart:async';

import 'package:dokter_panggil/src/blocs/master_barang_lab_bloc.dart';
import 'package:dokter_panggil/src/models/master_barang_lab_model.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';

class BarangLabPage extends StatefulWidget {
  const BarangLabPage({super.key});

  @override
  State<BarangLabPage> createState() => _BarangLabPageState();
}

class _BarangLabPageState extends State<BarangLabPage> {
  final _masterBarangLabBloc = MasterBarangLabBloc();
  final _filter = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getMasterBarangLab();
  }

  void _getMasterBarangLab() {
    _masterBarangLabBloc.getBarangLab();
  }

  void _hapus(int idBarangLab) {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          onConfirm: () => Navigator.pop(context, 'confirm'),
        );
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _masterBarangLabBloc.barangLabSink.add(idBarangLab);
          _masterBarangLabBloc.deleteBarangLab();
          _showStreamResponseBarangLab();
        });
      }
    });
  }

  void _showStreamResponseBarangLab() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamResponseBarangLab(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              decoration: const BoxDecoration(color: kPrimaryColor, boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(2.0, 1.0),
                )
              ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top + 12,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Barang Laboratorium',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.close_rounded),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  SearchInputForm(
                    controller: _filter,
                    hint: 'Pencarian barang',
                    suffixIcon: _filter.text.isEmpty
                        ? const SizedBox()
                        : CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.grey[300],
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                //
                              },
                              iconSize: 18,
                              color: Colors.black38,
                              icon: const Icon(Icons.close),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 22.0,
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildStreamBarangWidget(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _streamResponseBarangLab(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseMasterBarangLabModel>>(
      stream: _masterBarangLabBloc.masterBarangLabSaveStream,
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
                onTap: () => Navigator.pop(context),
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildStreamBarangWidget(BuildContext context) {
    return StreamBuilder<ApiResponse<List<MasterBarangLab>>>(
      stream: _masterBarangLabBloc.masterBarangLabStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: kPrimaryColor,
              );
            case Status.error:
              return ErrorResponse(
                message: snapshot.data!.message,
                onTap: () {
                  _getMasterBarangLab();
                  setState(() {});
                },
              );
            case Status.completed:
              return ListView.separated(
                padding: const EdgeInsets.all(32),
                itemBuilder: (context, i) {
                  var barang = snapshot.data!.data![i];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8.0,
                          offset: Offset(2.0, 1.0),
                        )
                      ],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('${barang.barang!.namaBarang}'),
                          subtitle:
                              Text('${barang.tindakanLab!.namaTindakanLab}'),
                        ),
                        Divider(
                          height: 0.0,
                          color: Colors.grey[300],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () => _hapus(barang.id!),
                                label: const Text('Hapus'),
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.red),
                                icon: const Icon(
                                  Icons.delete,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 45,
                              child: VerticalDivider(
                                color: Colors.grey[300],
                                width: 0.0,
                              ),
                            ),
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () {},
                                label: const Text('Edit'),
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.blue),
                                icon: const Icon(Icons.edit_rounded),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, i) => const SizedBox(
                  height: 18.0,
                ),
                itemCount: snapshot.data!.data!.length,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
