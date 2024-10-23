import 'package:dokter_panggil/src/pages/master/layanan_page.dart';
import 'package:dokter_panggil/src/pages/master/pegawai_page.dart';
import 'package:dokter_panggil/src/pages/master/profesi_page.dart';
import 'package:dokter_panggil/src/pages/master/tindakan_lab_page.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class Userpage extends StatefulWidget {
  const Userpage({super.key});

  @override
  State<Userpage> createState() => _UserpageState();
}

class _UserpageState extends State<Userpage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              width: double.infinity,
              height: 280,
              decoration: const BoxDecoration(
                color: kPrimaryColor,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 18),
              child: Text(
                'Master Data',
                style: TextStyle(fontSize: 18.0, color: Colors.grey),
              ),
            ),
            TileMenuUser(
              title: 'Master Pegawai',
              onTap: () => pushScreen(
                context,
                screen: const PegawaiPage(),
                pageTransitionAnimation: PageTransitionAnimation.slideUp,
                withNavBar: false,
              ),
            ),
            TileMenuUser(
              title: 'Master Profesi',
              onTap: () => pushScreen(
                context,
                screen: const ProfesiPage(),
                pageTransitionAnimation: PageTransitionAnimation.slideUp,
                withNavBar: false,
              ),
            ),
            TileMenuUser(
              title: 'Master Tindakan',
              onTap: () => pushScreen(
                context,
                screen: const LayananPage(),
                pageTransitionAnimation: PageTransitionAnimation.slideUp,
                withNavBar: false,
              ),
            ),
            TileMenuUser(
              title: 'Master Laboratorium',
              onTap: () => pushScreen(
                context,
                screen: const TindakanLabPage(),
                pageTransitionAnimation: PageTransitionAnimation.slideUp,
                withNavBar: false,
              ),
            ),
            TileMenuUser(
              title: 'Master Mitra',
              onTap: () => pushScreen(
                context,
                screen: const TindakanLabPage(),
                pageTransitionAnimation: PageTransitionAnimation.slideUp,
                withNavBar: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TileMenuUser extends StatelessWidget {
  const TileMenuUser({
    super.key,
    this.onTap,
    this.title,
  });
  final VoidCallback? onTap;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
      minLeadingWidth: 28,
      leading: const FaIcon(
        FontAwesomeIcons.database,
      ),
      title: Text('$title'),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}
