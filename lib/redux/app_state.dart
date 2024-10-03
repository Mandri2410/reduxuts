import 'budget.dart';

class AppState {
  final List<Budget> budgets; // Daftar budget yang dikelola oleh aplikasi

  // menyimpan state aplikasi berupa list
  AppState({this.budgets = const []});
}
