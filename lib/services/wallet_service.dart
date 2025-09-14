import 'package:flutter/material.dart';
import '../models/user_models.dart';
import '../common/logger.dart';

class WalletService {
  static final WalletService _instance = WalletService._internal();
  factory WalletService() => _instance;
  WalletService._internal();

  Wallet? _currentWallet;

  Wallet? get currentWallet => _currentWallet;

  Future<void> initializeWallet(String userId) async {
    // In a real app, this would fetch from a database
    _currentWallet = Wallet(
      id: 'wallet_$userId',
      userId: userId,
      balance: 0.0,
      currency: 'MAD',
      lastUpdated: DateTime.now(),
      isActive: true,
      createdAt: DateTime.now(),
    );
  }

  Future<bool> topUpWallet(double amount, PaymentMethod method) async {
    if (_currentWallet == null) return false;

    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      // Create transaction record (in real app, this would be saved to database)
      final transaction = Transaction(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        walletId: _currentWallet!.id,
        type: TransactionType.topup,
        amount: amount,
        currency: _currentWallet!.currency,
        description: 'Wallet Top-up via ${method.toString().split('.').last}',
        status: TransactionStatus.completed,
        createdAt: DateTime.now(),
      );

      _currentWallet = _currentWallet!.copyWith(
        balance: _currentWallet!.balance + amount,
      );

      // In real app, save transaction to database
      Logger.info('Transaction created: ${transaction.id}',
          tag: 'WalletService');

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> makePayment(
      double amount, String description, String recipientId) async {
    if (_currentWallet == null || _currentWallet!.balance < amount) {
      return false;
    }

    try {
      final transaction = Transaction(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        walletId: _currentWallet!.id,
        type: TransactionType.payment,
        amount: -amount,
        currency: _currentWallet!.currency,
        description: description,
        status: TransactionStatus.completed,
        createdAt: DateTime.now(),
        recipientId: recipientId,
      );

      _currentWallet = _currentWallet!.copyWith(
        balance: _currentWallet!.balance - amount,
      );

      // In real app, save transaction to database
      Logger.info('Payment transaction created: ${transaction.id}',
          tag: 'WalletService');

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> receivePayment(
      double amount, String description, String senderId) async {
    if (_currentWallet == null) return false;

    try {
      final transaction = Transaction(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        walletId: _currentWallet!.id,
        type: TransactionType.received,
        amount: amount,
        currency: _currentWallet!.currency,
        description: description,
        status: TransactionStatus.completed,
        createdAt: DateTime.now(),
        senderId: senderId,
      );

      _currentWallet = _currentWallet!.copyWith(
        balance: _currentWallet!.balance + amount,
      );

      // In real app, save transaction to database
      Logger.info('Received payment transaction created: ${transaction.id}',
          tag: 'WalletService');

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Transaction>> getTransactionHistory() async {
    // In a real app, this would fetch from a database
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      Transaction(
        id: 'tx_001',
        walletId: _currentWallet?.id ?? '',
        type: TransactionType.topup,
        amount: 100.0,
        currency: 'MAD',
        description: 'Initial wallet setup',
        status: TransactionStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      Transaction(
        id: 'tx_002',
        walletId: _currentWallet?.id ?? '',
        type: TransactionType.payment,
        amount: -45.50,
        currency: 'MAD',
        description: 'Order from Chef Fatima',
        status: TransactionStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        recipientId: 'chef_fatima',
      ),
      Transaction(
        id: 'tx_003',
        walletId: _currentWallet?.id ?? '',
        type: TransactionType.topup,
        amount: 50.0,
        currency: 'MAD',
        description: 'Wallet Top-up via card',
        status: TransactionStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  String formatAmount(double amount, {String currency = 'MAD'}) {
    return '${amount.toStringAsFixed(2)} $currency';
  }

  Color getTransactionColor(TransactionType type) {
    switch (type) {
      case TransactionType.topup:
      case TransactionType.received:
        return Colors.green;
      case TransactionType.payment:
      case TransactionType.payout:
        return Colors.red;
      case TransactionType.refund:
        return Colors.blue;
      case TransactionType.fee:
      case TransactionType.commission:
        return Colors.orange;
      case TransactionType.withdrawal:
        return Colors.purple;
    }
  }

  IconData getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.topup:
        return Icons.add_circle;
      case TransactionType.payment:
        return Icons.remove_circle;
      case TransactionType.received:
        return Icons.arrow_downward;
      case TransactionType.payout:
        return Icons.arrow_upward;
      case TransactionType.refund:
        return Icons.refresh;
      case TransactionType.fee:
      case TransactionType.commission:
        return Icons.percent;
      case TransactionType.withdrawal:
        return Icons.account_balance;
    }
  }
}

extension WalletExtension on Wallet {
  Wallet copyWith({
    String? id,
    String? userId,
    double? balance,
    String? currency,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return Wallet(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? DateTime.now(),
    );
  }
}
