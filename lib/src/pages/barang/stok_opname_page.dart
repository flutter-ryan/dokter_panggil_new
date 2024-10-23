import 'package:dokter_panggil/src/blocs/stok_opname_bloc.dart';
import 'package:dokter_panggil/src/blocs/stok_opname_save_bloc.dart';
import 'package:dokter_panggil/src/models/stok_opname_model.dart';
import 'package:dokter_panggil/src/models/stok_opname_save_model.dart';
import 'package:dokter_panggil/src/pages/barang/form_opname_barang.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/pages/master/laporan/dialog_range_date.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/source/transition/slide_left_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:intl/intl.dart';

class StokOpnamePage extends StatefulWidget {
  const StokOpnamePage({super.key});

  @override
  State<StokOpnamePage> createState() => _StokOpnamePageState();
}

class _StokOpnamePageState extends State<StokOpnamePage> {
  final _stokOpnameSaveBloc = StokOpnameSaveBloc();
  final _controller = ScrollController();
  final _stokOpnameBloc = StokOpnameBloc();
  final _filter = TextEditingController();
  bool _showFab = true;
  DateTime _selectedDate = DateTime.now();
  final _tanggal = DateFormat('dd MMMM yyyy', 'id');
  final _periode = DateFormat('yyyy-MM-dd', 'id');

  @override
  void initState() {
    super.initState();
    _getStokOpname();
  }

  void _getStokOpname() {
    _stokOpnameBloc.getStokOpname();
  }

  void _generateStokOpname() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return const DialogRangeDate();
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var dates = value as List<DateTime?>;
        final from = dates.first;
        final to = dates.last;
        _confirmGenerateStokOpname(from, to);
      }
    });
  }

  void _confirmGenerateStokOpname(DateTime? from, DateTime? to) {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          message:
              'Periode stok opname\n${_tanggal.format(from!)} - ${_tanggal.format(to!)}',
          onConfirm: () => Navigator.pop(context, 'confirm'),
          labelConfirm: 'Konfirmasi',
        );
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _stokOpnameSaveBloc.fromSink.add(_periode.format(from!));
          _stokOpnameSaveBloc.toSink.add(_periode.format(to!));
          _stokOpnameSaveBloc.saveStokOpname();
          _showStreamStokOpnameSave();
        });
      }
    });
  }

  void _showStreamStokOpnameSave() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamStokOpnameSave(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        _getStokOpname();
        setState(() {});
      }
    });
  }

  void _delete(int? id) {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          message: 'Anda yakin ingin menghapus data ini?',
          onConfirm: () => Navigator.pop(context, 'confirm'),
        );
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _stokOpnameSaveBloc.idStokSink.add(id!);
          _stokOpnameSaveBloc.deleteStokOpname();
          _showStreamStokOpnameSave();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _stokOpnameBloc.dispose();
    super.dispose();
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
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    height: MediaQuery.of(context).padding.top + 18,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Stok Opname',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  SearchInputForm(
                    controller: _filter,
                    hint: 'Pencarian stok opname',
                    suffixIcon: _filter.text.isEmpty
                        ? const SizedBox()
                        : CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.grey[300],
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                _filter.clear();
                                setState(() {});
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
              child: _buildStreamStokOpname(context),
            ),
          ],
        ),
        floatingActionButton: AnimatedSlide(
          duration: const Duration(milliseconds: 500),
          offset: _showFab ? Offset.zero : const Offset(0, 2),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: _showFab ? 1 : 0,
            child: FloatingActionButton(
              onPressed: _generateStokOpname,
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStreamStokOpname(BuildContext context) {
    return StreamBuilder<ApiResponse<StokOpnameModel>>(
      stream: _stokOpnameBloc.stokOpnameStream,
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
                  _getStokOpname();
                  setState(() {});
                },
              );
            case Status.completed:
              return ListStokOpname(
                data: snapshot.data!.data!.data,
                bloc: _stokOpnameBloc,
                delete: _delete,
                reload: () {
                  _getStokOpname();
                  setState(() {});
                },
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _streamStokOpnameSave(BuildContext context) {
    return StreamBuilder<ApiResponse<StokOpnameSaveModel>>(
        stream: _stokOpnameSaveBloc.stokOpnameSaveStream,
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
                      Navigator.pop(context, snapshot.data!.data!.data),
                );
            }
          }
          return const SizedBox();
        });
  }
}

class ListStokOpname extends StatefulWidget {
  const ListStokOpname({
    super.key,
    this.data,
    this.reload,
    this.delete,
    required this.bloc,
  });

  final List<StokOpname>? data;
  final VoidCallback? reload;
  final Function(int? id)? delete;
  final StokOpnameBloc bloc;

  @override
  State<ListStokOpname> createState() => _ListStokOpnameState();
}

class _ListStokOpnameState extends State<ListStokOpname> {
  final _tanggal = DateFormat('dd MMMM yyyy', 'id');

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        widget.reload!();
      },
      child: ListView.separated(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 22.0),
        itemBuilder: (context, i) {
          var stok = widget.data![i];
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(2.0, 2.0),
                  )
                ]),
            child: Row(
              children: [
                const SizedBox(
                  width: 18.0,
                ),
                Icon(
                  Icons.document_scanner_outlined,
                  size: 42,
                  color: kPrimaryColor.withAlpha(180),
                ),
                Expanded(
                  child: ListTile(
                    onTap: () => Navigator.push(
                      context,
                      SlideLeftRoute(
                        page: FormOpnameBarang(
                          data: stok,
                          bloc: widget.bloc,
                        ),
                      ),
                    ).then((value) {
                      if (value != null) {
                        widget.reload!();
                      }
                    }),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 22.0,
                      vertical: 4.0,
                    ),
                    title: Text(
                        '${_tanggal.format(stok.fromDate!)} - ${_tanggal.format(stok.toDate!)}'),
                    subtitle: Text('${stok.kodeStok}'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, i) => const SizedBox(
          height: 18,
        ),
        itemCount: widget.data!.length,
      ),
    );
  }
}
