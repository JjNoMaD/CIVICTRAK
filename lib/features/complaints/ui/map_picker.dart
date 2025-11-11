import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPicker extends StatefulWidget { const MapPicker({super.key}); @override State<MapPicker> createState()=>_MapPickerState();}
class _MapPickerState extends State<MapPicker>{
  LatLng pos = const LatLng(11.0168, 76.9558);
  @override Widget build(BuildContext ctx)=>Scaffold(
    appBar: AppBar(title: const Text('Pick Location'), actions:[
      TextButton(onPressed: ()=> Navigator.pop(ctx, {'lat': pos.latitude, 'lng': pos.longitude}),
        child: const Text('Use', style: TextStyle(color: Colors.white)))
    ]),
    body: FlutterMap(
      options: MapOptions(initialCenter: pos, initialZoom: 14, onTap: (_, p)=> setState(()=> pos=p)),
      children: [
        TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'civictrack'),
        MarkerLayer(markers:[ Marker(point: pos, child: const Icon(Icons.location_pin, size: 36)) ]),
      ],
    ),
  );
}
