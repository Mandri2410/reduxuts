import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart'; // Impor ini penting untuk menggunakan Redux
import 'redux/app_state.dart';
import 'redux/budget_reducer.dart';
import 'home_page.dart';

void main() {
  // Membuat store Redux yang mengelola state aplikasi
  final store = Store<AppState>(
    budgetReducer, // Reducer yang mengelola perubahan state berdasarkan actions
    initialState:
        AppState(), // State awal aplikasi didefinisikan dengan instance AppState
  );

  // Memulai aplikasi dengan memberikan store Redux ke MyApp
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  // Konstruktor MyApp menerima `store` sebagai parameter yang wajib diisi
  MyApp({required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store:
          store, // Memberikan store Redux ke StoreProvider agar bisa diakses di seluruh widget tree
      child: MaterialApp(
        title: 'Budget Manager', // Judul aplikasi
        home: HomePage(), // Menentukan halaman awal aplikasi yaitu HomePage
      ),
    );
  }
}
