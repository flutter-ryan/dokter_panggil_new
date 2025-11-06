import 'package:admin_dokter_panggil/src/models/mr_pengkajian_dokter_model.dart';
import 'package:admin_dokter_panggil/src/models/pasien_show_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/dashboard_card_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/deskripsi_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/inline_deskripsi_widget.dart';
import 'package:flutter/material.dart';

class MrPemeriksaanFisisForm extends StatefulWidget {
  const MrPemeriksaanFisisForm({
    super.key,
    this.idKunjungan,
    this.pasien,
    this.mrKunjunganPemeriksaanFisis,
  });

  final int? idKunjungan;
  final Pasien? pasien;
  final MrKunjunganPemeriksaanFisis? mrKunjunganPemeriksaanFisis;

  @override
  State<MrPemeriksaanFisisForm> createState() => _MrPemeriksaanFisisFormState();
}

class _MrPemeriksaanFisisFormState extends State<MrPemeriksaanFisisForm> {
  MrKunjunganPemeriksaanFisis? _pemeriksaanFisis;

  @override
  void initState() {
    super.initState();
    _pemeriksaanFisis = widget.mrKunjunganPemeriksaanFisis;
  }

  @override
  Widget build(BuildContext context) {
    return DashboardCardWidget(
      title: 'Pemeriksaan Fisis',
      errorMessage: 'Data pemeriksaan fisis tidak tersedia',
      dataCard: _pemeriksaanFisis == null
          ? null
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8.0,
                  ),
                  if (!widget.pasien!.isDewasa &&
                      _pemeriksaanFisis!.fisikAnak != null)
                    const Text(
                      'Fisik Anak',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  if (!widget.pasien!.isDewasa &&
                      _pemeriksaanFisis!.fisikAnak != null)
                    const SizedBox(
                      height: 12,
                    ),
                  if (!widget.pasien!.isDewasa &&
                      _pemeriksaanFisis!.fisikAnak != null)
                    Row(
                      children: [
                        if (_pemeriksaanFisis!.fisikAnak?.panjangBadan != null)
                          Expanded(
                            child: DeskripsiWidget(
                              title: 'Panjang Badan',
                              body: Text(
                                  '${_pemeriksaanFisis!.fisikAnak?.panjangBadan} cm'),
                            ),
                          ),
                        if (_pemeriksaanFisis!.fisikAnak?.panjangBadan != null)
                          const SizedBox(
                            width: 12,
                          ),
                        if (_pemeriksaanFisis!.fisikAnak?.beratBadan != null)
                          Expanded(
                            child: DeskripsiWidget(
                              title: 'Berat Badan',
                              body: Text(
                                  '${_pemeriksaanFisis!.fisikAnak?.beratBadan} kg'),
                            ),
                          ),
                        if (_pemeriksaanFisis!.fisikAnak?.lingkarKepala != null)
                          Expanded(
                            child: DeskripsiWidget(
                              title: 'Lingkar Kepala',
                              body: Text(
                                  '${_pemeriksaanFisis!.fisikAnak?.lingkarKepala} cm'),
                            ),
                          )
                      ],
                    ),
                  if (!widget.pasien!.isDewasa &&
                      _pemeriksaanFisis!.fisikAnak != null)
                    const SizedBox(
                      height: 12,
                    ),
                  if (!widget.pasien!.isDewasa &&
                      _pemeriksaanFisis!.fisikAnak?.statusGizi != null)
                    DeskripsiWidget(
                      title: 'Status Gizi',
                      body: Text('${_pemeriksaanFisis!.fisikAnak?.statusGizi}'),
                    ),
                  if (!widget.pasien!.isDewasa &&
                      _pemeriksaanFisis!.fisikAnak?.statusGizi != null)
                    const SizedBox(
                      height: 12,
                    ),
                  if (!widget.pasien!.isDewasa &&
                      _pemeriksaanFisis!.fisikAnak != null)
                    DeskripsiWidget(
                      title: 'Keadaan Umum',
                      body:
                          Text('${_pemeriksaanFisis!.fisikAnak?.keadaanUmum}'),
                    ),
                  if (!widget.pasien!.isDewasa &&
                      _pemeriksaanFisis!.fisikAnak != null)
                    const Divider(),
                  const Text(
                    'Mata',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DeskripsiWidget(
                          title: 'Anemis',
                          body: Text('${_pemeriksaanFisis!.mata!.anemis}'),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: DeskripsiWidget(
                          title: 'Ikterus',
                          body: Text('${_pemeriksaanFisis!.mata!.ikterus}'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DeskripsiWidget(
                          title: 'Pupil',
                          body: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${_pemeriksaanFisis!.mata!.pupil}'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        flex: 3,
                        child: DeskripsiWidget(
                          title: 'Diameter Pupil Kanan',
                          body:
                              Text('${_pemeriksaanFisis!.mata!.diameterKanan}'),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: DeskripsiWidget(
                          title: 'Diameter Pupil Kiri',
                          body:
                              Text('${_pemeriksaanFisis!.mata!.diameterKiri}'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Divider(),
                  const Text(
                    'THT',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Tonsil',
                    body: Text('${_pemeriksaanFisis!.tht!.tonsil}'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Faring',
                    body: Text('${_pemeriksaanFisis!.tht!.faring}'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Lidah',
                    body: Text('${_pemeriksaanFisis!.tht!.lidah}'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Bibir',
                    body: Text('${_pemeriksaanFisis!.tht!.bibir}'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Divider(),
                  const Text(
                    'Leher',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Ivp',
                    body: Text('${_pemeriksaanFisis!.leher!.ivp}'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Pembesaran kelenjar limfe',
                    body: Text(
                        '${_pemeriksaanFisis!.leher!.pembesaranKelenjarLimfe}'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Divider(),
                  const Text(
                    'Kaku duduk',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Kaku duduk',
                    body: Text('${_pemeriksaanFisis!.kakuDuduk!.kakuDuduk}'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Divider(),
                  const Text(
                    'Thoraks',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Thoraks',
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${_pemeriksaanFisis!.thoraks!.thoraks}'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Divider(),
                  const Text(
                    'Jantung',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InlineDeskripsiWidget(
                    title: 'S1/S2',
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${_pemeriksaanFisis!.chor!.s1S2}'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Murmur',
                    body: Text('${_pemeriksaanFisis!.chor!.murmur}'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Lain-lain',
                    body: _pemeriksaanFisis!.chor?.lainlainMurmur != null
                        ? Text('${_pemeriksaanFisis!.chor!.lainlainMurmur}')
                        : Text('-'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Divider(),
                  const Text(
                    'Pulmo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Suara Nafas',
                    body: Text('${_pemeriksaanFisis!.pulmo!.suaraNafas}'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Rhonci',
                    body: Text('${_pemeriksaanFisis!.pulmo!.ronchi}'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Wheezing',
                    body: Text('${_pemeriksaanFisis!.pulmo!.wheezing}'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Divider(),
                  const Text(
                    'Abdomen',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Disintended',
                    body: Text('${_pemeriksaanFisis!.abdomen!.disintended}'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Meteorismus',
                    body: Text('${_pemeriksaanFisis!.abdomen!.meteorismus}'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Peristaltik',
                    body:
                        Text('${_pemeriksaanFisis!.peristaltik!.peristaltik}'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Asites',
                    body: Text('${_pemeriksaanFisis!.asites!.asites}'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Nyeri tekan',
                    body: Text('${_pemeriksaanFisis!.nyeriTekan!.nyeriTekan}'),
                  ),
                  if (_pemeriksaanFisis!.nyeriTekan!.lokasiNyeriTekan != null)
                    const SizedBox(
                      height: 12,
                    ),
                  if (_pemeriksaanFisis!.nyeriTekan!.lokasiNyeriTekan != null)
                    InlineDeskripsiWidget(
                      title: 'Lokasi nyeri tekan',
                      body: Text(
                          '${_pemeriksaanFisis!.nyeriTekan!.lokasiNyeriTekan}'),
                    ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Divider(),
                  const Text(
                    'Hepar/Lien',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Hepar',
                    body: Text('${_pemeriksaanFisis!.heparLien!.hepar}'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Lien',
                    body: Text('${_pemeriksaanFisis!.heparLien!.lien}'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Divider(),
                  const Text(
                    'Extremitas',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Extremitas',
                    body: Text('${_pemeriksaanFisis!.extremitas!.extremitas}'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Udem',
                    body: Text('${_pemeriksaanFisis!.udem!.udem}'),
                  ),
                  if (_pemeriksaanFisis!.udem!.sebutkanUdem != null)
                    const SizedBox(
                      height: 12,
                    ),
                  if (_pemeriksaanFisis!.udem!.sebutkanUdem != null)
                    InlineDeskripsiWidget(
                      title: 'Sebutkan udem',
                      body: Text('${_pemeriksaanFisis!.udem!.sebutkanUdem}'),
                    ),
                  const SizedBox(
                    height: 12,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Lain-lain',
                    body: _pemeriksaanFisis!.udem?.lainLain != null
                        ? Text('${_pemeriksaanFisis!.udem!.lainLain}')
                        : Text('-'),
                  )
                ],
              ),
            ),
    );
  }
}
