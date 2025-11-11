import 'dart:io';
import 'package:dio/dio.dart';
import '../../../core/api_client.dart';
import 'complaint_model.dart';

class ComplaintRepository {
  final _api = ApiClient().dio;

  Future<List<Complaint>> list() async {
    final r = await _api.get('/complaints');
    return (r.data as List).map((e)=>Complaint.fromJson(e)).toList();
  }

  Future<Complaint> submit({required String description, required String category,
    required double lat, required double lng, File? image, bool anonymous=false}) async {
    final form = FormData.fromMap({
      'description': description, 'category': category, 'lat': lat, 'lng': lng,
      if (image != null) 'image': await MultipartFile.fromFile(image.path),
    });
    final r = await _api.post(anonymous?'/complaints/anonymous':'/complaints', data: form);
    return Complaint.fromJson(r.data);
  }

  Future<void> updateStatus(String id, String status) async =>
    _api.put('/complaints/$id/status', data: {'status': status});

  Future<void> uploadProof(String id, File proof) async =>
    _api.post('/complaints/$id/proof', data: FormData.fromMap(
      {'proof': await MultipartFile.fromFile(proof.path)}));
}
