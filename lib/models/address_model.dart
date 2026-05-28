import 'package:flutter/material.dart';

class Address {
  final String id;
  final String label;
  final String name;
  final String address;
  final String phone;
  final bool isDefault;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final double? latitude;
  final double? longitude;

  Address({
    required this.id,
    required this.label,
    required this.name,
    required this.address,
    required this.phone,
    required this.isDefault,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    this.latitude,
    this.longitude,
  });

  Address copyWith({
    String? id,
    String? label,
    String? name,
    String? address,
    String? phone,
    bool? isDefault,
    IconData? icon,
    Color? iconColor,
    Color? iconBgColor,
    double? latitude,
    double? longitude,
  }) {
    return Address(
      id: id ?? this.id,
      label: label ?? this.label,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      isDefault: isDefault ?? this.isDefault,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      iconBgColor: iconBgColor ?? this.iconBgColor,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
