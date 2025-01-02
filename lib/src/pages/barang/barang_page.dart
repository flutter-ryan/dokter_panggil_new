import 'dart:async';

import 'package:dokter_panggil/src/blocs/barang_fetch_bloc.dart';
import 'package:dokter_panggil/src/blocs/bhp_stock_bloc.dart';
import 'package:dokter_panggil/src/blocs/master_bhp_bloc.dart';
import 'package:dokter_panggil/src/models/barang_fetch_model.dart';
import 'package:dokter_panggil/src/models/bhp_stock_model.dart';
import 'package:dokter_panggil/src/models/master_bhp_model.dart';
import 'package:dokter_panggil/src/pages/barang/barang_lab_page.dart';
import 'package:dokter_panggil/src/pages/barang/list_tindakan_barang_lab.dart';
import 'package:dokter_panggil/src/pages/barang/stok_opname_page.dart';
import 'package:dokter_panggil/src/pages/barang/tambah_barang_page.dart';
import 'package:dokter_panggil/src/pages/components/confirm_dialog.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class Barangpage extends StatefulWidget {
  const Barangpage({
    super.key,
    required this.role,
  });

  final int role;

  @override
  State<Barangpage> createState() => _BarangpageState();
}

class _BarangpageState extends State<Barangpage> {
  final _barangFetchBloc = BarangFetchBloc();
  final _filterCon = TextEditingController();
  Timer? _timer;

  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    _barangFetchBloc.fetchBarang();
    _filterCon.addListener(_filterListen);
  }

  void _reload() {
    _filterCon.clear();
    _barangFetchBloc.fetchBarang();
    if (mounted) setState(() {});
  }

  void _filterListen() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _barangFetchBloc.filterSink.add(_filterCon.text);
      _barangFetchBloc.fetchBarang();
      _timer?.cancel();
      setState(() {});
    });
  }

  void _nexPage() {
    _barangFetchBloc.fetchNextBarang();
  }

  @override
  void dispose() {
    _barangFetchBloc.dispose();
    _filterCon.removeListener(_filterListen);
    _filterCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 500);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            final ScrollDirection direction = notification.direction;
            if (notification.metrics.pixels ==
                notification.metrics.maxScrollExtent) {
              _nexPage();
            }
            setState(() {
              if (direction == ScrollDirection.reverse) {
                _showFab = false;
              } else if (direction == ScrollDirection.forward) {
                _showFab = true;
              }
            });
            return true;
          },
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                decoration:
                    const BoxDecoration(color: kPrimaryColor, boxShadow: [
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
                            'Apotek Mentari',
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.transparent,
                          child: IconButton(
                            onPressed: () => pushScreen(
                              context,
                              screen: const BarangLabPage(),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.slideUp,
                            ),
                            padding: EdgeInsets.zero,
                            icon: SvgPicture.asset(
                              'images/lab.svg',
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        if (widget.role == 99 || widget.role == 4)
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            child: IconButton(
                              onPressed: () => pushScreen(
                                context,
                                screen: const StokOpnamePage(),
                                withNavBar: false,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.slideUp,
                              ),
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.paste),
                            ),
                          )
                      ],
                    ),
                    const SizedBox(
                      height: 18.0,
                    ),
                    SearchInputForm(
                      controller: _filterCon,
                      hint: 'Pencarian barang',
                      suffixIcon: _filterCon.text.isEmpty
                          ? const SizedBox()
                          : CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.grey[300],
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  _filterCon.clear();
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
                child: _buildStreamBarang(),
              )
            ],
          ),
        ),
        floatingActionButton: widget.role != 99
            ? null
            : AnimatedSlide(
                duration: duration,
                offset: _showFab ? Offset.zero : const Offset(0, 2),
                child: AnimatedOpacity(
                  duration: duration,
                  opacity: _showFab ? 1 : 0,
                  child: FloatingActionButton(
                    onPressed: () => pushScreen(
                      context,
                      screen: const TambahBarangPage(
                        form: 'add',
                      ),
                      withNavBar: false,
                      pageTransitionAnimation: PageTransitionAnimation.slideUp,
                    ).then((value) {
                      if (value != null) {
                        _reload();
                      }
                    }),
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    child: const Icon(Icons.add),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildStreamBarang() {
    return StreamBuilder<ApiResponse<BarangFetchModel>>(
      stream: _barangFetchBloc.barangFetchStream,
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
                onTap: _reload,
              );
            case Status.completed:
              return ListBarang(
                barang: snapshot.data!.data!.barang,
                totalPage: snapshot.data!.data!.totalPage,
                currentPage: snapshot.data!.data!.currentPage,
                reload: _reload,
                role: widget.role,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListBarang extends StatefulWidget {
  const ListBarang({
    super.key,
    required this.barang,
    this.currentPage,
    this.totalPage,
    this.reload,
    this.role,
  });

  final List<Barang>? barang;
  final VoidCallback? reload;
  final int? currentPage;
  final int? totalPage;
  final int? role;

  @override
  State<ListBarang> createState() => _ListBarangState();
}

class _ListBarangState extends State<ListBarang> {
  final MasterBhpBloc _masterBhpBloc = MasterBhpBloc();
  final BhpStockBloc _bhpStockBloc = BhpStockBloc();
  final _formKey = GlobalKey<FormState>();
  final _rupiah =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);
  String? _jumlah;

  @override
  void initState() {
    super.initState();
  }

  bool validateAndSave() {
    var formData = _formKey.currentState;
    if (formData!.validate()) {
      formData.save();
      return true;
    }
    return false;
  }

  void _inputStock(Barang data) {
    showBarModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (ctx) {
        return _formInputStock(data, ctx);
      },
    ).then((value) {
      if (value != null) {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        if (!mounted) return;
        FocusScope.of(context).requestFocus(FocusNode());
        _bhpStockBloc.idSink.add(data.id!);
        _bhpStockBloc.jumlahSink.add(_jumlah!);
        _bhpStockBloc.tambahStockBhp();
        _showStreamStock();
      }
    });
  }

  void _showStreamStock() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _streamStock(context);
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 500),
    ).then((value) {
      if (value != null) {
        widget.reload!();
      }
    });
  }

  void _hapus(int? id) {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          message: 'Anda yakin menghapus data ini?',
          onConfirm: () => Navigator.pop(context, id),
        );
      },
      duration: const Duration(milliseconds: 300),
    ).then((value) {
      if (value != null) {
        var id = value as int;
        _masterBhpBloc.idSink.add(id);
        _masterBhpBloc.deleteMasterBhp();
        _showStreamDelete();
      }
    });
  }

  void _showStreamDelete() {
    showDialog(
      context: context,
      builder: (context) {
        return _buidlStreamBhpDelete();
      },
    ).then((value) {
      if (value != null) {
        widget.reload!();
      }
    });
  }

  void _selectTindakan(Barang barang) {
    showMaterialModalBottomSheet(
        context: context,
        useRootNavigator: true,
        builder: (context) {
          return ListTindakanBarangLab(barang: barang);
        });
  }

  @override
  void dispose() {
    _masterBhpBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        widget.reload!();
      },
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 22.0),
        itemCount: widget.currentPage != widget.totalPage
            ? widget.barang!.length + 1
            : widget.barang!.length,
        itemBuilder: (context, i) {
          return i >= widget.barang!.length
              ? const SizedBox(
                  height: 40,
                  child: SpinKitThreeBounce(
                    size: 20,
                    color: kPrimaryColor,
                  ),
                )
              : _listBarang(context, widget.barang![i]);
        },
        separatorBuilder: (context, i) => const SizedBox(
          height: 22.0,
        ),
      ),
    );
  }

  Widget _listBarang(BuildContext context, Barang data) {
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
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22.0),
            child: Row(
              children: [
                Expanded(
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(right: 8.0),
                    title: Text('${data.namaBarang}'),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Icon(
                                Icons.arrow_circle_up_rounded,
                                color: Colors.green,
                                size: 18.0,
                              ),
                              const SizedBox(
                                width: 4.0,
                              ),
                              Text(
                                '${data.stockMasuk}',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 22.0,
                          ),
                          Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.center,
                            runAlignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Icon(
                                Icons.arrow_circle_down_rounded,
                                color: Colors.red,
                                size: 18.0,
                              ),
                              const SizedBox(
                                width: 4.0,
                              ),
                              Text(
                                '${data.stockKeluar}',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                if (data.stock != null)
                  Text(
                    '${data.stock!.currentStock}',
                    style: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  )
                else
                  const Text(
                    '0',
                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.green),
                  )
              ],
            ),
          ),
          Divider(
            height: 0.0,
            color: Colors.grey[300],
          ),
          Row(
            children: [
              if (widget.role == 99)
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _hapus(data.id),
                    label: const Text('Hapus'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    icon: const Icon(
                      Icons.delete,
                    ),
                  ),
                ),
              if (widget.role == 99)
                SizedBox(
                  height: 45,
                  child: VerticalDivider(
                    color: Colors.grey[300],
                    width: 0.0,
                  ),
                ),
              if (widget.role == 4 || widget.role == 99)
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _inputStock(data),
                    label: const Text('Stok'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green,
                    ),
                    icon: const Icon(Icons.token),
                  ),
                ),
              if (widget.role == 4 || widget.role == 99)
                SizedBox(
                  height: 45,
                  child: VerticalDivider(
                    color: Colors.grey[300],
                    width: 0.0,
                  ),
                ),
              Expanded(
                child: TextButton.icon(
                  onPressed: () => _selectTindakan(data),
                  label: const Text('Lab'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.orange,
                  ),
                  icon: SvgPicture.asset(
                    'images/lab.svg',
                    colorFilter:
                        const ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                  ),
                ),
              ),
              if (widget.role == 99)
                SizedBox(
                  height: 45,
                  child: VerticalDivider(
                    color: Colors.grey[300],
                    width: 0.0,
                  ),
                ),
              if (widget.role == 99)
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => pushScreen(
                      context,
                      screen: TambahBarangPage(
                        form: 'edit',
                        barang: data,
                      ),
                      withNavBar: false,
                      pageTransitionAnimation: PageTransitionAnimation.slideUp,
                    ).then((value) {
                      if (value != null) {
                        widget.reload!();
                      }
                    }),
                    label: const Text('Edit'),
                    style: TextButton.styleFrom(foregroundColor: Colors.blue),
                    icon: const Icon(Icons.edit_rounded),
                  ),
                )
            ],
          )
        ],
      ),
    );
  }

  Widget _formInputStock(Barang data, BuildContext ctx) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 22.0),
          shrinkWrap: true,
          children: [
            const Text(
              'Input stok',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22.0),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${data.namaBarang}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                Text(_rupiah.format(data.hargaJual)),
              ],
            ),
            const SizedBox(
              height: 22.0,
            ),
            Input(
              label: 'Jumlah',
              hint: 'Jumlah barang/obat',
              maxLines: 1,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Input Required';
                }
                return null;
              },
              keyType: TextInputType.number,
              onSave: (value) => _jumlah = value,
            ),
            const SizedBox(
              height: 32.0,
            ),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (validateAndSave()) {
                    Navigator.of(ctx).pop('tambah stok');
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
                child: const Text('Tambah Stok'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buidlStreamBhpDelete() {
    return StreamBuilder<ApiResponse<ResponseMasterBhpModel>>(
      stream: _masterBhpBloc.masterBhpStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: Colors.white,
              );
            case Status.error:
              return ErrorDialog(message: snapshot.data!.message);
            case Status.completed:
              return SuccessDialog(
                message: snapshot.data!.data!.message,
                onTap: () =>
                    Navigator.pop(context, snapshot.data!.data!.masterBhp!),
              );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _streamStock(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseBhpStockModel>>(
      stream: _bhpStockBloc.bhpStockStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: Colors.white,
              );
            case Status.error:
              return ErrorDialog(message: snapshot.data!.message);
            case Status.completed:
              return SuccessDialog(
                message: snapshot.data!.data!.message,
                onTap: () => Navigator.pop(context, 'sukses'),
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
