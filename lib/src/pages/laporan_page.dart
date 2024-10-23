import 'package:dokter_panggil/src/pages/components/menu_master.dart';
import 'package:dokter_panggil/src/pages/master/laporan/laporan_harian_page.dart';
import 'package:dokter_panggil/src/pages/master/laporan/laporan_jasa_dokter_page.dart';
import 'package:dokter_panggil/src/pages/master/laporan/laporan_jasa_perawat_page.dart';
import 'package:dokter_panggil/src/pages/master/laporan/laporan_pelayanan.dart';
import 'package:dokter_panggil/src/pages/master/master_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class Laporanpage extends StatefulWidget {
  const Laporanpage({super.key});

  @override
  State<Laporanpage> createState() => _LaporanpageState();
}

class _LaporanpageState extends State<Laporanpage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const HeaderPage(
              title: 'Laporan',
              subtitle:
                  'Pastikan Anda memiliki hak akses untuk mengakses fitur tertentu',
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                children: [
                  MenuMaster(
                    title: 'Laporan Pelayanan',
                    onTap: () => pushScreen(
                      context,
                      screen: const LaporanPelayanan(),
                      pageTransitionAnimation: PageTransitionAnimation.slideUp,
                      withNavBar: false,
                    ),
                    iconData: FontAwesomeIcons.paste,
                  ),
                  const Divider(
                    height: 28.0,
                  ),
                  MenuMaster(
                    title: 'Laporan Harian',
                    onTap: () => pushScreen(
                      context,
                      screen: const LaporanHarianPage(),
                      pageTransitionAnimation: PageTransitionAnimation.slideUp,
                      withNavBar: false,
                    ),
                    iconData: FontAwesomeIcons.paste,
                  ),
                  const Divider(
                    height: 28.0,
                  ),
                  MenuMaster(
                    title: 'Laporan Jasa Dokter',
                    onTap: () => pushScreen(
                      context,
                      screen: const LaporanJasaDokterPage(),
                      pageTransitionAnimation: PageTransitionAnimation.slideUp,
                      withNavBar: false,
                    ),
                    iconData: FontAwesomeIcons.paste,
                  ),
                  const Divider(
                    height: 28.0,
                  ),
                  MenuMaster(
                    title: 'Laporan Jasa Perawat',
                    onTap: () => pushScreen(
                      context,
                      screen: const LaporanJasaPerawatPage(),
                      pageTransitionAnimation: PageTransitionAnimation.slideUp,
                      withNavBar: false,
                    ),
                    iconData: FontAwesomeIcons.paste,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
