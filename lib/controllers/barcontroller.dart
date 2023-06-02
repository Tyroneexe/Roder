import 'package:get/get.dart';

class NavBarController extends GetxController {
  var tabIndex = 0;

  get theme => null;
  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }
}
