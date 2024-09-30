class Budget {
  final String name;
  final double amount;
  final bool isExpense;

  Budget(this.name, this.amount, {this.isExpense = false});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Budget &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          amount == other.amount &&
          isExpense == other.isExpense;

  @override
  int get hashCode => name.hashCode ^ amount.hashCode ^ isExpense.hashCode;
}
