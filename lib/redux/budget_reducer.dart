import 'app_state.dart';
import 'budget.dart';

class RemoveBudgetAction {
  final Budget budget;

  RemoveBudgetAction(this.budget);
}

class AddBudgetAction {
  final Budget budget;

  AddBudgetAction(this.budget);
}

AppState budgetReducer(AppState state, dynamic action) {
  if (action is AddBudgetAction) {
    return AppState(
      budgets: List.from(state.budgets)..add(action.budget),
    );
  } else if (action is RemoveBudgetAction) {
    return AppState(
      budgets: List.from(state.budgets)..remove(action.budget),
    );
  }

  return state; // Kembalikan state jika tidak ada aksi yang cocok
}
