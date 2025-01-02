import 'package:dokter_panggil/src/blocs/auth_bloc.dart';
import 'package:dokter_panggil/src/pages/barang/barang_page.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/home_page.dart';
import 'package:dokter_panggil/src/pages/laporan_page.dart';
import 'package:dokter_panggil/src/pages/master/master_page.dart';
import 'package:dokter_panggil/src/pages/pasien/tambah_pasien_page.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Rootpage extends StatefulWidget {
  const Rootpage({super.key});

  @override
  State<Rootpage> createState() => _RootpageState();
}

class _RootpageState extends State<Rootpage> {
  late PersistentTabController _controller;
  int? _role;
  String? _name;
  bool _isProfile = false;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _getSaveProfile();
  }

  void _getSaveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name');
      _role = prefs.getInt('role');
      _isProfile = true;
    });
  }

  List<PersistentTabConfig> _navBarsItems() {
    return [
      PersistentTabConfig(
        screen: Homepage(name: _name!, role: _role!),
        item: ItemConfig(
          icon: const FaIcon(FontAwesomeIcons.house),
          title: 'Home',
          iconSize: 24.0,
          activeColorSecondary: kPrimaryColor,
          activeForegroundColor: kPrimaryColor,
          inactiveForegroundColor: Colors.grey[300]!,
        ),
      ),
      PersistentTabConfig(
        screen: const Tambahpasienpage(),
        item: ItemConfig(
          icon: const FaIcon(FontAwesomeIcons.accessibleIcon),
          iconSize: 24.0,
          title: 'Pasien',
          activeColorSecondary: kPrimaryColor,
          activeForegroundColor: kPrimaryColor,
          inactiveForegroundColor: Colors.grey[300]!,
        ),
      ),
      PersistentTabConfig(
        screen: Barangpage(
          role: _role!,
        ),
        item: ItemConfig(
          icon: const FaIcon(FontAwesomeIcons.toolbox),
          iconSize: 24.0,
          title: 'Apotek',
          activeColorSecondary: kPrimaryColor,
          activeForegroundColor: kPrimaryColor,
          inactiveForegroundColor: Colors.grey[300]!,
        ),
      ),
      PersistentTabConfig(
        screen: const Laporanpage(),
        item: ItemConfig(
          icon: const FaIcon(FontAwesomeIcons.paste),
          iconSize: 24.0,
          title: 'Laporan',
          activeColorSecondary: kPrimaryColor,
          activeForegroundColor: kPrimaryColor,
          inactiveForegroundColor: Colors.grey[300]!,
        ),
      ),
      PersistentTabConfig(
        screen: Masterpage(
          role: _role!,
        ),
        item: ItemConfig(
          icon: const FaIcon(FontAwesomeIcons.database),
          iconSize: 24.0,
          title: 'Master',
          activeColorSecondary: kPrimaryColor,
          activeForegroundColor: kPrimaryColor,
          inactiveForegroundColor: Colors.grey[300]!,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (!_isProfile) {
      return const Scaffold(
        body: LoadingKit(
          color: kPrimaryColor,
        ),
      );
    } else if (_role == 2 || _role == 3) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/logo_only.png',
                  height: 180,
                ),
                const SizedBox(
                  height: 22.0,
                ),
                const Text(
                  'Anda tidak memiliki hak akses untuk mengakses aplikasi ini',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
                const SizedBox(
                  height: 32.0,
                ),
                ElevatedButton(
                  onPressed: () => authbloc.closedSession(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                  ),
                  child: const Text('Logout'),
                )
              ],
            ),
          ),
        ),
      );
    }
    return PersistentTabView(
      controller: _controller,
      tabs: _navBarsItems(),
      backgroundColor: Colors.white,
      navBarOverlap: const NavBarOverlap.none(),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      navBarHeight: kBottomNavigationBarHeight + 6,
      navBarBuilder: (navBarConfig) {
        return Style1BottomNavBar(
          navBarConfig: navBarConfig,
          navBarDecoration: const NavBarDecoration(
            padding: EdgeInsets.only(top: 12.0, bottom: 0, left: 14, right: 14),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
              )
            ],
          ),
        );
      },
    );
  }
}
