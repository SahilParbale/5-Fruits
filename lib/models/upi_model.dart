class UPIModel {
  final String id;
  final String providerName;
  final String upiId;
  final bool isVerified;
  final bool isDefault;

  UPIModel({
    required this.id,
    required this.providerName,
    required this.upiId,
    this.isVerified = true,
    this.isDefault = false,
  });

  UPIModel copyWith({
    String? id,
    String? providerName,
    String? upiId,
    bool? isVerified,
    bool? isDefault,
  }) {
    return UPIModel(
      id: id ?? this.id,
      providerName: providerName ?? this.providerName,
      upiId: upiId ?? this.upiId,
      isVerified: isVerified ?? this.isVerified,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
