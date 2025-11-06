import 'package:admin_dokter_panggil/src/blocs/mr_riwayat_kunjungan_bloc.dart';
import 'package:admin_dokter_panggil/src/models/mr_riwayat_kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/models/pasien_show_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/bullet_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/button_rounded_icon_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/tile_data_card.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/mr_riwayat_detail_page.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/resume_nonmr_page.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:admin_dokter_panggil/src/source/transition/slide_left_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

class MrRiwayatPasien extends StatefulWidget {
  const MrRiwayatPasien({
    super.key,
    this.pasien,
  });

  final Pasien? pasien;

  @override
  State<MrRiwayatPasien> createState() => _MrRiwayatPasienState();
}

class _MrRiwayatPasienState extends State<MrRiwayatPasien> {
  final _mrRiwayatKunjunganBloc = MrRiwayatKunjunganBloc();
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _getRiwayat();
  }

  void _getRiwayat() {
    _mrRiwayatKunjunganBloc.normSink.add(widget.pasien!.norm!);
    _mrRiwayatKunjunganBloc.getRiwayatKunjungan();
  }

  void _showDetail(MrRiwayatKunjungan data) {
    if (data.isEmr!) {
      Navigator.push(
        context,
        SlideLeftRoute(
          page: MrRiwayatDetailPage(
            data: data,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        SlideLeftRoute(
          page: ResumeNonmrPage(
            idKunjungan: data.idKunjungan,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _mrRiwayatKunjunganBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rekam Medis Pasien'),
        backgroundColor: kPrimaryColor,
        centerTitle: false,
      ),
      body: _streamRiwayatKunjungan(context),
    );
  }

  Widget _streamRiwayatKunjungan(BuildContext context) {
    return StreamBuilder<ApiResponse<MrRiwayatKunjunganModel>>(
      stream: _mrRiwayatKunjunganBloc.riwayatKunjunganStream,
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
                  onTap: () {
                    _getRiwayat();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              return ListView.separated(
                controller: _controller,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 22),
                itemBuilder: (context, i) {
                  if (i == snapshot.data!.data!.data!.length) {
                    return SizedBox(
                      height: 42,
                      child: Center(
                        child: SpinKitThreeBounce(
                          color: Colors.grey[400],
                          size: 20,
                        ),
                      ),
                    );
                  }
                  final data = snapshot.data!.data!.data![i];
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3.0),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: data.pasien!.jenisKelamin == 'Perempuan'
                                    ? AssetImage('images/avatar_2_1.png')
                                    : AssetImage('images/avatar_1_1.png'),
                              ),
                            ),
                          ),
                          minLeadingWidth: 32,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            '${data.pasien!.namaPasien}',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Wrap(
                              children: [
                                if (data.isRanap == 1)
                                  TagWrapItem(
                                    title: 'Homecare',
                                  )
                                else if (data.isObservasi == 1)
                                  TagWrapItem(
                                    title: 'Obeservasi',
                                  )
                                else if (data.isHomevisit == 1)
                                  TagWrapItem(
                                    title: 'Homevisit',
                                  )
                                else if (data.isTelemedicine == 1)
                                  TagWrapItem(
                                    title: 'Telemedicine',
                                  )
                                else
                                  TagWrapItem(
                                    title: 'Non EMR',
                                  )
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TileDataCard(
                                title: 'Keluhan',
                                body: Text(data.keluhan ?? '-'),
                              ),
                            ),
                            if (data.isEmr!)
                              Expanded(
                                  child: TileDataCard(
                                title: 'Tanda & Gejala',
                                body: Text('${data.skrining?.skrining}'),
                              ))
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        if (data.dokter!.isNotEmpty)
                          TileDataCard(
                            title: 'Dokter',
                            body: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: data.dokter!
                                  .map(
                                    (dokter) => BulletWidget(
                                      title: '${dokter.nama}',
                                      badge: dokter.isKonsul!
                                          ? Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8),
                                              decoration: BoxDecoration(
                                                  color: kGreenColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          22)),
                                              child: Text(
                                                'Konsul',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                    ),
                                  )
                                  .toList(),
                            ),
                          )
                        else
                          TileDataCard(
                            title: 'Perawat',
                            body: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: data.perawat!
                                  .map(
                                    (perawat) => BulletWidget(
                                      title: '${perawat.nama}',
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        if (data.isEmr!)
                          SizedBox(
                            height: 8,
                          ),
                        if (data.isEmr!)
                          TileDataCard(
                            title: 'Keputusan',
                            body: Text(
                              '${data.skrining?.keputusan}',
                            ),
                          ),
                        SizedBox(
                          height: 8,
                        ),
                        Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${data.tanggal}',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            ButtonRoundedIconWidget(
                              onPressed: () => _showDetail(data),
                              size: Size(120, 42),
                              label: 'Riwayat',
                              color: Colors.green,
                              icon: SvgPicture.asset(
                                'images/calendar.svg',
                                height: 18,
                                colorFilter: ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcATop,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, i) => SizedBox(
                  height: 18,
                ),
                itemCount: snapshot.data!.data!.totalPage !=
                        snapshot.data!.data!.currentPage
                    ? snapshot.data!.data!.data!.length + 1
                    : snapshot.data!.data!.data!.length,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class TagWrapItem extends StatelessWidget {
  const TagWrapItem({
    super.key,
    this.title,
  });

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.deepOrange[50],
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        '$title',
        style: TextStyle(
          color: Colors.deepOrange,
          fontSize: 12,
        ),
      ),
    );
  }
}
