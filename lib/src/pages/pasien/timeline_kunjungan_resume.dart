import 'package:admin_dokter_panggil/src/models/kunjungan_pasien_resume_model.dart';
import 'package:admin_dokter_panggil/src/pages/pasien/resume_medis_page.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:admin_dokter_panggil/src/source/transition/slide_left_route.dart';
import 'package:flutter/material.dart';
import 'package:timelines_plus/timelines_plus.dart';

class TimelineKunjuganResume extends StatefulWidget {
  const TimelineKunjuganResume({
    super.key,
    required this.data,
    required this.controller,
  });

  final KunjunganPasienResumeModel data;
  final ScrollController controller;

  @override
  State<TimelineKunjuganResume> createState() => _TimelineKunjuganResumeState();
}

class _TimelineKunjuganResumeState extends State<TimelineKunjuganResume>
    with AutomaticKeepAliveClientMixin {
  List<KunjunganPasienResume> _data = [];

  @override
  void initState() {
    super.initState();
    _data = widget.data.data!;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Timeline.tileBuilder(
      controller: widget.controller,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      theme: TimelineThemeData(
        nodePosition: 0,
        indicatorPosition: 0,
        color: Colors.green,
        connectorTheme: const ConnectorThemeData(
          thickness: 2.0,
        ),
        indicatorTheme: const IndicatorThemeData(
          size: 25.0,
        ),
      ),
      builder: TimelineTileBuilder.connected(
        contentsAlign: ContentsAlign.basic,
        contentsBuilder: (_, i) {
          if (i == _data.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: SizedBox(
                  height: 28,
                  width: 28,
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                ),
              ),
            );
          }
          var data = _data[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 22.0),
            child: Container(
              margin: const EdgeInsets.only(left: 15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 2.0,
                  ),
                  Text(
                    '${data.tanggalKunjungan} / ${data.nomorRegistrasi}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            SlideLeftRoute(
                              page: ResumeMedisPage(
                                data: data,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                dense: true,
                                minVerticalPadding: 8,
                                title: const Text(
                                  'Keluhan',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13.0),
                                ),
                                subtitle: Text(
                                  '${data.keluhan}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              if (data.diagnosa!.isNotEmpty)
                                ListTile(
                                  dense: true,
                                  minVerticalPadding: 8,
                                  title: const Text(
                                    'Diagnosa',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 13.0),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: data.diagnosa!
                                        .map((diagnosa) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4.0, top: 2.0),
                                              child: Text(
                                                '- ${diagnosa.kodeIcd10} - ${diagnosa.namaDiagnosa}',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              if (data.petugas!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Petugas',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 13.0),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: data.petugas!
                                            .map(
                                              (petugas) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 1.0),
                                                child: Text(
                                                  '- ${petugas.nama}',
                                                  style: const TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(
                                height: 10.0,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        connectorBuilder: (_, index, __) {
          return const SolidLineConnector(color: Colors.green);
        },
        lastConnectorBuilder: (_) {
          return const SolidLineConnector(color: Colors.green);
        },
        indicatorBuilder: (context, i) {
          return const OutlinedDotIndicator(
            color: kPrimaryColor,
            backgroundColor: Colors.transparent,
            child: Center(
                child: Icon(
              Icons.calendar_month_outlined,
              size: 15,
              color: kPrimaryColor,
            )),
          );
        },
        itemCount: widget.data.currentPage != widget.data.totalPage
            ? _data.length + 1
            : _data.length,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
