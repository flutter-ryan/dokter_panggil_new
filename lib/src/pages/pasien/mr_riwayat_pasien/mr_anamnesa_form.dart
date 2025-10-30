import 'package:admin_dokter_panggil/src/models/mr_pengkajian_telemedicine_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/bullet_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/dashboard_card_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/inline_deskripsi_widget.dart';
import 'package:flutter/material.dart';

class MrAnamnesaForm extends StatefulWidget {
  const MrAnamnesaForm({
    super.key,
    this.idKunjungan,
    this.mrKunjunganAnamnesa,
  });

  final int? idKunjungan;
  final MrKunjunganAnamnesa? mrKunjunganAnamnesa;

  @override
  State<MrAnamnesaForm> createState() => _MrAnamnesaFormState();
}

class _MrAnamnesaFormState extends State<MrAnamnesaForm> {
  MrKunjunganAnamnesa? _anamnesa;

  @override
  void initState() {
    super.initState();
    if (widget.mrKunjunganAnamnesa != null) {
      _anamnesa = widget.mrKunjunganAnamnesa!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardCardWidget(
      title: 'Anamnesa',
      onAdd: null,
      errorMessage: 'Data Anmnesa tidak tersedia',
      dataCard: _anamnesa == null
          ? null
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InlineDeskripsiWidget(
                    title: 'Keluhan utama',
                    body: Text(
                      '${_anamnesa?.keluhanUtama}',
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Riwayat penyakit sekarang',
                    body: Text(
                      _anamnesa?.riwayatPenyakitSekarang ?? '-',
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Riwayat penyakit dahulu',
                    body: Text(
                      _anamnesa?.riwayatPenyakitDahulu ?? '-',
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Riwayat pengobatan',
                    body: _anamnesa!.riwayatPengobatan!.isEmpty
                        ? Text('-')
                        : Column(
                            children: _anamnesa!.riwayatPengobatan!
                                .map(
                                  (pengobatan) => BulletWidget(
                                    title: '${pengobatan.namaObat}',
                                    subtitle: Text(
                                      '${pengobatan.dosis} / ${pengobatan.waktuPenggunaan}',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Pernah dirawat',
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              _anamnesa?.pernahDirawat ?? '-',
                            ),
                            if (_anamnesa?.pernahDirawat == 'Ya')
                              Expanded(
                                child: Text(
                                  ', di ${_anamnesa?.sebutkanPernahDirawat?.lokasiDirawat}',
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (_anamnesa?.pernahDirawat == 'Ya')
                    const SizedBox(
                      height: 12,
                    ),
                  if (_anamnesa?.pernahDirawat == 'Ya')
                    InlineDeskripsiWidget(
                      title: 'Tanggal Dirawat',
                      body: Text(
                        _anamnesa?.sebutkanPernahDirawat?.tanggalDirawat ?? '-',
                      ),
                    ),
                  if (_anamnesa?.pernahDirawat == 'Ya')
                    const SizedBox(
                      height: 12,
                    ),
                  if (_anamnesa?.pernahDirawat == 'Ya')
                    InlineDeskripsiWidget(
                      title: 'Diagnosa',
                      body: Text(
                        _anamnesa?.sebutkanPernahDirawat?.diagnosa ?? '-',
                      ),
                    ),
                  if (_anamnesa?.pernahDirawat == 'Ya')
                    const SizedBox(
                      height: 12,
                    ),
                  if (_anamnesa?.pernahDirawat == 'Ya')
                    InlineDeskripsiWidget(
                      title: 'Riwayat pengobatan',
                      body: _anamnesa?.riwayatPengobatan == null
                          ? const Text('-')
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _anamnesa!.riwayatPengobatan!
                                  .map(
                                    (pengobatan) => Row(
                                      children: [
                                        const Icon(Icons.arrow_right_rounded),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                          child: Text(
                                              '${pengobatan.namaObat} / ${pengobatan.dosis} / ${pengobatan.waktuPenggunaan}'),
                                        )
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                    ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  if (_anamnesa?.sebutkanRiwayatAlergi != null)
                    InlineDeskripsiWidget(
                      title: 'Riwayat alergi',
                      body: Text(
                        _anamnesa?.riwayatAlergi == null
                            ? '-'
                            : '${_anamnesa?.riwayatAlergi}, ${_anamnesa?.sebutkanRiwayatAlergi?.riwayatAlergi}',
                      ),
                    )
                  else
                    InlineDeskripsiWidget(
                      title: 'Riwayat alergi',
                      body: Text(
                        _anamnesa!.riwayatAlergi ?? '-',
                      ),
                    ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Riwayat menyusui',
                    body: Text(
                      _anamnesa!.riwayatMenyusui ?? '-',
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  InlineDeskripsiWidget(
                    title: 'Riwayat Hamil',
                    body: Text(
                      _anamnesa!.riwayatHamil ?? '-',
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
