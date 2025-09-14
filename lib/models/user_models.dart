class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserType userType;
  final String? profileImage;
  final DateTime createdAt;
  final bool isActive;
  final String? address;
  final Wallet wallet;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    this.profileImage,
    required this.createdAt,
    this.isActive = true,
    this.address,
    required this.wallet,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      userType: UserType.values.firstWhere(
        (e) => e.toString().split('.').last == json['user_type'],
      ),
      profileImage: json['profile_image'],
      createdAt: DateTime.parse(json['created_at']),
      isActive: json['is_active'] ?? true,
      address: json['address'],
      wallet: Wallet.fromJson(json['wallet']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'user_type': userType.toString().split('.').last,
      'profile_image': profileImage,
      'created_at': createdAt.toIso8601String(),
      'is_active': isActive,
      'address': address,
      'wallet': wallet.toJson(),
    };
  }
}

enum UserType {
  customer,
  chef,
  courier,
}

class Wallet {
  final String id;
  final String userId;
  final double balance;
  final String currency;
  final DateTime lastUpdated;
  final bool isActive;
  final DateTime createdAt;

  Wallet({
    required this.id,
    required this.userId,
    required this.balance,
    this.currency = 'MAD', // Moroccan Dirham
    required this.lastUpdated,
    this.isActive = true,
    required this.createdAt,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'],
      userId: json['user_id'],
      balance: json['balance'].toDouble(),
      currency: json['currency'] ?? 'MAD',
      lastUpdated: DateTime.parse(json['last_updated']),
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'balance': balance,
      'currency': currency,
      'last_updated': lastUpdated.toIso8601String(),
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class Transaction {
  final String id;
  final String walletId;
  final TransactionType type;
  final double amount;
  final String currency;
  final String description;
  final TransactionStatus status;
  final DateTime createdAt;
  final String? orderId;
  final String? fromUserId;
  final String? toUserId;
  final String? recipientId;
  final String? senderId;

  Transaction({
    required this.id,
    required this.walletId,
    required this.type,
    required this.amount,
    this.currency = 'MAD',
    required this.description,
    required this.status,
    required this.createdAt,
    this.orderId,
    this.fromUserId,
    this.toUserId,
    this.recipientId,
    this.senderId,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      walletId: json['wallet_id'],
      type: TransactionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      amount: json['amount'].toDouble(),
      currency: json['currency'] ?? 'MAD',
      description: json['description'],
      status: TransactionStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      createdAt: DateTime.parse(json['created_at']),
      orderId: json['order_id'],
      fromUserId: json['from_user_id'],
      toUserId: json['to_user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wallet_id': walletId,
      'type': type.toString().split('.').last,
      'amount': amount,
      'currency': currency,
      'description': description,
      'status': status.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
      'order_id': orderId,
      'from_user_id': fromUserId,
      'to_user_id': toUserId,
      'recipient_id': recipientId,
      'sender_id': senderId,
    };
  }
}

enum TransactionType {
  topup,
  payment,
  payout,
  commission,
  refund,
  withdrawal,
  received,
  fee,
}

enum TransactionStatus {
  pending,
  completed,
  failed,
  cancelled,
}

enum PaymentMethod {
  creditCard,
  debitCard,
  bankTransfer,
  cash,
}
