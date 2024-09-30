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
      budgets:
          state.budgets.where((budget) => budget != action.budget).toList(),
    );
  }
  return state;
}
