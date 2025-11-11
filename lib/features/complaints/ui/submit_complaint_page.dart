import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class SubmitComplaintPage extends StatefulWidget {
  final bool anonymousDefault;   // set true for /submit/anonymous
  final bool lockAnonymous;      // hide toggle when true

  const SubmitComplaintPage({
    super.key,
    this.anonymousDefault = false,
    this.lockAnonymous = false,
  });

  @override
  State<SubmitComplaintPage> createState() => _SubmitComplaintPageState();
}

class _SubmitComplaintPageState extends State<SubmitComplaintPage> {
  final _form = GlobalKey<FormState>();
  final _desc = TextEditingController();
  final _category = TextEditingController();

  // map + location
  final _map = MapController();
  LatLng? _pin;
  String? _address;
  bool _locating = false;

  // image
  File? _image;

  // anonymous toggle
  late bool _anonymous;

  // categories (extend as needed)
  static const categories = [
    'No Water Supply in Public Toilet',
    'Blockage in Public Toilet',
    'Uncleaning Public Toilet',
    'Yellow Spot (Public Urination Spot)',
    'Improper Disposal of Fecal Waste/Septage',
    'Open Manholes or Drains',
    'Unsafe Manhole Entry',
    'Removal of Debris/Construction Material',
    'Removal of Dead Animals',
    'Cleanliness Target Unit (Dirty Spot)',
    'Garbage Dump',
    'Garbage Vehicle Not Arrived',
    'Burning of Garbage in Open Space',
    'Sweeping Not Done',
    'Dustbins Not Cleaned',
    'Open Defecation',
    'Overflow of Sewerage or Storm Water',
    'Stagnant Water on Road/Open Area',
  ];

  @override
  void initState() {
    super.initState();
    _anonymous = widget.anonymousDefault;
    // default center (set to your city center if you want)
    _pin = const LatLng(10.963, 76.952);
  }

  @override
  void dispose() {
    _desc.dispose();
    _category.dispose();
    super.dispose();
  }

  Future<void> _useMyLocation() async {
    try {
      setState(() => _locating = true);
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        throw Exception('Location permission denied');
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final point = LatLng(pos.latitude, pos.longitude);
      _map.move(point, 17);
      setState(() => _pin = point);
      await _reverseGeocode(point);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not get current location')),
      );
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _reverseGeocode(LatLng p) async {
    try {
      final placemarks =
          await geocoding.placemarkFromCoordinates(p.latitude, p.longitude);
      if (placemarks.isNotEmpty) {
        final pm = placemarks.first;
        setState(() {
          _address =
              '${pm.street?.trim() ?? ''}, ${pm.locality ?? ''}, ${pm.administrativeArea ?? ''}, ${pm.country ?? ''}'
                  .replaceAll(RegExp(r'^,\s*'), '');
        });
      }
    } catch (_) {
      setState(() => _address = null);
    }
  }

  Future<void> _pickImage(ImageSource src) async {
    final x = await ImagePicker().pickImage(source: src, imageQuality: 75);
    if (x != null) setState(() => _image = File(x.path));
  }

  bool get _canSubmit =>
      _category.text.trim().isNotEmpty &&
      _desc.text.trim().isNotEmpty &&
      _image != null &&
      _pin != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_category.text.isEmpty ? 'Submit Complaint' : _category.text),
        actions: [
          IconButton(
            tooltip: 'Use my location',
            onPressed: _locating ? null : _useMyLocation,
            icon: _locating
                ? const SizedBox(
                    width: 18, height: 18, child: CircularProgressIndicator())
                : const Icon(Icons.my_location),
          ),
        ],
      ),
      body: Column(
        children: [
          // MAP
          SizedBox(
            height: 220,
            child: FlutterMap(
              mapController: _map,
              options: MapOptions(
                initialCenter: _pin!,
                initialZoom: 15,
                onTap: (tapPos, latlng) async {
                  setState(() => _pin = latlng);
                  await _reverseGeocode(latlng);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.civictrack',
                ),
                MarkerLayer(markers: [
                  if (_pin != null)
                    Marker(
                      point: _pin!,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_pin,
                          size: 40, color: Colors.deepPurple),
                    )
                ]),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_address != null) ...[
                      const Text('Selected area',
                          style: TextStyle(fontSize: 13, color: Colors.black54)),
                      const SizedBox(height: 4),
                      Text(_address!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16)),
                      const SizedBox(height: 14),
                    ],

                    // CATEGORY with dropdown in suffix
                    TextFormField(
                      controller: _category,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        prefixIcon: const Icon(Icons.category_outlined),
                        suffixIcon: PopupMenuButton<String>(
                          tooltip: 'Choose category',
                          icon: const Icon(Icons.arrow_drop_down_circle),
                          itemBuilder: (context) => categories
                              .map((e) => PopupMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          onSelected: (val) => setState(() {
                            _category.text = val;
                          }),
                        ),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Pick a category' : null,
                    ),
                    const SizedBox(height: 16),

                    // DESCRIPTION
                    TextFormField(
                      controller: _desc,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText:
                            'Please provide a brief description about the complaint.',
                        prefixIcon: Icon(Icons.info_outline),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Description required' : null,
                    ),
                    const SizedBox(height: 18),

                    // IMAGE PICKER CARD
                    GestureDetector(
                      onTap: () async {
                        final choice = await showModalBottomSheet<ImageSource>(
                          context: context,
                          showDragHandle: true,
                          builder: (sheetContext) => SafeArea(
                            child: Wrap(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('Take a photo'),
                                  onTap: () => Navigator.pop(
                                      sheetContext, ImageSource.camera),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text('Choose from gallery'),
                                  onTap: () => Navigator.pop(
                                      sheetContext, ImageSource.gallery),
                                ),
                              ],
                            ),
                          ),
                        );
                        if (choice != null) _pickImage(choice);
                      },
                      child: Container(
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFF3B3A6E),
                        ),
                        child: _image == null
                            ? const Center(
                                child: Text('Add a photo',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(_image!, fit: BoxFit.cover),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Add a description and photo to submit your complaint.',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 18),

                    // ANONYMOUS
                    if (!widget.lockAnonymous)
                      SwitchListTile(
                        value: _anonymous,
                        onChanged: (v) => setState(() => _anonymous = v),
                        title: const Text('Submit Anonymously'),
                      )
                    else
                      Row(
                        children: const [
                          Icon(Icons.visibility_off, size: 18),
                          SizedBox(width: 6),
                          Text('Submitting as Anonymous'),
                        ],
                      ),

                    const SizedBox(height: 18),

                    // SUBMIT
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _canSubmit
                            ? () async {
                                if (!_form.currentState!.validate()) return;

                                // TODO: send to backend with:
                                // category: _category.text.trim()
                                // desc: _desc.text.trim()
                                // lat: _pin!.latitude, lng: _pin!.longitude
                                // address: _address
                                // image: _image
                                // anonymous: _anonymous

                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(_anonymous
                                          ? 'Anonymous complaint submitted ✅'
                                          : 'Complaint submitted ✅')),
                                );
                                Navigator.pop(context);
                              }
                            : null,
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
