import 'package:geolocator/geolocator.dart';

class Location {
//  Position _currentPosition;
  double latitude;
  double longitude;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Future<void> getCurrentLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      latitude = position.latitude;
      longitude = position.longitude;
    }).catchError((e) {
      print(e);
    });
  }
//
//  getAddressFromLatLng() async {
//    try {
//      List<Placemark> p = await geolocator.placemarkFromCoordinates(
//          _currentPosition.latitude, _currentPosition.longitude);
//
//      Placemark place = p[0];
//
//      //"${place.locality}, ${place.postalCode}, ${place.country}";
//
//    } catch (e) {
//      print(e);
//    }
//  }
}
