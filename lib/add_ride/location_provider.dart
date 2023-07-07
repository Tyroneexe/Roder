import 'package:flutter/material.dart';

class LocationProvider with ChangeNotifier {
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
}
