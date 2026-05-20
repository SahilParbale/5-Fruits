import 'package:flutter/material.dart';
import '../models/upi_model.dart';

class UPIProvider with ChangeNotifier {
  final List<UPIModel> _upis = [
    UPIModel(
      id: '1',
      providerName: 'Google Pay',
      upiId: 'sarah@oksbi',
      isDefault: true,
    ),
    UPIModel(
      id: '2',
      providerName: 'PhonePe',
      upiId: 'sarah.johnson@ybl',
      isDefault: false,
    ),
  ];

  List<UPIModel> get upis => [..._upis];

  void addUPI(UPIModel upi) {
    if (upi.isDefault) {
      _unsetDefaultUPIs();
    }
    _upis.add(upi);
    notifyListeners();
  }

  void deleteUPI(String id) {
    _upis.removeWhere((u) => u.id == id);
    notifyListeners();
  }

  void updateUPI(String id, UPIModel updatedUPI) {
    final index = _upis.indexWhere((u) => u.id == id);
    if (index != -1) {
      if (updatedUPI.isDefault) {
        _unsetDefaultUPIs();
      }
      _upis[index] = updatedUPI;
      notifyListeners();
    }
  }

  void setDefault(String id) {
    for (var i = 0; i < _upis.length; i++) {
      if (_upis[i].id == id) {
        _upis[i] = _upis[i].copyWith(isDefault: true);
      } else if (_upis[i].isDefault) {
        _upis[i] = _upis[i].copyWith(isDefault: false);
      }
    }
    notifyListeners();
  }

  void _unsetDefaultUPIs() {
    for (var i = 0; i < _upis.length; i++) {
      if (_upis[i].isDefault) {
        _upis[i] = _upis[i].copyWith(isDefault: false);
      }
    }
  }
}
