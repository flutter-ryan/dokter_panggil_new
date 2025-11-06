import 'package:admin_dokter_panggil/src/blocs/mr_menu_bloc.dart';
import 'package:admin_dokter_panggil/src/models/mr_menu_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_riwayat_kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/close_button_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_pasien/mr_body_riwayat_widget.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MrRiwayatDetailPage extends StatefulWidget {
  const MrRiwayatDetailPage({
    super.key,
    this.data,
  });

  final MrRiwayatKunjungan? data;

  @override
  State<MrRiwayatDetailPage> createState() => _MrRiwayatDetailPageState();
}

class _MrRiwayatDetailPageState extends State<MrRiwayatDetailPage> {
  final _mrMenuBloc = MrMenuBloc();

  @override
  void initState() {
    super.initState();
    _getMenu();
  }

  void _getMenu() {
    _mrMenuBloc.idKunjunganSink.add(widget.data!.idKunjungan!);
    _mrMenuBloc.getMrMenu();
  }

  @override
  void dispose() {
    _mrMenuBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              'images/calendar.svg',
              height: 24,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                '${widget.data!.tanggal}',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        leadingWidth: 12,
        leading: Container(),
        centerTitle: false,
        foregroundColor: Colors.black,
        backgroundColor: kBgRedLightColor,
        systemOverlayStyle: kSystemOverlayLight,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CloseButtonWidget(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 28),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    widget.data!.pasien!.jk == 1
                        ? 'images/avatar_1_1.png'
                        : 'images/avatar_2_1.png',
                    height: 55,
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                    child: ListTile(
                  title: Text(
                    '${widget.data!.pasien!.namaPasien}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        '${widget.data!.pasien!.umur}',
                        style:
                            const TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 28.0,
                      ),
                      Text(
                        '${widget.data!.pasien!.jenisKelamin}',
                        style:
                            const TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
      body: _buildStreamRiwayatDetail(context),
    );
  }

  Widget _buildStreamRiwayatDetail(BuildContext context) {
    return StreamBuilder<ApiResponse<List<MrMenu>>>(
      stream: _mrMenuBloc.mrMenuStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return Center(
                child: LoadingKit(
                  color: kPrimaryColor,
                ),
              );
            case Status.error:
              return Center(
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  onTap: () => Navigator.pop(context),
                ),
              );
            case Status.completed:
              return DetailRiwayatPasien(
                data: snapshot.data!.data,
                riwayatKunjungan: widget.data,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class DetailRiwayatPasien extends StatefulWidget {
  const DetailRiwayatPasien({
    super.key,
    this.data,
    this.riwayatKunjungan,
  });

  final List<MrMenu>? data;
  final MrRiwayatKunjungan? riwayatKunjungan;

  @override
  State<DetailRiwayatPasien> createState() => _DetailRiwayatPasienState();
}

class _DetailRiwayatPasienState extends State<DetailRiwayatPasien>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  List<MrMenu> _menus = [];

  @override
  void initState() {
    super.initState();
    _initMenu();
  }

  void _initMenu() {
    _menus = widget.data!.where((menu) => menu.visible).toList();
    _controller = TabController(length: _menus.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            color: kBgRedLightColor,
            border: Border(
              top: BorderSide(color: Colors.grey[300]!, width: 0.5),
            ),
          ),
          child: TabBar(
            controller: _controller,
            isScrollable: true,
            indicatorColor: kPrimaryColor,
            labelColor: Colors.black,
            unselectedLabelColor: kTextGreyLightColor,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 2,
            labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
            tabs: [
              ..._menus.map(
                (tab) => TabCustomWidget(
                  title: tab.title,
                  subtitle: tab.subtitle,
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: [
              ..._menus.map(
                (tab) => MrBodyRiwayatWidget(
                  tileModel: tab,
                  riwayatKunjungan: widget.riwayatKunjungan,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class TabCustomWidget extends StatelessWidget {
  const TabCustomWidget({
    super.key,
    this.title,
    this.subtitle,
    this.color,
    this.textColor,
  });

  final String? title;
  final String? subtitle;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Tab(
        iconMargin: const EdgeInsets.only(bottom: 2, top: 2),
        icon: Text(
          '$title',
          style: TextStyle(fontSize: 13.0),
        ),
        child: Text(
          '$subtitle',
          style: TextStyle(
            fontSize: 11.0,
          ),
        ),
      ),
    );
  }
}
