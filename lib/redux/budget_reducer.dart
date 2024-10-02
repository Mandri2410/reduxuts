import 'app_state.dart';
import 'budget.dart';

// Definisi action untuk menghapus budget
class RemoveBudgetAction {
  final Budget budget; // Budget yang ingin dihapus

  RemoveBudgetAction(
      this.budget); // Konstruktor menerima budget yang akan dihapus
}

// Definisi action untuk menambahkan budget
class AddBudgetAction {
  final Budget budget; // Budget yang ingin ditambahkan

  AddBudgetAction(
      this.budget); // Konstruktor menerima budget yang akan ditambahkan
}

// Reducer yang memproses aksi dan mengubah state aplikasi
AppState budgetReducer(AppState state, dynamic action) {
  // Jika action adalah AddBudgetAction
  if (action is AddBudgetAction) {
    return AppState(
      budgets: List.from(state.budgets)
        ..add(action.budget), // Tambah budget ke dalam daftar
    );
  }
  // Jika action adalah RemoveBudgetAction
  else if (action is RemoveBudgetAction) {
    return AppState(
      budgets: List.from(state.budgets)
        ..remove(action.budget), // Hapus budget dari daftar
    );
  }

  // Jika tidak ada action yang cocok, kembalikan state tanpa perubahan
  return state;
}
