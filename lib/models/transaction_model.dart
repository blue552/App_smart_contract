class TransactionModel {
  final String address;
  final double amount;
  final String reason;
  final DateTime timestamp;

  TransactionModel(this.address, this.amount, this.reason, this.timestamp);
}
