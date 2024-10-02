import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'redux/app_state.dart';
import 'redux/budget.dart';
import 'redux/budget_reducer.dart';

class HomePage extends StatelessWidget {
  // Warna-warna utama untuk desain UI
  final Color primaryColor = Color(0xFF5C6BC0);
  final Color accentColor = Color(0xFF3949AB);
  final Color incomeColor = Color(0xFF66BB6A);
  final Color expenseColor = Color(0xFFEF5350);
  final Color backgroundColor = Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    // Menggunakan StoreConnector untuk menghubungkan state budgets ke widget
    return StoreConnector<AppState, List<Budget>>(
      converter: (store) =>
          store.state.budgets, // Mengambil list budgets dari state
      builder: (context, budgets) {
        // Menghitung total income dan total expenses
        double totalIncome = budgets
            .where((b) => !b.isExpense) // Hanya income
            .fold(0.0, (sum, b) => sum + b.amount);
        double totalExpenses = budgets
            .where((b) => b.isExpense) // Hanya expenses
            .fold(0.0, (sum, b) => sum + b.amount);
        double total = totalIncome - totalExpenses;

        return Scaffold(
          backgroundColor: backgroundColor,
          body: CustomScrollView(
            slivers: [
              _buildAppBar(
                  context, total), // Membuat AppBar dengan total balance
              SliverToBoxAdapter(
                  child: _buildSummaryCards(totalIncome,
                      totalExpenses)), // Kartu summary income dan expenses
              SliverToBoxAdapter(
                  child:
                      _buildRecentTransactionsHeader()), // Header recent transactions
              _buildTransactionsList(context, budgets), // Daftar transaksi
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddBudgetDialog(
                context), // Memunculkan dialog untuk menambah transaksi
            child: Icon(Icons.add),
            backgroundColor: accentColor,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  // Membuat AppBar dengan informasi total balance
  Widget _buildAppBar(BuildContext context, double total) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primaryColor, accentColor],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total Balance',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '').format(total)}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Membuat kartu ringkasan income dan expenses
  Widget _buildSummaryCards(double income, double expenses) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
              child: _buildSummaryCard(
                  'Income', income, incomeColor, Icons.arrow_upward)),
          SizedBox(width: 16),
          Expanded(
              child: _buildSummaryCard(
                  'Expenses', expenses, expenseColor, Icons.arrow_downward)),
        ],
      ),
    );
  }

  // Membuat kartu ringkasan individual
  Widget _buildSummaryCard(
      String title, double amount, Color color, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                SizedBox(width: 8),
                Text(title,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '').format(amount)}',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  // Membuat header untuk daftar transaksi terbaru
  Widget _buildRecentTransactionsHeader() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'Recent Transactions',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
      ),
    );
  }

  // Membuat daftar transaksi yang bisa dihapus dengan geser (swipe)
  Widget _buildTransactionsList(BuildContext context, List<Budget> budgets) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final budget = budgets[index];
          return Dismissible(
            key: Key(budget.name + budget.amount.toString()),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              StoreProvider.of<AppState>(context).dispatch(
                  RemoveBudgetAction(budget)); // Menghapus budget dari state
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${budget.name} removed')),
              );
            },
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      budget.isExpense ? expenseColor : incomeColor,
                  child: Icon(
                    budget.isExpense ? Icons.remove : Icons.add,
                    color: Colors.white,
                  ),
                ),
                title: Text(budget.name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(budget.isExpense ? 'Expense' : 'Income'),
                trailing: Text(
                  'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '').format(budget.amount)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: budget.isExpense ? expenseColor : incomeColor,
                  ),
                ),
              ),
            ),
          );
        },
        childCount: budgets.length,
      ),
    );
  }

  // Menampilkan dialog untuk menambahkan budget
  void _showAddBudgetDialog(BuildContext context) {
    String name = '';
    String amount = '';
    bool isExpense = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Transaction'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) =>
                          name = value, // Menangkap input name
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          amount = value, // Menangkap input amount
                    ),
                    SizedBox(height: 16),
                    SwitchListTile(
                      title: Text('Is Expense?'),
                      value: isExpense,
                      onChanged: (value) {
                        setState(() {
                          isExpense =
                              value; // Menentukan apakah transaksi expense atau income
                        });
                      },
                      activeColor: accentColor,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(), // Tutup dialog
                ),
                ElevatedButton(
                  child: Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (name.isNotEmpty && amount.isNotEmpty) {
                      final budget = Budget(name, double.parse(amount),
                          isExpense: isExpense); // Membuat objek Budget baru
                      StoreProvider.of<AppState>(context).dispatch(
                          AddBudgetAction(budget)); // Menambah budget ke state
                      Navigator.of(context).pop(); // Tutup dialog
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
