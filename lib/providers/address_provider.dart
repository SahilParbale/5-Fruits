import 'package:flutter/material.dart';
import '../models/address_model.dart';
import '../theme/app_theme.dart';

class AddressProvider with ChangeNotifier {
  final List<Address> _addresses = [
    Address(
      id: '1',
      label: 'Home',
      name: 'Sahil Sharma',
      address: '123 MG Road, Andheri West, Mumbai 400053',
      phone: '+91 98765 43210',
      isDefault: true,
      icon: Icons.home_rounded,
      iconColor: Colors.white,
      iconBgColor: const Color(0xFF1B1B1B),
    ),
    Address(
      id: '2',
      label: 'Work',
      name: 'Sahil Sharma',
      address: '456 Link Road, Malad West, Mumbai 400064',
      phone: '+91 98765 43210',
      isDefault: false,
      icon: Icons.work_rounded,
      iconColor: Colors.white,
      iconBgColor: const Color(0xFF1B1B1B),
    ),
    Address(
      id: '3',
      label: "Mom's House",
      name: 'Sahil Sharma',
      address: '789 SV Road, Borivali West, Mumbai 400092',
      phone: '+91 98765 12345',
      isDefault: false,
      icon: Icons.favorite_rounded,
      iconColor: Colors.white,
      iconBgColor: const Color(0xFF1B1B1B),
    ),
  ];

  List<Address> get addresses => [..._addresses];

  void deleteAddress(String id) {
    _addresses.removeWhere((address) => address.id == id);
    notifyListeners();
  }

  void updateAddress(Address updatedAddress) {
    final index = _addresses.indexWhere((address) => address.id == updatedAddress.id);
    if (index != -1) {
      if (updatedAddress.isDefault) {
        // Unset any other default address
        for (var i = 0; i < _addresses.length; i++) {
          if (_addresses[i].isDefault && _addresses[i].id != updatedAddress.id) {
            _addresses[i] = _addresses[i].copyWith(isDefault: false);
          }
        }
      }
      _addresses[index] = updatedAddress;
      notifyListeners();
    }
  }

  void addAddress(Address address) {
    if (address.isDefault) {
      // Unset any other default address
      for (var i = 0; i < _addresses.length; i++) {
        if (_addresses[i].isDefault) {
          _addresses[i] = _addresses[i].copyWith(isDefault: false);
        }
      }
    }
    _addresses.add(address);
    notifyListeners();
  }

  void setDefault(String id) {
    for (var i = 0; i < _addresses.length; i++) {
      if (_addresses[i].id == id) {
        _addresses[i] = _addresses[i].copyWith(isDefault: true);
      } else if (_addresses[i].isDefault) {
        _addresses[i] = _addresses[i].copyWith(isDefault: false);
      }
    }
    notifyListeners();
  }

  void setDetectedGPSAddress(String addressText, double lat, double lng) {
    final index = _addresses.indexWhere((address) => address.id == 'gps_detected');
    final gpsAddress = Address(
      id: 'gps_detected',
      label: 'Detected Location',
      name: 'Sahil Sharma',
      address: addressText,
      phone: '+91 98765 43210',
      isDefault: true,
      icon: Icons.my_location_rounded,
      iconColor: Colors.white,
      iconBgColor: const Color(0xFF1ABC9C),
      latitude: lat,
      longitude: lng,
    );

    if (index != -1) {
      _addresses[index] = gpsAddress;
    } else {
      _addresses.insert(0, gpsAddress);
    }

    for (var i = 0; i < _addresses.length; i++) {
      if (_addresses[i].id != 'gps_detected') {
        _addresses[i] = _addresses[i].copyWith(isDefault: false);
      }
    }
    notifyListeners();
  }
}
