import 'package:flutter/material.dart';
import '../models/card_model.dart';

class CardProvider with ChangeNotifier {
  final List<PaymentCard> _cards = [
    PaymentCard(
      id: '1',
      type: 'Visa',
      number: '•••• •••• •••• 4532',
      holder: 'Sahil Sharma',
      expiryMonth: '12',
      expiryYear: '25',
      cvv: '123',
      isDefault: true,
    ),
    PaymentCard(
      id: '2',
      type: 'Mastercard',
      number: '•••• •••• •••• 8765',
      holder: 'Sahil Sharma',
      expiryMonth: '08',
      expiryYear: '26',
      cvv: '456',
      isDefault: false,
    ),
  ];

  List<PaymentCard> get cards => [..._cards];

  void addCard(PaymentCard card) {
    if (card.isDefault) {
      _unsetDefaultCards();
    }
    _cards.add(card);
    notifyListeners();
  }

  void updateCard(PaymentCard updatedCard) {
    final index = _cards.indexWhere((c) => c.id == updatedCard.id);
    if (index != -1) {
      if (updatedCard.isDefault) {
        _unsetDefaultCards(excludeId: updatedCard.id);
      }
      _cards[index] = updatedCard;
      notifyListeners();
    }
  }

  void deleteCard(String id) {
    _cards.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  void setDefault(String id) {
    for (var i = 0; i < _cards.length; i++) {
      if (_cards[i].id == id) {
        _cards[i] = _cards[i].copyWith(isDefault: true);
      } else if (_cards[i].isDefault) {
        _cards[i] = _cards[i].copyWith(isDefault: false);
      }
    }
    notifyListeners();
  }

  void _unsetDefaultCards({String? excludeId}) {
    for (var i = 0; i < _cards.length; i++) {
      if (_cards[i].isDefault && _cards[i].id != excludeId) {
        _cards[i] = _cards[i].copyWith(isDefault: false);
      }
    }
  }
}
