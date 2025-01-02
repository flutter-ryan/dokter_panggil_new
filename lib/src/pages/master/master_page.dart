import 'package:dokter_panggil/src/pages/components/menu_master.dart';
import 'package:dokter_panggil/src/pages/master/biaya_admin_page.dart';
import 'package:dokter_panggil/src/pages/master/biaya_transport_tindakan_page.dart';
import 'package:dokter_panggil/src/pages/master/diagnosa_page.dart';
import 'package:dokter_panggil/src/pages/master/diskon_page.dart';
import 'package:dokter_panggil/src/pages/master/farmasi_page.dart';
import 'package:dokter_panggil/src/pages/master/identitas_pasien_page.dart';
import 'package:dokter_panggil/src/pages/master/layanan_page.dart';
import 'package:dokter_panggil/src/pages/master/mitra_page.dart';
import 'package:dokter_panggil/src/pages/master/paket_page.dart';
import 'package:dokter_panggil/src/pages/master/pegawai_page.dart';
import 'package:dokter_panggil/src/pages/master/profesi_page.dart';
import 'package:dokter_panggil/src/pages/master/tindakan_lab_page.dart';
import 'package:dokter_panggil/src/pages/master/tindakan_radiologi_page.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class Masterpage extends StatefulWidget {
  const Masterpage({
    super.key,
    this.role,
  });

  final int? role;

  @override
  State<Masterpage> createState() => _MasterpageState();
}

class _MasterpageState extends State<Masterpage> {
  List<Widget> _menuList = [];
  void _initMenuList() {
    if (widget.role == 1) {
      _menuList = [
        MenuMaster(
          title: 'Tindakan Laboratorium',
          onTap: () => pushScreen(
            context,
            screen: const TindakanLabPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Tindakan Radiologi',
          onTap: () => pushScreen(
            context,
            screen: const TindakanRadiologiPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Diagnosa',
          onTap: () => pushScreen(
            context,
            screen: const DiagnosaPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Barang Farmasi',
          onTap: () => pushScreen(
            context,
            screen: const FarmasiPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
      ];
    } else if (widget.role == 4) {
      _menuList = [
        MenuMaster(
          title: 'Pegawai',
          onTap: () => pushScreen(
            context,
            screen: const PegawaiPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Profesi',
          onTap: () => pushScreen(
            context,
            screen: const ProfesiPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Tindakan',
          onTap: () => pushScreen(
            context,
            screen: const LayananPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Tindakan Laboratorium',
          onTap: () => pushScreen(
            context,
            screen: const TindakanLabPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Tindakan Radiologi',
          onTap: () => pushScreen(
            context,
            screen: const TindakanRadiologiPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Diagnosa',
          onTap: () => pushScreen(
            context,
            screen: const DiagnosaPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Barang Farmasi',
          onTap: () => pushScreen(
            context,
            screen: const FarmasiPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Paket/Promo',
          onTap: () => pushScreen(
            context,
            screen: const PaketPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Biaya Transportasi Tindakan',
          onTap: () => pushScreen(
            context,
            screen: const BiayaTransportTindakanPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Diskon',
          onTap: () => pushScreen(
            context,
            screen: const DiskonPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Identitas Pasien',
          onTap: () => pushScreen(
            context,
            screen: const IdentitasPasienPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
      ];
    } else if (widget.role == 99) {
      _menuList = [
        MenuMaster(
          title: 'Pegawai',
          onTap: () => pushScreen(
            context,
            screen: const PegawaiPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Profesi',
          onTap: () => pushScreen(
            context,
            screen: const ProfesiPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Tindakan',
          onTap: () => pushScreen(
            context,
            screen: const LayananPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Tindakan Laboratorium',
          onTap: () => pushScreen(
            context,
            screen: const TindakanLabPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Tindakan Radiologi',
          onTap: () => pushScreen(
            context,
            screen: const TindakanRadiologiPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Mitra',
          onTap: () => pushScreen(
            context,
            screen: const MitraPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Diagnosa',
          onTap: () => pushScreen(
            context,
            screen: const DiagnosaPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Barang Farmasi',
          onTap: () => pushScreen(
            context,
            screen: const FarmasiPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Paket/Promo',
          onTap: () => pushScreen(
            context,
            screen: const PaketPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Biaya Administrasi',
          onTap: () => pushScreen(
            context,
            screen: const BiayaAdminPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Biaya Transportasi Tindakan',
          onTap: () => pushScreen(
            context,
            screen: const BiayaTransportTindakanPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Diskon',
          onTap: () => pushScreen(
            context,
            screen: const DiskonPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
        MenuMaster(
          title: 'Identitas Pasien',
          onTap: () => pushScreen(
            context,
            screen: const IdentitasPasienPage(),
            pageTransitionAnimation: PageTransitionAnimation.slideUp,
            withNavBar: false,
          ),
        ),
      ];
    } else {
      _menuList = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    _initMenuList();
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
              title: 'Master Data',
              subtitle:
                  'Pastikan Anda memiliki hak akses untuk mengakses fitur tertentu',
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                itemCount: _menuList.length,
                itemBuilder: (context, i) {
                  return _menuList[i];
                },
                separatorBuilder: (context, i) => const Divider(
                  height: 28.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderPage extends StatelessWidget {
  const HeaderPage({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 28.0,
          ),
        ],
      ),
    );
  }
}
