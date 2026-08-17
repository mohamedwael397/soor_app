import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:soor_app/Home/Location/details_screen.dart';
import 'package:soor_app/conistans/constans.dart';

class ConfirmLocationScreen extends StatefulWidget {
  final String locationName;
  final LatLng location;

  const ConfirmLocationScreen({
    super.key,
    required this.locationName,
    required this.location,
  });

  @override
  State<ConfirmLocationScreen> createState() => _ConfirmLocationScreenState();
}

class _ConfirmLocationScreenState extends State<ConfirmLocationScreen> {
  GoogleMapController? mapController;

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
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.fieldBorder,
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back,
                  color: AppTheme.labelColor,
                  size: 25,
                ),
              ),
            ),
          ),
        ),

        centerTitle: true,

        title: const Text(
          "تأكيد الموقع",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.labelColor,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= MAP =================
            Container(
              width: double.infinity,
              height: 128,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: widget.location,
                  zoom: 16,
                ),

                onMapCreated: (controller) {
                  mapController = controller;
                },

                markers: {
                  Marker(
                    markerId: const MarkerId("selected_location"),
                    position: widget.location,
                  ),
                },

                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                myLocationEnabled: false,
                compassEnabled: false,
                mapToolbarEnabled: false,
              ),
            ),

            const SizedBox(height: 15),

            // ================= LOCATION INFO =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
              decoration: BoxDecoration(
                color: AppTheme.fieldBorder,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      widget.locationName,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: AppTheme.labelColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: const [
                        Text(
                          "تعديل",
                          style: TextStyle(
                            color: AppTheme.labelColor,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.edit, color: Colors.white, size: 17),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ================= TITLE =================
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                "بيانات إضافية للموقع",
                style: TextStyle(
                  color: AppTheme.labelColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ================= FIELDS =================
            buildTextField(hint: "اسم المنطقة"),

            const SizedBox(height: 9),

            buildTextField(hint: "رقم المنزل"),

            const SizedBox(height: 9),

            buildTextField(hint: "رقم الدور"),

            const SizedBox(height: 9),

            buildTextField(hint: "تفاصيل إضافية للعنوان", maxLines: 1),

            const SizedBox(height: 150),

            // ================= CONFIRM BUTTON =================
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "تأكيد",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({required String hint, int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      textAlign: TextAlign.right,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppTheme.hintColor, fontSize: 12),
        filled: true,
        fillColor: AppTheme.fieldBorder,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
