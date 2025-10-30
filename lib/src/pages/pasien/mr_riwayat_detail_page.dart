import 'package:admin_dokter_panggil/src/blocs/mr_riwayat_detail_bloc.dart';
import 'package:admin_dokter_panggil/src/models/mr_riwayat_detail_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_riwayat_kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_detail_riwayat.dart';
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
  final _mrRiwayatdetailBloc = MrRiwayatDetailBloc();

  @override
  void initState() {
    super.initState();
    _getDetail();
  }

  void _getDetail() {
    _mrRiwayatdetailBloc.idKunjunganSink.add(widget.data!.idKunjungan!);
    _mrRiwayatdetailBloc.getRiwayatDetail();
  }

  @override
  void dispose() {
    _mrRiwayatdetailBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat pasien',
        ),
        centerTitle: false,
        foregroundColor: Colors.black,
        backgroundColor: kBgRedLightColor,
        systemOverlayStyle: kSystemOverlayLight,
        elevation: 0,
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
    return StreamBuilder<ApiResponse<MrRiwayatDetailModel>>(
      stream: _mrRiwayatdetailBloc.riwayatDetailStream,
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
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(color: kBgRedLightColor),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 32),
                      leading: SvgPicture.asset('images/calendar.svg'),
                      visualDensity: VisualDensity.compact,
                      title: Text('${widget.data!.tanggal}'),
                      minLeadingWidth: 12,
                    ),
                  ),
                  Expanded(
                    child: DetailRiwayatPasien(
                      data: snapshot.data!.data!.data,
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

class DetailRiwayatPasien extends StatefulWidget {
  const DetailRiwayatPasien({
    super.key,
    this.data,
  });

  final MrRiwayatDetail? data;

  @override
  State<DetailRiwayatPasien> createState() => _DetailRiwayatPasienState();
}

class _DetailRiwayatPasienState extends State<DetailRiwayatPasien>
    with SingleTickerProviderStateMixin {
  MrRiwayatDetail? _detailRiwayat;
  late TabController _controller;
  final List<TabTileModel> _listTab = [];

  @override
  void initState() {
    super.initState();
    _detailRiwayat = widget.data;
    _initRiwayatTab();
  }

  void _initRiwayatTab() {
    _listTab.clear();
    _listTab.add(TabTileModel(id: 0, title: 'Mr.0', subtitle: 'Screening'));
    if (_detailRiwayat!.mr1! && !_detailRiwayat!.mr3!) {
      _listTab.add(
        TabTileModel(id: 2, title: 'Mr.1', subtitle: 'Pengkajian Telemedicine'),
      );
    }
    if (_detailRiwayat!.mr2!) {
      _listTab.add(
        TabTileModel(id: 3, title: 'Mr.2', subtitle: 'Resume Medis'),
      );
    }
    if (_detailRiwayat!.mr3!) {
      _listTab.add(
        TabTileModel(id: 4, title: 'Mr.3', subtitle: 'Pengkajian Dokter'),
      );
    }
    if (_detailRiwayat!.mr4!) {
      _listTab.add(
        TabTileModel(id: 5, title: 'Mr.4', subtitle: 'Pengkajian Perawat'),
      );
    }
    if (_detailRiwayat!.mr5!) {
      _listTab.add(
        TabTileModel(id: 6, title: 'Mr.5', subtitle: 'Discharge Planning'),
      );
    }
    if (_detailRiwayat!.mr6!) {
      _listTab.add(
        TabTileModel(id: 7, title: 'Mr.6', subtitle: 'CPPT'),
      );
    }
    if (_detailRiwayat!.mr7!) {
      _listTab.add(
        TabTileModel(
            id: 8, title: 'Mr.7', subtitle: 'Impelementasi Keperawatan'),
      );
    }
    if (_detailRiwayat!.mr8!) {
      _listTab.add(
        TabTileModel(id: 9, title: 'Mr.8', subtitle: 'Observasi Komprehensif'),
      );
    }
    if (_detailRiwayat!.mr9!) {
      _listTab.add(
        TabTileModel(id: 10, title: 'Mr.9', subtitle: 'Daftar Pengobatan'),
      );
    }
    if (_detailRiwayat!.mr10!) {
      _listTab.add(
        TabTileModel(id: 12, title: 'Mr.10', subtitle: 'Formulir Edukasi'),
      );
    }
    if (_detailRiwayat!.mr11!) {
      _listTab.add(
        TabTileModel(id: 13, title: 'Mr.11', subtitle: 'Consent Tindakan'),
      );
    }
    if (_detailRiwayat!.mr12!) {
      _listTab.add(
        TabTileModel(
            id: 14, title: 'Mr.12', subtitle: 'Tindakan Anestesi Bedah'),
      );
    }
    if (_detailRiwayat!.mr13!) {
      _listTab.add(
        TabTileModel(id: 15, title: 'Mr.13', subtitle: 'Rujukan'),
      );
    }
    if (_detailRiwayat!.mr14!) {
      _listTab.add(
        TabTileModel(id: 16, title: 'Mr.14', subtitle: 'Timbang Terima'),
      );
    }
    if (_detailRiwayat!.mr15!) {
      _listTab.add(
        TabTileModel(id: 17, title: 'Mr.15', subtitle: 'Penghentian Layanan'),
      );
    }
    _listTab.sort((a, b) => a.id!.compareTo(b.id!));
    _controller = TabController(length: _listTab.length, vsync: this);
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
              ..._listTab.map(
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
              ..._listTab.map(
                (tab) => MrBodyRiwayatWidget(
                  tileModel: tab,
                  data: _detailRiwayat,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class TabTileModel {
  TabTileModel({
    this.id,
    this.title,
    this.subtitle,
    this.isShow = true,
    this.page,
    this.color,
    this.textColor,
  });
  final int? id;
  final String? title;
  final String? subtitle;
  final bool isShow;
  final Widget? page;
  final Color? color;
  final Color? textColor;
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
