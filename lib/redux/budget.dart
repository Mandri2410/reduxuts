class Budget {
  final String name;
  final double amount;
  final bool isExpense; // Menyimpan status pengeluaran

  // Constructor dengan isExpense sebagai named parameter
  Budget(this.name, this.amount, {this.isExpense = false});
}
