// import 'package:json_annotation/json_annotation.dart';
// part 'complaint_model.g.dart';

// @JsonSerializable()
class Complaint {
  final String id, description, category, status, createdAt;
  final double lat, lng;
  final String? imageUrl, proofUrl;

  Complaint({
    required this.id,
    required this.description,
    required this.category,
    required this.lat,
    required this.lng,
    required this.status,
    required this.createdAt,
    this.imageUrl,
    this.proofUrl,
  });

  factory Complaint.fromJson(Map<String, dynamic> j) => Complaint(
    id: (j['id'] ?? '').toString(),
    description: j['description'] ?? '',
    category: j['category'] ?? '',
    lat: (j['lat'] as num).toDouble(),
    lng: (j['lng'] as num).toDouble(),
    status: j['status'] ?? 'Submitted',
    createdAt: j['createdAt'] ?? DateTime.now().toIso8601String(),
    imageUrl: j['imageUrl'],
    proofUrl: j['proofUrl'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'category': category,
    'lat': lat,
    'lng': lng,
    'status': status,
    'createdAt': createdAt,
    'imageUrl': imageUrl,
    'proofUrl': proofUrl,
  };
}
