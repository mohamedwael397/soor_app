import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:soor_app/core/const/constans.dart';
import 'package:soor_app/features/Location/details_screen.dart';

class ConfirmLocationScreen extends StatefulWidget {
  final String locationName;
  final LatLng location;
  final String serviceId;

  const ConfirmLocationScreen({
    super.key,
    required this.locationName,
    required this.location,
    this.serviceId = "1",
  });

  @override
  State<ConfirmLocationScreen> createState() => _ConfirmLocationScreenState();
}

class _ConfirmLocationScreenState extends State<ConfirmLocationScreen> {
  GoogleMapController? mapController;
  final areaCtrl = TextEditingController();
  final buildingCtrl = TextEditingController();
  final floorCtrl = TextEditingController();
  final detailsCtrl = TextEditingController();

  @override
  void dispose() {
    areaCtrl.dispose();
    buildingCtrl.dispose();
    floorCtrl.dispose();
    detailsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.fieldBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.fieldBackground,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.fieldBorder), child: const Center(child: Icon(Icons.arrow_back, color: AppTheme.labelColor, size: 25))),
          ),
        ),
        centerTitle: true,
        title: const Text("تأكيد الموقع", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.labelColor)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity,
            height: 128,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: widget.location, zoom: 16),
              onMapCreated: (controller) => mapController = controller,
              markers: {Marker(markerId: const MarkerId("selected_location"), position: widget.location)},
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
            decoration: BoxDecoration(color: AppTheme.fieldBorder, borderRadius: BorderRadius.circular(15)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Container(width: 45, height: 45, decoration: BoxDecoration(color: Colors.black.withValues(alpha: .15), shape: BoxShape.circle), child: const Icon(Icons.location_on, color: Colors.white, size: 25)),
              const SizedBox(width: 12),
              Expanded(child: Text(widget.locationName, textAlign: TextAlign.right, style: const TextStyle(color: AppTheme.labelColor, fontSize: 14, fontWeight: FontWeight.w500))),
              const SizedBox(width: 8),
              GestureDetector(onTap: () => Navigator.pop(context), child: const Row(children: [Text("تعديل", style: TextStyle(color: AppTheme.labelColor, fontSize: 13)), SizedBox(width: 5), Icon(Icons.edit, color: Colors.white, size: 17)])),
            ]),
          ),
          const SizedBox(height: 18),
          const Align(alignment: Alignment.centerRight, child: Text("بيانات إضافية للموقع", style: TextStyle(color: AppTheme.labelColor, fontSize: 16, fontWeight: FontWeight.w600))),
          const SizedBox(height: 10),
          buildTextField(controller: areaCtrl, hint: "اسم المنطقة"),
          const SizedBox(height: 9),
          buildTextField(controller: buildingCtrl, hint: "اسم/رقم المبنى"),
          const SizedBox(height: 9),
          buildTextField(controller: floorCtrl, hint: "رقم الدور"),
          const SizedBox(height: 9),
          buildTextField(controller: detailsCtrl, hint: "تفاصيل إضافية للعنوان", maxLines: 1),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                if (areaCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('من فضلك أدخل اسم المنطقة')));
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(
                      serviceId: widget.serviceId,
                      lat: widget.location.latitude.toString(),
                      long: widget.location.longitude.toString(),
                      areaName: areaCtrl.text.trim(),
                      buildingName: buildingCtrl.text.trim().isEmpty ? 'غير محدد' : buildingCtrl.text.trim(),
                      floor: floorCtrl.text.trim().isEmpty ? '1' : floorCtrl.text.trim(),
                      addressDetails: detailsCtrl.text.trim().isEmpty ? widget.locationName : detailsCtrl.text.trim(),
                      city: 'Riyadh',
                      region: 'Saudi Arabia',
                      street: widget.locationName,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text("تأكيد", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ),
          ),
          const SizedBox(height: 15),
        ]),
      ),
    );
  }

  Widget buildTextField({required TextEditingController controller, required String hint, int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      textAlign: TextAlign.right,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppTheme.hintColor, fontSize: 12),
        filled: true,
        fillColor: AppTheme.fieldBorder,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: BorderSide.none),
      ),
    );
  }
}
