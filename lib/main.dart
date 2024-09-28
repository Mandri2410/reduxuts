import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart'; // Impor ini penting
import 'redux/app_state.dart';
import 'redux/budget_reducer.dart';
import 'home_page.dart';

void main() {
  final store = Store<AppState>(
    budgetReducer,
    initialState: AppState(),
  );

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp({required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Budget Manager',
        home: HomePage(),
      ),
    );
  }
}
