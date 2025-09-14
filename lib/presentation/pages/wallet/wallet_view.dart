import 'package:flutter/material.dart';
import 'package:food_delivery/core/theme/color_extension.dart';
import 'package:food_delivery/data/models/user_models.dart';
import 'package:food_delivery/data/repositories/wallet_service.dart';
import 'package:food_delivery/presentation/widgets/round_button.dart';

class WalletView extends StatefulWidget {
  const WalletView({super.key});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  final WalletService _walletService = WalletService();
  List<Transaction> transactions = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTransactionHistory();
  }

  void _loadTransactionHistory() async {
    setState(() {
      isLoading = true;
    });

    transactions = await _walletService.getTransactionHistory();

    setState(() {
      isLoading = false;
    });
  }

  void _showTopUpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const TopUpDialog();
      },
    ).then((_) {
      _loadTransactionHistory();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final wallet = _walletService.currentWallet;

    return Scaffold(
      backgroundColor: const Color(0xFFF5E6B8),
      appBar: AppBar(
        backgroundColor: TColor.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          "My Wallet",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: wallet == null
          ? const Center(
              child: Text(
                "Wallet not initialized",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                // Wallet Balance Card
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [TColor.primary, TColor.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: TColor.cardShadow,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Available Balance",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _walletService.formatAmount(wallet.balance),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      RoundButton(
                        title: "Top Up Wallet",
                        onPressed: _showTopUpDialog,
                        type: RoundButtonType.bgPrimary,
                      ),
                    ],
                  ),
                ),

                // Transaction History
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Recent Transactions",
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                onPressed: _loadTransactionHistory,
                                icon: Icon(
                                  Icons.refresh,
                                  color: TColor.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : transactions.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.receipt_long,
                                            size: 64,
                                            color: Colors.grey[400],
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            "No transactions yet",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: transactions.length,
                                      itemBuilder: (context, index) {
                                        final transaction = transactions[index];
                                        return TransactionCard(
                                            transaction: transaction);
                                      },
                                    ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final walletService = WalletService();
    final isCredit = transaction.amount > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: TColor.cardShadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: walletService
                  .getTransactionColor(transaction.type)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              walletService.getTransactionIcon(transaction.type),
              color: walletService.getTransactionColor(transaction.type),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(transaction.createdAt),
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "${isCredit ? '+' : ''}${walletService.formatAmount(transaction.amount)}",
            style: TextStyle(
              color: isCredit ? TColor.success : TColor.error,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return "Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }
}

class TopUpDialog extends StatefulWidget {
  const TopUpDialog({super.key});

  @override
  State<TopUpDialog> createState() => _TopUpDialogState();
}

class _TopUpDialogState extends State<TopUpDialog> {
  final TextEditingController _amountController = TextEditingController();
  PaymentMethod _selectedMethod = PaymentMethod.creditCard;
  bool _isLoading = false;

  final List<double> quickAmounts = [50, 100, 200, 500];

  void _selectQuickAmount(double amount) {
    _amountController.text = amount.toString();
  }

  void _topUpWallet() async {
    if (_amountController.text.isEmpty) return;

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid amount")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final walletService = WalletService();
    final success = await walletService.topUpWallet(amount, _selectedMethod);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Wallet topped up successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Top-up failed. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Top Up Wallet",
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Quick Amount Buttons
            Text(
              "Quick amounts (MAD)",
              style: TextStyle(
                color: TColor.secondaryText,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: quickAmounts.map((amount) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: OutlinedButton(
                      onPressed: () => _selectQuickAmount(amount),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: TColor.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        amount.toInt().toString(),
                        style: TextStyle(color: TColor.primary),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Amount Input
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Amount (MAD)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.monetization_on),
              ),
            ),
            const SizedBox(height: 20),

            // Payment Method
            Text(
              "Payment Method",
              style: TextStyle(
                color: TColor.secondaryText,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<PaymentMethod>(
              value: _selectedMethod,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: PaymentMethod.values.map((method) {
                return DropdownMenuItem<PaymentMethod>(
                  value: method,
                  child: Text(_getPaymentMethodName(method)),
                );
              }).toList(),
              onChanged: (PaymentMethod? value) {
                if (value != null) {
                  setState(() {
                    _selectedMethod = value;
                  });
                }
              },
            ),
            const SizedBox(height: 30),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _topUpWallet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColor.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text("Top Up"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getPaymentMethodName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.creditCard:
        return "Credit Card";
      case PaymentMethod.debitCard:
        return "Debit Card";
      case PaymentMethod.bankTransfer:
        return "Bank Transfer";
      case PaymentMethod.cash:
        return "Cash";
    }
  }
}
