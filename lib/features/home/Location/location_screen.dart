import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:soor_app/conistans/constans.dart';
import 'package:soor_app/features/home/Location/confirm_location.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  GoogleMapController? mapController;

  LatLng? currentLocation;

  String address = "جاري تحديد موقعك...";

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled;

      LocationPermission permission;

      // Check if location service is enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        setState(() {
          address = "من فضلك قم بتفعيل خدمة الموقع";
          isLoading = false;
        });
        return;
      }

      // Check permission
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          setState(() {
            address = "تم رفض صلاحية الوصول للموقع";
            isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          address = "صلاحية الموقع مرفوضة نهائياً";
          isLoading = false;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      LatLng location = LatLng(position.latitude, position.longitude);

      setState(() {
        currentLocation = location;
        isLoading = false;
      });

      // Move camera
      mapController?.animateCamera(CameraUpdate.newLatLngZoom(location, 16));

      // Get address
      await getAddressFromLocation(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        address = "حدث خطأ أثناء تحديد الموقع";
        isLoading = false;
      });
    }
  }

  Future<void> getAddressFromLocation(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        String fullAddress = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country,
        ].where((e) => e != null && e.isNotEmpty).join("، ");

        setState(() {
          address = fullAddress;
        });
      }
    } catch (e) {
      setState(() {
        address = "لم نتمكن من تحديد العنوان";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.fieldBackground,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.fieldBorder,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Icon(Icons.search, color: AppTheme.hintColor),
                  SizedBox(width: 5),
                  Text(
                    "البحث عن الموقع",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppTheme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.fieldBorder,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back,
                  color: AppTheme.labelColor,
                  size: 25,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // ================= MAP =================
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(30.0444, 31.2357),
              zoom: 12,
            ),

            onMapCreated: (controller) {
              mapController = controller;

              if (currentLocation != null) {
                controller.animateCamera(
                  CameraUpdate.newLatLngZoom(currentLocation!, 16),
                );
              }
            },

            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,

            markers: currentLocation == null
                ? {}
                : {
                    Marker(
                      markerId: const MarkerId("current_location"),
                      position: currentLocation!,
                    ),
                  },
          ),
          // ================= CURRENT LOCATION BUTTON =================
          Positioned(
            right: 20,
            bottom: 220,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              elevation: 4,
              onPressed: () async {
                await getCurrentLocation();
              },
              child: const Icon(Icons.my_location, color: Colors.black),
            ),
          ),

          // ================= BOTTOM CONTAINER =================
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              decoration: const BoxDecoration(
                color: AppTheme.fieldBackground,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "موقعك الحالي",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.labelColor,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 22,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: isLoading
                            ? const Text(
                                "جاري تحديد موقعك...",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.labelColor,
                                ),
                              )
                            : Text(
                                address,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.labelColor,
                                ),
                              ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: currentLocation == null
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ConfirmLocationScreen(
                                    locationName: address,
                                    location: currentLocation!,
                                  ),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "حفظ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
