// lib/features/complaints/data/complaint_model.dart

enum ComplaintStatus {
  assigned,
  inProgress,
  resolved,
  escalated,
}

class ComplaintItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final String address;
  ComplaintStatus status;
  final DateTime reportedAt;
  String? proofImagePath;
  final double? lat;
  final double? lng;
  final String? imageUrl;

  ComplaintItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.address,
    required this.status,
    required this.reportedAt,
    this.proofImagePath,
    this.lat,
    this.lng,
    this.imageUrl,
  });

  /// Create a copy of this complaint with some fields replaced
  ComplaintItem copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? address,
    ComplaintStatus? status,
    DateTime? reportedAt,
    String? proofImagePath,
    double? lat,
    double? lng,
    String? imageUrl,
  }) {
    return ComplaintItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      address: address ?? this.address,
      status: status ?? this.status,
      reportedAt: reportedAt ?? this.reportedAt,
      proofImagePath: proofImagePath ?? this.proofImagePath,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory ComplaintItem.fromJson(Map<String, dynamic> json) {
    return ComplaintItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      address: json['address'] ?? '',
      status: _parseStatus(json['status'] ?? 'assigned'),
      reportedAt: json['reportedAt'] != null 
          ? DateTime.parse(json['reportedAt']) 
          : DateTime.now(),
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      imageUrl: json['imageUrl'],
      proofImagePath: json['proofImagePath'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'address': address,
    'status': status.toString().split('.').last,
    'reportedAt': reportedAt.toIso8601String(),
    'lat': lat,
    'lng': lng,
    'imageUrl': imageUrl,
    'proofImagePath': proofImagePath,
  };

  static ComplaintStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'assigned':
        return ComplaintStatus.assigned;
      case 'inprogress':
      case 'in_progress':
        return ComplaintStatus.inProgress;
      case 'resolved':
        return ComplaintStatus.resolved;
      case 'escalated':
        return ComplaintStatus.escalated;
      default:
        return ComplaintStatus.assigned;
    }
  }
}

// Keep your original Complaint class for other uses
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