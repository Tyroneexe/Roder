import 'package:get/get.dart';
import 'package:roder/favourites/favourites.dart';
import 'package:roder/navbar/navbar.dart';
import 'package:roder/search/search_page.dart';
import 'package:roder/ui/add_task_bar.dart';
import 'package:roder/homepage/home_page.dart';

class AppPage {
  static List<GetPage> routes = [
    GetPage(name: navbar, page: () => const NavBar()),
    GetPage(name: home, page: () => const HomePage()),
    GetPage(name: search, page: () => const Search()),
    GetPage(name: favourites, page: () => const Favourites()),
    GetPage(name: task, page: () => const AddTaskPage()),
  ];
  //
  static getnavbar() => navbar;
  static gethome() => home;
  static getsearch() => search;
  static getfavourites() => favourites;
  static gettask() => task;
  //
  static String navbar = '/';
  static String home = '/home';
  static String search = '/search';
  static String favourites = '/favourites';
  static String task = '/task';
}
