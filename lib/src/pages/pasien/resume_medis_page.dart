import 'package:dokter_panggil/src/blocs/resume_medis_pasien_bloc.dart';
import 'package:dokter_panggil/src/models/kunjungan_pasien_resume_model.dart';
import 'package:dokter_panggil/src/models/resume_medis_pasien_model.dart';
import 'package:dokter_panggil/src/pages/pasien/resume_pemeriksaan_pasien_page.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';

class ResumeMedisPage extends StatefulWidget {
  const ResumeMedisPage({
    super.key,
    required this.data,
  });

  final KunjunganPasienResume? data;

  @override
  State<ResumeMedisPage> createState() => _ResumeMedisPageState();
}

class _ResumeMedisPageState extends State<ResumeMedisPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final _resumeMedisPasienbloc = ResumeMedisPasienBloc();

  @override
  void initState() {
    super.initState();
    _getResumeMedis();
    _tabController =
        TabController(length: widget.data!.petugas!.length, vsync: this);
  }

  void _getResumeMedis() {
    _resumeMedisPasienbloc.idKunjunganSink.add(widget.data!.id!);
    _resumeMedisPasienbloc.getResumeMedis();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              elevation: 0,
              pinned: true,
              floating: true,
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              expandedHeight: 110,
              centerTitle: true,
              title: const Text('Resume Medis'),
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4.0,
                        children: [
                          const Icon(
                            Icons.calendar_month_rounded,
                            size: 22.0,
                          ),
                          Text(
                            '${widget.data!.tanggalKunjungan}',
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 18.0,
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  unselectedLabelColor: Colors.grey[300],
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Colors.white,
                  isScrollable: true,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  indicatorWeight: 2.5,
                  unselectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.normal),
                  tabs: widget.data!.petugas!
                      .map(
                        (petugas) => Tab(text: '${petugas.nama}'),
                      )
                      .toList(),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: widget.data!.petugas!
              .map(
                (petugas) => ResumePemeriksaanPasienPage(
                  idKunjungan: widget.data!.id!,
                  idPetugas: petugas.id!,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: const BoxDecoration(color: kPrimaryColor, boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2.0))
      ]),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class ResumeMedisPasien extends StatefulWidget {
  const ResumeMedisPasien({
    super.key,
    required this.data,
  });

  final ResumeMedis? data;

  @override
  State<ResumeMedisPasien> createState() => _ResumeMedisPasienState();
}

class _ResumeMedisPasienState extends State<ResumeMedisPasien> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 22),
      children: [
        if (widget.data!.kunjunganTindakan!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 22.0),
            child: CardResumePasien(
              title: 'Tindakan',
              data: Column(
                children: ListTile.divideTiles(
                        context: context,
                        tiles: widget.data!.kunjunganTindakan!
                            .map(
                              (tindakan) => ListTile(
                                title: Text('${tindakan.namaTindakan}'),
                                subtitle: Text('${tindakan.dokter!.nama}'),
                              ),
                            )
                            .toList())
                    .toList(),
              ),
            ),
          ),
        if (widget.data!.kunjunganAnamnesaDokter!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 22.0),
            child: CardResumePasien(
              title: 'Anamesa',
              data: Column(
                children: ListTile.divideTiles(
                        context: context,
                        tiles: widget.data!.kunjunganAnamnesaDokter!
                            .map(
                              (anamnesa) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Text(
                                      '${anamnesa.dokter!.nama}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  WrapBody(
                                    title: 'Keluhan',
                                    subtitle: '${anamnesa.keluhanUtama}',
                                  ),
                                  WrapBody(
                                    title: 'Riwayat penyakit sebelumnya',
                                    subtitle:
                                        '${anamnesa.riwayatPenyakitSebelumnya}',
                                  ),
                                  WrapBody(
                                    title: 'Riwayat penyakit sekarang',
                                    subtitle:
                                        '${anamnesa.riwayatPenyakitSekarang}',
                                  ),
                                  const SizedBox(
                                    height: 12.0,
                                  )
                                ],
                              ),
                            )
                            .toList())
                    .toList(),
              ),
            ),
          ),
        if (widget.data!.kunjunganAnamnesaPerawat != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 22.0),
            child: CardResumePasien(
              title: 'Anamnesa perawat',
              data: Column(
                children: widget.data!.kunjunganAnamnesaPerawat!
                    .map(
                      (anamnesa) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              '${anamnesa.perawat!.nama}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          WrapBody(
                            title: 'Keluhan',
                            subtitle: '${anamnesa.keluhanUtama}',
                          ),
                          WrapBody(
                            title: 'Riwayat penyakit sebelumnya',
                            subtitle: '${anamnesa.riwayatPenyakitSebelumnya}',
                          ),
                          WrapBody(
                            title: 'Riwayat penyakit sekarang',
                            subtitle: '${anamnesa.riwayatPenyakitSekarang}',
                          ),
                          const SizedBox(
                            height: 12.0,
                          )
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        if (widget.data!.kunjunganPemeriksaanFisikDokter!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 22.0),
            child: CardResumePasien(
              title: 'Pemeriksaan Fisik Dokter',
              data: Column(
                children: ListTile.divideTiles(
                        context: context,
                        tiles: widget.data!.kunjunganPemeriksaanFisikDokter!
                            .map(
                              (fisik) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Text(
                                      '${fisik.pegawai!.nama}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // subtitle: Text('${tindakan.dokter!.nama}'),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: WrapBody(
                                          title: 'Tekanan Darah',
                                          subtitle:
                                              '${fisik.tekananDarah} mmHg',
                                        ),
                                      ),
                                      Expanded(
                                        child: WrapBody(
                                          title: 'Nadi',
                                          subtitle: '${fisik.nadi} kali/menit',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: WrapBody(
                                          title: 'Pernafasan',
                                          subtitle:
                                              '${fisik.pernafasan} kali/menit',
                                        ),
                                      ),
                                      Expanded(
                                        child: WrapBody(
                                          title: 'Suhu',
                                          subtitle: '${fisik.suhu} C',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: WrapBody(
                                          title: 'Berat Badan',
                                          subtitle: '${fisik.beratBadan} kg',
                                        ),
                                      ),
                                      Expanded(
                                        child: WrapBody(
                                          title: 'Tinggi Badan',
                                          subtitle: '${fisik.tinggiBadan} cm',
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (fisik.catatan != null)
                                    WrapBody(
                                      title: 'Catatan',
                                      subtitle: '${fisik.catatan}',
                                    ),
                                  const SizedBox(
                                    height: 12.0,
                                  )
                                ],
                              ),
                            )
                            .toList())
                    .toList(),
              ),
            ),
          ),
        if (widget.data!.kunjunganPemeriksaanFisikPerawat != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 22.0),
            child: CardResumePasien(
                title: 'Pemeriksaan Fisik Perawat',
                data: Column(
                  children: widget.data!.kunjunganPemeriksaanFisikPerawat!
                      .map(
                        (pemeriksaanFisikPerawat) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                '${pemeriksaanFisikPerawat.perawat!.nama}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: WrapBody(
                                    title: 'Tekanan Darah',
                                    subtitle:
                                        '${pemeriksaanFisikPerawat.tekananDarah} mmHg',
                                  ),
                                ),
                                Expanded(
                                  child: WrapBody(
                                    title: 'Nadi',
                                    subtitle:
                                        '${pemeriksaanFisikPerawat.nadi} kali/menit',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: WrapBody(
                                    title: 'Pernafasan',
                                    subtitle:
                                        '${pemeriksaanFisikPerawat.pernafasan} kali/menit',
                                  ),
                                ),
                                Expanded(
                                  child: WrapBody(
                                    title: 'Suhu',
                                    subtitle:
                                        '${pemeriksaanFisikPerawat.suhu} C',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: WrapBody(
                                    title: 'Berat Badan',
                                    subtitle:
                                        '${pemeriksaanFisikPerawat.beratBadan} kg',
                                  ),
                                ),
                                Expanded(
                                  child: WrapBody(
                                    title: 'Tinggi Badan',
                                    subtitle:
                                        '${pemeriksaanFisikPerawat.tinggiBadan} cm',
                                  ),
                                ),
                              ],
                            ),
                            if (pemeriksaanFisikPerawat.catatan != null)
                              WrapBody(
                                title: 'Catatan',
                                subtitle: '${pemeriksaanFisikPerawat.catatan}',
                              ),
                            const SizedBox(
                              height: 12.0,
                            )
                          ],
                        ),
                      )
                      .toList(),
                )),
          ),
        if (widget.data!.resep!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 22.0),
            child: CardResumePasien(
              title: 'Resep',
              data: Column(
                children: ListTile.divideTiles(
                        context: context,
                        tiles: widget.data!.resep!
                            .map(
                              (resep) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Text(
                                      '${resep.barang}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // subtitle: Text('${tindakan.dokter!.nama}'),
                                  ),
                                ],
                              ),
                            )
                            .toList())
                    .toList(),
              ),
            ),
          ),
      ],
    );
  }
}

class WrapBody extends StatelessWidget {
  const WrapBody({
    super.key,
    this.title,
    this.subtitle,
  });
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title',
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(
            height: 6.0,
          ),
          Text('$subtitle')
        ],
      ),
    );
  }
}

class CardResumePasien extends StatelessWidget {
  const CardResumePasien({
    super.key,
    this.title,
    required this.data,
  });

  final Widget data;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(2.0, 2.0),
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              '$title',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(
            height: 0,
            color: Colors.grey,
          ),
          data,
        ],
      ),
    );
  }
}
