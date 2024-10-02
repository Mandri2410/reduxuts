import 'budget.dart';

class AppState {
  final List<Budget> budgets; // Daftar budget yang dikelola oleh aplikasi

  // Konstruktor dengan nilai default berupa list kosong
  AppState({this.budgets = const []});
}
