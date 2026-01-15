class DoctorInfo {
  final String name;
  final String address;
  final String distance;
  final String specialization;
  
  DoctorInfo({
    required this.name,
    required this.address,
    required this.distance,
    required this.specialization,
  });
  
  factory DoctorInfo.fromJson(Map<String, dynamic> json) {
    return DoctorInfo(
      name: json['name'] as String,
      address: json['address'] as String,
      distance: json['distance'] as String,
      specialization: json['specialization'] as String,
    );
  }
}