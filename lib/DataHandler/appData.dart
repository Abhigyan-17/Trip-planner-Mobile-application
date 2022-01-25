import 'package:flutter/cupertino.dart';
import 'package:trip_plan_app/Map_geometry/address.dart';

class AppData extends ChangeNotifier {

  Address pickupLocation, dropOffLocation;
  void updatePickupLocationAddress(Address pickupAddress) {
    pickupLocation = pickupAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Address dropOffAddress) {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }
}
